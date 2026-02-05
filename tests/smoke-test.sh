#!/usr/bin/env bash
set -euo pipefail

# Smoke test runner for Helm chart integration tests.
# Usage: ./tests/smoke-test.sh <chart> <release-name> <values-file>
#
# Installs the chart, waits for readiness, runs connectivity checks,
# then tears everything down. Exits non-zero on any failure.

CHART="$1"
RELEASE="$2"
VALUES="$3"
NAMESPACE="test-${RELEASE}"
TIMEOUT="300s"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail() {
    echo -e "${RED}[FAIL]${NC} $*"
    dump_debug
    exit 1
}

dump_debug() {
    echo ""
    echo "=== DEBUG: Pods ==="
    kubectl get pods -n "${NAMESPACE}" -o wide 2>/dev/null || true
    echo ""
    echo "=== DEBUG: StatefulSets ==="
    kubectl get statefulsets -n "${NAMESPACE}" -o wide 2>/dev/null || true
    echo ""
    echo "=== DEBUG: PVCs ==="
    kubectl get pvc -n "${NAMESPACE}" -o wide 2>/dev/null || true
    echo ""
    echo "=== DEBUG: Services ==="
    kubectl get svc -n "${NAMESPACE}" 2>/dev/null || true
    echo ""
    echo "=== DEBUG: Events (last 50) ==="
    kubectl get events -n "${NAMESPACE}" --sort-by='.lastTimestamp' 2>/dev/null | tail -50 || true
    echo ""
    echo "=== DEBUG: Describe Pods ==="
    kubectl describe pods -n "${NAMESPACE}" 2>/dev/null || true
    echo ""
    echo "=== DEBUG: Pod Logs ==="
    for pod in $(kubectl get pods -n "${NAMESPACE}" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
        echo "--- Logs: ${pod} ---"
        kubectl logs -n "${NAMESPACE}" "${pod}" --all-containers --tail=100 2>/dev/null || true
        echo "--- Previous Logs: ${pod} ---"
        kubectl logs -n "${NAMESPACE}" "${pod}" --all-containers --previous --tail=50 2>/dev/null || true
    done
}

cleanup() {
    echo "--- Cleaning up ${RELEASE} in ${NAMESPACE} ---"
    helm uninstall "${RELEASE}" -n "${NAMESPACE}" --wait 2>/dev/null || true
    kubectl delete namespace "${NAMESPACE}" --wait=false 2>/dev/null || true
}
trap cleanup EXIT

# ── Install ──────────────────────────────────────────────────────────
echo "=== Testing ${CHART} with ${VALUES} ==="
kubectl create namespace "${NAMESPACE}" 2>/dev/null || true
helm install "${RELEASE}" "charts/${CHART}" \
    -n "${NAMESPACE}" \
    -f "${VALUES}" \
    --wait \
    --timeout "${TIMEOUT}" \
    || fail "helm install failed for ${CHART} (${VALUES})"

log "Helm install succeeded"

# ── Wait for workloads ───────────────────────────────────────────────
case "${CHART}" in
    redis|postgresql|rabbitmq)
        kubectl rollout status statefulset -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --timeout="${TIMEOUT}" \
            || fail "StatefulSet rollout failed"
        log "StatefulSet is ready"
        ;;
    kubectl)
        # For jobs, wait for completion
        if kubectl get cronjob -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --no-headers 2>/dev/null | grep -q .; then
            log "CronJob created (schedule-based, skipping completion wait)"
        else
            kubectl wait --for=condition=complete job -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --timeout="${TIMEOUT}" \
                || fail "Job did not complete"
            log "Job completed successfully"
        fi
        ;;
esac

# ── Connectivity / smoke checks ─────────────────────────────────────
case "${CHART}" in
    redis)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}-master"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')

        # Check if auth is enabled by looking at the secret
        if kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" &>/dev/null; then
            REDIS_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.redis-password}' | base64 -d)
            AUTH_ARGS="-a '${REDIS_PASS}'"
            echo "Auth enabled, using password from secret"
        else
            AUTH_ARGS=""
            echo "Auth disabled, no password"
        fi

        echo "Testing Redis at ${SVC}:${PORT}..."

        # PING test with retry
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "redis-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=redis:alpine -- \
                sh -c "redis-cli -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} PING" 2>&1) || true
            echo "PING attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "PONG"; then
                break
            fi
            sleep 2
        done
        echo "${RESULT}" | grep -q "PONG" || fail "Redis PING/PONG failed after 3 attempts"
        log "Redis PING -> PONG"

        # SET/GET test
        RESULT=$(kubectl run redis-write --rm -i --restart=Never -n "${NAMESPACE}" \
            --image=redis:alpine -- \
            sh -c "redis-cli -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} SET smoketest ok && redis-cli -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} GET smoketest" 2>&1) || true
        echo "SET/GET result: ${RESULT}"
        echo "${RESULT}" | grep -q "ok" || fail "Redis SET/GET failed"
        log "Redis SET/GET works"
        ;;

    postgresql)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')
        PG_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.postgres-password}' | base64 -d)

        # Wait for service endpoints to be ready
        echo "Waiting for PostgreSQL service endpoints..."
        for i in $(seq 1 30); do
            ENDPOINTS=$(kubectl get endpoints -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null || echo "")
            if [ -n "${ENDPOINTS}" ]; then
                echo "Service endpoints ready: ${ENDPOINTS}"
                break
            fi
            echo "Waiting for endpoints... ($i/30)"
            sleep 2
        done

        # check connectivity with retry
        echo "Testing PostgreSQL connectivity..."
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run pg-smoke-${attempt} --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=postgres:alpine \
                --env="PGPASSWORD=${PG_PASS}" -- \
                psql -h "${SVC}" -p "${PORT}" -U postgres -c "SELECT 1 AS smoke_test;" 2>&1) || true
            echo "Attempt ${attempt} result: ${RESULT}"
            if echo "${RESULT}" | grep -q "1"; then
                break
            fi
            sleep 3
        done
        echo "${RESULT}" | grep -q "1" || fail "PostgreSQL SELECT 1 failed after 3 attempts"
        log "PostgreSQL SELECT 1 works"

        # check custom database/user if configured
        DB=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; v=json.load(sys.stdin); print(v.get('auth',{}).get('database',''))" 2>/dev/null || echo "")
        USER=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; v=json.load(sys.stdin); print(v.get('auth',{}).get('username',''))" 2>/dev/null || echo "")

        if [ -n "${DB}" ] && [ -n "${USER}" ]; then
            USER_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.password}' | base64 -d)
            kubectl run pg-user --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=postgres:alpine \
                --env="PGPASSWORD=${USER_PASS}" -- \
                psql -h "${SVC}" -p "${PORT}" -U "${USER}" -d "${DB}" -c "SELECT current_database(), current_user;" \
                | grep -q "${DB}" \
                || fail "PostgreSQL custom user/db check failed"
            log "PostgreSQL custom user '${USER}' + db '${DB}' verified"
        fi
        ;;

    rabbitmq)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        MGMT_PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="http-stats")].port}')
        AMQP_PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="amqp")].port}')
        RMQ_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.rabbitmq-password}' | base64 -d)
        RMQ_USER=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; print(json.load(sys.stdin).get('auth',{}).get('username','guest'))" 2>/dev/null || echo "guest")

        # management API health check
        kubectl run rmq-smoke --rm -i --restart=Never -n "${NAMESPACE}" \
            --image=curlimages/curl -- \
            curl -sf -u "${RMQ_USER}:${RMQ_PASS}" "http://${SVC}:${MGMT_PORT}/api/healthchecks/node" \
            | grep -q "ok" \
            || fail "RabbitMQ management API health check failed"
        log "RabbitMQ management API healthy"

        # AMQP port connectivity
        kubectl run rmq-amqp --rm -i --restart=Never -n "${NAMESPACE}" \
            --image=busybox -- \
            sh -c "nc -zv ${SVC} ${AMQP_PORT} 2>&1" \
            | grep -qE "(open|succeeded)" \
            || fail "RabbitMQ AMQP port not reachable"
        log "RabbitMQ AMQP port reachable"
        ;;

    kubectl)
        # check job/cronjob logs
        if kubectl get cronjob -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --no-headers 2>/dev/null | grep -q .; then
            CJ_NAME=$(kubectl get cronjob -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" -o jsonpath='{.items[0].metadata.name}')
            log "CronJob '${CJ_NAME}' exists with schedule"
        else
            JOB_NAME=$(kubectl get job -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" -o jsonpath='{.items[0].metadata.name}')
            LOGS=$(kubectl logs -n "${NAMESPACE}" "job/${JOB_NAME}" 2>/dev/null || echo "")
            if [ -n "${LOGS}" ]; then
                log "kubectl job produced output (${#LOGS} bytes)"
            else
                warn "kubectl job logs empty (may be expected)"
            fi
        fi
        ;;
esac

echo ""
log "All smoke tests passed for ${CHART} (${VALUES})"
