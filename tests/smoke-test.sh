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
    redis|postgresql|rabbitmq|mysql|mariadb|mongodb|kafka|zookeeper|cassandra|openldap)
        kubectl rollout status statefulset -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --timeout="${TIMEOUT}" \
            || fail "StatefulSet rollout failed"
        log "StatefulSet is ready"
        ;;
    memcached|keycloak)
        kubectl rollout status deployment -n "${NAMESPACE}" -l "app.kubernetes.io/instance=${RELEASE}" --timeout="${TIMEOUT}" \
            || fail "Deployment rollout failed"
        log "Deployment is ready"
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

        # Determine service name based on mode
        CLUSTER_ENABLED=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; v=json.load(sys.stdin); print(v.get('cluster',{}).get('enabled',False))" 2>/dev/null || echo "False")
        SENTINEL_ENABLED=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; v=json.load(sys.stdin); print(v.get('sentinel',{}).get('enabled',False))" 2>/dev/null || echo "False")

        if [ "${CLUSTER_ENABLED}" = "True" ]; then
            SVC="${FULLNAME}-cluster"
        elif [ "${SENTINEL_ENABLED}" = "True" ]; then
            SVC="${FULLNAME}-primary"
        else
            SVC="${FULLNAME}"
        fi

        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="tcp-redis")].port}')

        # Check if auth is enabled by looking at the secret
        if kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" &>/dev/null; then
            REDIS_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.redis-password}' | base64 -d)
            AUTH_ARGS="-a '${REDIS_PASS}'"
            echo "Auth enabled, using password from secret"
        else
            AUTH_ARGS=""
            echo "Auth disabled, no password"
        fi

        # Use -c flag for cluster mode (follows MOVED redirects)
        CLUSTER_FLAG=""
        if [ "${CLUSTER_ENABLED}" = "True" ]; then
            CLUSTER_FLAG="-c"
        fi

        echo "Testing Redis (${SVC}:${PORT}, cluster=${CLUSTER_ENABLED}, sentinel=${SENTINEL_ENABLED})..."

        # PING test with retry
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "redis-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=redis:alpine -- \
                sh -c "redis-cli ${CLUSTER_FLAG} -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} PING" 2>&1) || true
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
            sh -c "redis-cli ${CLUSTER_FLAG} -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} SET smoketest ok && redis-cli ${CLUSTER_FLAG} -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} GET smoketest" 2>&1) || true
        echo "SET/GET result: ${RESULT}"
        echo "${RESULT}" | grep -q "ok" || fail "Redis SET/GET failed"
        log "Redis SET/GET works"

        # Replication checks (sentinel or replication mode)
        ARCHITECTURE=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('architecture','standalone'))" 2>/dev/null || echo "standalone")
        if [ "${SENTINEL_ENABLED}" = "True" ] || [ "${ARCHITECTURE}" = "replication" ]; then
            EXPECTED_REPLICAS=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('replica',{}).get('replicaCount',3))" 2>/dev/null || echo "3")
            echo "Checking replication (expected ${EXPECTED_REPLICAS} replicas)..."

            RESULT=""
            for attempt in $(seq 1 10); do
                RESULT=$(kubectl run "redis-repl-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=redis:alpine -- \
                    sh -c "redis-cli -h '${SVC}' -p '${PORT}' ${AUTH_ARGS} INFO replication" 2>&1) || true
                CONNECTED=$(echo "${RESULT}" | grep -o 'connected_slaves:[0-9]*' | cut -d: -f2 || echo "0")
                echo "Replication attempt ${attempt}: connected_slaves=${CONNECTED}"
                if [ "${CONNECTED}" = "${EXPECTED_REPLICAS}" ]; then
                    break
                fi
                sleep 5
            done
            echo "${RESULT}" | grep -q "connected_slaves:${EXPECTED_REPLICAS}" || fail "Expected ${EXPECTED_REPLICAS} connected replicas, got ${CONNECTED}"
            log "Replication: ${EXPECTED_REPLICAS} replicas connected"
        fi

        # Sentinel checks
        if [ "${SENTINEL_ENABLED}" = "True" ]; then
            SENTINEL_SVC="${FULLNAME}-sentinel"
            SENTINEL_PORT=$(kubectl get svc -n "${NAMESPACE}" "${SENTINEL_SVC}" -o jsonpath='{.spec.ports[?(@.name=="tcp-sentinel")].port}' 2>/dev/null || echo "26379")
            echo "Checking Sentinel at ${SENTINEL_SVC}:${SENTINEL_PORT}..."

            RESULT=""
            for attempt in $(seq 1 5); do
                RESULT=$(kubectl run "redis-sent-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=redis:alpine -- \
                    sh -c "redis-cli -h '${SENTINEL_SVC}' -p '${SENTINEL_PORT}' SENTINEL master mymaster" 2>&1) || true
                echo "Sentinel attempt ${attempt}: ${RESULT}"
                if echo "${RESULT}" | grep -q "flags"; then
                    break
                fi
                sleep 5
            done
            echo "${RESULT}" | grep -q "flags" || fail "Sentinel SENTINEL master command failed"
            log "Sentinel monitoring primary"
        fi
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
            echo "Testing custom user '${USER}' on database '${DB}'..."

            RESULT=""
            for attempt in 1 2 3; do
                RESULT=$(kubectl run "pg-user-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=postgres:alpine \
                    --env="PGPASSWORD=${USER_PASS}" -- \
                    psql -h "${SVC}" -p "${PORT}" -U "${USER}" -d "${DB}" -c "SELECT current_database(), current_user;" 2>&1) || true
                echo "Custom user attempt ${attempt}: ${RESULT}"
                if echo "${RESULT}" | grep -q "${DB}"; then
                    break
                fi
                sleep 2
            done
            echo "${RESULT}" | grep -q "${DB}" || fail "PostgreSQL custom user/db check failed"
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

        echo "Testing RabbitMQ at ${SVC} (mgmt: ${MGMT_PORT}, amqp: ${AMQP_PORT})..."

        # management API health check with retry
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "rmq-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=curlimages/curl -- \
                curl -sf -u "${RMQ_USER}:${RMQ_PASS}" "http://${SVC}:${MGMT_PORT}/api/healthchecks/node" 2>&1) || true
            echo "Management API attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "ok"; then
                break
            fi
            sleep 3
        done
        echo "${RESULT}" | grep -q "ok" || fail "RabbitMQ management API health check failed"
        log "RabbitMQ management API healthy"

        # Queue publish/consume test via management API
        echo "Testing queue publish/consume..."
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "rmq-queue-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=curlimages/curl -- \
                sh -c "
                    # Create queue
                    curl -sf -u '${RMQ_USER}:${RMQ_PASS}' -X PUT \
                        -H 'content-type: application/json' \
                        -d '{\"durable\":true}' \
                        'http://${SVC}:${MGMT_PORT}/api/queues/%2F/smoke-test-queue' && \
                    # Publish message
                    curl -sf -u '${RMQ_USER}:${RMQ_PASS}' -X POST \
                        -H 'content-type: application/json' \
                        -d '{\"properties\":{},\"routing_key\":\"smoke-test-queue\",\"payload\":\"hello-smoke\",\"payload_encoding\":\"string\"}' \
                        'http://${SVC}:${MGMT_PORT}/api/exchanges/%2F/amq.default/publish' && \
                    # Consume message
                    curl -sf -u '${RMQ_USER}:${RMQ_PASS}' -X POST \
                        -H 'content-type: application/json' \
                        -d '{\"count\":1,\"ackmode\":\"ack_requeue_false\",\"encoding\":\"auto\"}' \
                        'http://${SVC}:${MGMT_PORT}/api/queues/%2F/smoke-test-queue/get' && \
                    # Delete queue
                    curl -sf -u '${RMQ_USER}:${RMQ_PASS}' -X DELETE \
                        'http://${SVC}:${MGMT_PORT}/api/queues/%2F/smoke-test-queue'
                " 2>&1) || true
            echo "Queue test attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "hello-smoke"; then
                break
            fi
            sleep 3
        done
        echo "${RESULT}" | grep -q "hello-smoke" || fail "RabbitMQ queue publish/consume failed"
        log "RabbitMQ queue publish/consume works"

        # Cluster membership check (if replicaCount > 1)
        REPLICA_COUNT=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('replicaCount',1))" 2>/dev/null || echo "1")
        if [ "${REPLICA_COUNT}" -gt 1 ]; then
            echo "Checking cluster membership (expected ${REPLICA_COUNT} nodes)..."
            RESULT=""
            for attempt in $(seq 1 10); do
                RESULT=$(kubectl run "rmq-cluster-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=curlimages/curl -- \
                    curl -sf -u "${RMQ_USER}:${RMQ_PASS}" "http://${SVC}:${MGMT_PORT}/api/nodes" 2>&1) || true
                RUNNING=$(echo "${RESULT}" | python3 -c "import sys,json; nodes=json.load(sys.stdin); print(sum(1 for n in nodes if n.get('running',False)))" 2>/dev/null || echo "0")
                echo "Cluster attempt ${attempt}: ${RUNNING}/${REPLICA_COUNT} nodes running"
                if [ "${RUNNING}" = "${REPLICA_COUNT}" ]; then
                    break
                fi
                sleep 10
            done
            [ "${RUNNING}" = "${REPLICA_COUNT}" ] || fail "Expected ${REPLICA_COUNT} running nodes, got ${RUNNING}"
            log "RabbitMQ cluster: ${REPLICA_COUNT} nodes running"
        fi
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

    mysql)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')
        MYSQL_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.mysql-root-password}' | base64 -d)

        echo "Testing MySQL at ${SVC}:${PORT}..."

        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "mysql-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=mysql:8 \
                --env="MYSQL_PWD=${MYSQL_PASS}" -- \
                mysql -h "${SVC}" -P "${PORT}" -u root -e "SELECT 1 AS smoke_test;" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "1"; then
                break
            fi
            sleep 5
        done
        echo "${RESULT}" | grep -q "1" || fail "MySQL SELECT 1 failed after 3 attempts"
        log "MySQL SELECT 1 works"

        # Replication check
        ARCHITECTURE=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('architecture','standalone'))" 2>/dev/null || echo "standalone")
        if [ "${ARCHITECTURE}" = "replication" ]; then
            EXPECTED_SECONDARIES=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('secondary',{}).get('replicaCount',2))" 2>/dev/null || echo "2")
            echo "Checking MySQL replication (expected ${EXPECTED_SECONDARIES} secondaries)..."

            RESULT=""
            for attempt in $(seq 1 10); do
                RESULT=$(kubectl run "mysql-repl-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=mysql:8 \
                    --env="MYSQL_PWD=${MYSQL_PASS}" -- \
                    mysql -h "${SVC}" -P "${PORT}" -u root -e "SHOW SLAVE HOSTS;" 2>&1) || true
                CONNECTED=$(echo "${RESULT}" | grep -c "^[0-9]" || echo "0")
                echo "Replication attempt ${attempt}: ${CONNECTED}/${EXPECTED_SECONDARIES} secondaries connected"
                if [ "${CONNECTED}" = "${EXPECTED_SECONDARIES}" ]; then
                    break
                fi
                sleep 10
            done
            [ "${CONNECTED}" = "${EXPECTED_SECONDARIES}" ] || fail "Expected ${EXPECTED_SECONDARIES} secondaries, got ${CONNECTED}"
            log "MySQL replication: ${EXPECTED_SECONDARIES} secondaries connected"
        fi
        ;;

    mariadb)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')
        MARIADB_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.mariadb-root-password}' | base64 -d)

        echo "Testing MariaDB at ${SVC}:${PORT}..."

        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "mariadb-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=mariadb:11 \
                --env="MYSQL_PWD=${MARIADB_PASS}" -- \
                mariadb -h "${SVC}" -P "${PORT}" -u root -e "SELECT 1 AS smoke_test;" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "1"; then
                break
            fi
            sleep 5
        done
        echo "${RESULT}" | grep -q "1" || fail "MariaDB SELECT 1 failed after 3 attempts"
        log "MariaDB SELECT 1 works"

        # Replication check
        ARCHITECTURE=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('architecture','standalone'))" 2>/dev/null || echo "standalone")
        if [ "${ARCHITECTURE}" = "replication" ]; then
            EXPECTED_SECONDARIES=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('secondary',{}).get('replicaCount',2))" 2>/dev/null || echo "2")
            echo "Checking MariaDB replication (expected ${EXPECTED_SECONDARIES} secondaries)..."

            # Check SHOW SLAVE HOSTS on primary
            RESULT=""
            for attempt in $(seq 1 10); do
                RESULT=$(kubectl run "mariadb-repl-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=mariadb:11 \
                    --env="MYSQL_PWD=${MARIADB_PASS}" -- \
                    mariadb -h "${SVC}" -P "${PORT}" -u root -e "SHOW SLAVE HOSTS;" 2>&1) || true
                CONNECTED=$(echo "${RESULT}" | grep -c "^[0-9]" || echo "0")
                echo "Replication attempt ${attempt}: ${CONNECTED}/${EXPECTED_SECONDARIES} secondaries connected"
                if [ "${CONNECTED}" = "${EXPECTED_SECONDARIES}" ]; then
                    break
                fi
                sleep 10
            done
            [ "${CONNECTED}" = "${EXPECTED_SECONDARIES}" ] || fail "Expected ${EXPECTED_SECONDARIES} secondaries, got ${CONNECTED}"
            log "MariaDB replication: ${EXPECTED_SECONDARIES} secondaries connected"
        fi
        ;;

    mongodb)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')

        # Detect architecture
        ARCHITECTURE=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; print(json.load(sys.stdin).get('architecture','standalone'))" 2>/dev/null || echo "standalone")

        # Check if auth is enabled (root password exists in secret)
        MONGO_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.mongodb-root-password}' 2>/dev/null | base64 -d 2>/dev/null || echo "")
        if [ -n "${MONGO_PASS}" ]; then
            AUTH_ARGS="-u root -p '${MONGO_PASS}' --authenticationDatabase admin"
            AUTH_ENABLED="true"
        else
            AUTH_ARGS=""
            AUTH_ENABLED="false"
        fi

        echo "Testing MongoDB at ${SVC}:${PORT} (auth=${AUTH_ENABLED}, architecture=${ARCHITECTURE})..."

        # Ping test
        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "mongo-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=mongo:7 -- \
                mongosh "mongodb://${SVC}:${PORT}" ${AUTH_ARGS} --quiet --eval "db.adminCommand('ping')" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "ok"; then
                break
            fi
            sleep 5
        done
        echo "${RESULT}" | grep -q "ok" || fail "MongoDB ping failed after 3 attempts"
        log "MongoDB ping works"

        # Replica set checks
        if [ "${ARCHITECTURE}" = "replicaset" ]; then
            echo "Checking replica set status..."
            EXPECTED_MEMBERS=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; v=json.load(sys.stdin); print(1 + int(v.get('secondary',{}).get('replicaCount',2)))" 2>/dev/null || echo "3")

            RESULT=""
            for attempt in $(seq 1 5); do
                RESULT=$(kubectl run "mongo-rs-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                    --image=mongo:7 -- \
                    mongosh "mongodb://${SVC}:${PORT}" ${AUTH_ARGS} --quiet --eval "
                        var s = rs.status();
                        print('members=' + s.members.length);
                        print('primary=' + s.members.filter(m => m.stateStr === 'PRIMARY').length);
                        print('secondary=' + s.members.filter(m => m.stateStr === 'SECONDARY').length);
                    " 2>&1) || true
                echo "RS attempt ${attempt}: ${RESULT}"
                if echo "${RESULT}" | grep -q "members=${EXPECTED_MEMBERS}"; then
                    break
                fi
                sleep 10
            done
            echo "${RESULT}" | grep -q "members=${EXPECTED_MEMBERS}" || fail "Expected ${EXPECTED_MEMBERS} replica set members"
            echo "${RESULT}" | grep -q "primary=1" || fail "Expected 1 PRIMARY member"
            log "Replica set has ${EXPECTED_MEMBERS} members (1 PRIMARY + $(( EXPECTED_MEMBERS - 1 )) SECONDARY)"
        fi
        ;;

    memcached)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[0].port}')

        echo "Testing Memcached at ${SVC}:${PORT}..."

        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "memcached-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=alpine -- \
                sh -c "echo stats | nc -w 2 ${SVC} ${PORT}" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "STAT pid"; then
                break
            fi
            sleep 2
        done
        echo "${RESULT}" | grep -q "STAT pid" || fail "Memcached stats failed after 3 attempts"
        log "Memcached stats works"
        ;;

    kafka)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="client")].port}')
        [ -z "${PORT}" ] && PORT=9092

        echo "Testing Kafka at ${SVC}:${PORT}..."

        RESULT=""
        for attempt in 1 2 3 4 5; do
            RESULT=$(kubectl run "kafka-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=confluentinc/cp-kafka:7.5.0 -- \
                kafka-topics --bootstrap-server "${SVC}:${PORT}" --list 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            # Empty list is valid, error messages contain "ERROR" or "Exception"
            if ! echo "${RESULT}" | grep -qE "(ERROR|Exception|refused)"; then
                break
            fi
            sleep 10
        done
        echo "${RESULT}" | grep -qE "(ERROR|Exception|refused)" && fail "Kafka topics list failed after 5 attempts"
        log "Kafka topics list works"
        ;;

    zookeeper)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="client")].port}')
        [ -z "${PORT}" ] && PORT=2181

        echo "Testing Zookeeper at ${SVC}:${PORT}..."

        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "zk-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=alpine -- \
                sh -c "echo ruok | nc -w 2 ${SVC} ${PORT}" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "imok"; then
                break
            fi
            sleep 5
        done
        echo "${RESULT}" | grep -q "imok" || fail "Zookeeper ruok failed after 3 attempts"
        log "Zookeeper ruok -> imok"
        ;;

    cassandra)
        FULLNAME="${RELEASE}"
        POD="${FULLNAME}-0"

        echo "Testing Cassandra at ${POD}..."

        # Cassandra needs longer startup time, use nodetool (cqlsh requires Python 3.6-3.11)
        RESULT=""
        for attempt in $(seq 1 12); do
            RESULT=$(kubectl exec -n "${NAMESPACE}" "${POD}" -- nodetool status 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -qE "^UN"; then
                break
            fi
            sleep 15
        done
        echo "${RESULT}" | grep -qE "^UN" || fail "Cassandra nodetool status failed after 12 attempts"
        log "Cassandra nodetool status shows UN (Up/Normal)"
        ;;

    keycloak)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        HTTP_PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="http")].port}')
        MGMT_PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="management")].port}')
        [ -z "${HTTP_PORT}" ] && HTTP_PORT=8080
        [ -z "${MGMT_PORT}" ] && MGMT_PORT=9000

        echo "Testing Keycloak at ${SVC}:${HTTP_PORT} (mgmt: ${MGMT_PORT})..."

        # Keycloak needs longer startup
        RESULT=""
        for attempt in $(seq 1 10); do
            RESULT=$(kubectl run "kc-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=curlimages/curl -- \
                curl -sf "http://${SVC}:${MGMT_PORT}/health/ready" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "UP"; then
                break
            fi
            sleep 10
        done
        echo "${RESULT}" | grep -q "UP" || fail "Keycloak health check failed after 10 attempts"
        log "Keycloak health check passed"
        ;;

    openldap)
        FULLNAME="${RELEASE}"
        SVC="${FULLNAME}"
        PORT=$(kubectl get svc -n "${NAMESPACE}" "${SVC}" -o jsonpath='{.spec.ports[?(@.name=="ldap")].port}')
        [ -z "${PORT}" ] && PORT=389

        DOMAIN=$(helm get values "${RELEASE}" -n "${NAMESPACE}" -o json | python3 -c "import sys,json; print(json.load(sys.stdin).get('domain','example.local'))" 2>/dev/null || echo "example.local")
        # Convert domain to DN
        BASE_DN=$(echo "${DOMAIN}" | sed 's/\./,dc=/g' | sed 's/^/dc=/')
        ADMIN_PASS=$(kubectl get secret -n "${NAMESPACE}" "${FULLNAME}" -o jsonpath='{.data.ldap-admin-password}' | base64 -d)

        echo "Testing OpenLDAP at ${SVC}:${PORT} (base: ${BASE_DN})..."

        RESULT=""
        for attempt in 1 2 3; do
            RESULT=$(kubectl run "ldap-smoke-${attempt}" --rm -i --restart=Never -n "${NAMESPACE}" \
                --image=alpine -- \
                sh -c "apk add --no-cache openldap-clients >/dev/null 2>&1 && ldapsearch -x -H ldap://${SVC}:${PORT} -b '${BASE_DN}' -D 'cn=admin,${BASE_DN}' -w '${ADMIN_PASS}' '(objectClass=*)'" 2>&1) || true
            echo "Attempt ${attempt}: ${RESULT}"
            if echo "${RESULT}" | grep -q "dn:"; then
                break
            fi
            sleep 5
        done
        echo "${RESULT}" | grep -q "dn:" || fail "OpenLDAP search failed after 3 attempts"
        log "OpenLDAP search works"
        ;;
esac

echo ""
log "All smoke tests passed for ${CHART} (${VALUES})"
