# mongodb

MongoDB document database

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-mongo kubelauncher/mongodb \
  --set auth.rootPassword=secret
```

Or via OCI:

```bash
helm install my-mongo oci://ghcr.io/kubelauncher/charts/mongodb \
  --set auth.rootPassword=secret
```

## Introduction

This chart deploys MongoDB on Kubernetes using the [kubelauncher/mongodb](https://github.com/kubelauncher/docker) Docker image. It supports standalone and replica set architectures.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Standalone (default)

A single MongoDB instance. Suitable for development and small workloads.

```bash
helm install my-mongo kubelauncher/mongodb \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

### ReplicaSet

A primary with multiple secondaries forming a MongoDB replica set. Provides automatic failover and read scaling.

```bash
helm install my-mongo kubelauncher/mongodb \
  --set architecture=replicaset \
  --set auth.rootPassword=secret \
  --set replicaset.name=rs0 \
  --set secondary.replicaCount=2
```

The replica set is initialized via `rs.initiate()` with keyfile authentication between members. An init job handles the initial replica set configuration.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-mongo kubelauncher/mongodb \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

Or via OCI:

```bash
helm install my-mongo oci://ghcr.io/kubelauncher/charts/mongodb \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

## Upgrading

### To 1.0.0 (MongoDB 9.0)

MongoDB 9.0 only starts on data files whose `featureCompatibilityVersion` (FCV) is `8.0` or `8.3`. The FCV is never raised automatically when the image changes, so a deployment first installed with chart `< 0.4.0` (MongoDB 8.2) still runs with FCV `8.2` and would crash-loop on 9.0 (`mongod` exit code 62). No data is lost in that case, but the pods do not start until you roll back.

A pre-upgrade Job (`upgradeCheck.enabled`, on by default) reads the FCV of the running deployment and fails the upgrade before any pod restarts if it is not supported.

Before upgrading, on the current 0.4.x release:

```bash
# Check the current FCV
kubectl exec my-mongo-mongodb-0 -- bash -c \
  'mongosh -u root -p "$MONGODB_ROOT_PASSWORD" --quiet admin --eval "db.adminCommand({ getParameter: 1, featureCompatibilityVersion: 1 })"'

# If it is 8.2 (or anything other than 8.0 / 8.3), raise it on the primary
kubectl exec my-mongo-mongodb-0 -- bash -c \
  'mongosh -u root -p "$MONGODB_ROOT_PASSWORD" --quiet admin --eval "db.adminCommand({ setFeatureCompatibilityVersion: \"8.3\", confirm: true })"'
```

Then upgrade the chart. The deployment runs 9.0 with FCV `8.3`, which keeps a rollback to 0.4.x possible. Once the new version is validated, enable the 9.0 features:

```bash
kubectl exec my-mongo-mongodb-0 -- bash -c \
  'mongosh -u root -p "$MONGODB_ROOT_PASSWORD" --quiet admin --eval "db.adminCommand({ setFeatureCompatibilityVersion: \"9.0\", confirm: true })"'
```

After that, rolling back to 0.4.x requires setting the FCV back to `8.3` first, otherwise MongoDB 8.3 refuses to start on the data files. Review the [MongoDB 9.0 compatibility changes](https://www.mongodb.com/docs/manual/release-notes/9.0-compatibility/) (server-side JavaScript now evaluates local dates in UTC, new per-operation memory limits) before upgrading.

## Uninstalling the Chart

```bash
helm uninstall my-mongo
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| architecture | string | `"standalone"` |  |
| auth.database | string | `""` |  |
| auth.existingSecret | string | `""` |  |
| auth.password | string | `""` |  |
| auth.rootPassword | string | `""` |  |
| auth.rootUsername | string | `"root"` |  |
| auth.secretKeys.rootPasswordKey | string | `"mongodb-root-password"` |  |
| auth.secretKeys.userPasswordKey | string | `"mongodb-password"` |  |
| auth.username | string | `""` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| enableServiceLinks | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.mongodb.auth.database | string | `""` |  |
| global.mongodb.auth.existingSecret | string | `""` |  |
| global.mongodb.auth.password | string | `""` |  |
| global.mongodb.auth.rootPassword | string | `""` |  |
| global.mongodb.auth.rootUsername | string | `""` |  |
| global.mongodb.auth.username | string | `""` |  |
| global.mongodb.service.ports.mongodb | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `"sha256:037d89c137b62ba8e4bf2d24218bccd52ea9582b7380a8720990aa18b3eb8f78"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/mongodb"` |  |
| image.tag | string | `"9.0.4"` |  |
| metrics.containerPorts.metrics | int | `9216` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.pullPolicy | string | `"Always"` |  |
| metrics.image.registry | string | `"ghcr.io"` |  |
| metrics.image.repository | string | `"kubelauncher/mongodb-exporter"` |  |
| metrics.image.tag | string | `"0.47.2"` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| networkPolicy.additionalRules | list | `[]` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.enabled | bool | `false` |  |
| primary.affinity | object | `{}` |  |
| primary.configuration | string | `""` |  |
| primary.containerPorts.mongodb | int | `27017` |  |
| primary.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| primary.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| primary.containerSecurityContext.enabled | bool | `true` |  |
| primary.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| primary.containerSecurityContext.runAsGroup | int | `1001` |  |
| primary.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| primary.containerSecurityContext.runAsUser | int | `1001` |  |
| primary.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| primary.extraEnvVars | list | `[]` |  |
| primary.extraVolumeMounts | list | `[]` |  |
| primary.extraVolumes | list | `[]` |  |
| primary.initContainers | list | `[]` |  |
| primary.livenessProbe.enabled | bool | `true` |  |
| primary.livenessProbe.failureThreshold | int | `6` |  |
| primary.livenessProbe.initialDelaySeconds | int | `30` |  |
| primary.livenessProbe.periodSeconds | int | `10` |  |
| primary.livenessProbe.successThreshold | int | `1` |  |
| primary.livenessProbe.timeoutSeconds | int | `10` |  |
| primary.name | string | `"primary"` |  |
| primary.nodeSelector | object | `{}` |  |
| primary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| primary.persistence.annotations | object | `{}` |  |
| primary.persistence.enabled | bool | `true` |  |
| primary.persistence.existingClaim | string | `""` |  |
| primary.persistence.labels | object | `{}` |  |
| primary.persistence.mountPath | string | `"/data/mongodb"` |  |
| primary.persistence.size | string | `"8Gi"` |  |
| primary.persistence.storageClass | string | `""` |  |
| primary.podAnnotations | object | `{}` |  |
| primary.podLabels | object | `{}` |  |
| primary.podSecurityContext.enabled | bool | `true` |  |
| primary.podSecurityContext.fsGroup | int | `1001` |  |
| primary.readinessProbe.enabled | bool | `true` |  |
| primary.readinessProbe.failureThreshold | int | `6` |  |
| primary.readinessProbe.initialDelaySeconds | int | `5` |  |
| primary.readinessProbe.periodSeconds | int | `10` |  |
| primary.readinessProbe.successThreshold | int | `1` |  |
| primary.readinessProbe.timeoutSeconds | int | `10` |  |
| primary.replicaCount | int | `1` |  |
| primary.resources | object | `{}` |  |
| primary.resourcesPreset | string | `"micro"` |  |
| primary.service.annotations | object | `{}` |  |
| primary.service.clusterIP | string | `""` |  |
| primary.service.headless.annotations | object | `{}` |  |
| primary.service.labels | object | `{}` |  |
| primary.service.nodePorts.mongodb | string | `""` |  |
| primary.service.ports.mongodb | int | `27017` |  |
| primary.service.type | string | `"ClusterIP"` |  |
| primary.sidecars | list | `[]` |  |
| primary.startupProbe.enabled | bool | `true` |  |
| primary.startupProbe.failureThreshold | int | `30` |  |
| primary.startupProbe.initialDelaySeconds | int | `10` |  |
| primary.startupProbe.periodSeconds | int | `10` |  |
| primary.startupProbe.successThreshold | int | `1` |  |
| primary.startupProbe.timeoutSeconds | int | `10` |  |
| primary.tolerations | list | `[]` |  |
| replicaset.existingKeyfileSecret | string | `""` |  |
| replicaset.name | string | `"rs0"` |  |
| secondary.affinity | object | `{}` |  |
| secondary.containerPorts.mongodb | int | `27017` |  |
| secondary.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| secondary.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| secondary.containerSecurityContext.enabled | bool | `true` |  |
| secondary.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| secondary.containerSecurityContext.runAsGroup | int | `1001` |  |
| secondary.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| secondary.containerSecurityContext.runAsUser | int | `1001` |  |
| secondary.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| secondary.extraEnvVars | list | `[]` |  |
| secondary.extraVolumeMounts | list | `[]` |  |
| secondary.extraVolumes | list | `[]` |  |
| secondary.initContainers | list | `[]` |  |
| secondary.livenessProbe.enabled | bool | `true` |  |
| secondary.livenessProbe.failureThreshold | int | `6` |  |
| secondary.livenessProbe.initialDelaySeconds | int | `30` |  |
| secondary.livenessProbe.periodSeconds | int | `10` |  |
| secondary.livenessProbe.successThreshold | int | `1` |  |
| secondary.livenessProbe.timeoutSeconds | int | `10` |  |
| secondary.name | string | `"secondary"` |  |
| secondary.nodeSelector | object | `{}` |  |
| secondary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| secondary.persistence.annotations | object | `{}` |  |
| secondary.persistence.enabled | bool | `true` |  |
| secondary.persistence.labels | object | `{}` |  |
| secondary.persistence.mountPath | string | `"/data/mongodb"` |  |
| secondary.persistence.size | string | `"8Gi"` |  |
| secondary.persistence.storageClass | string | `""` |  |
| secondary.podAnnotations | object | `{}` |  |
| secondary.podLabels | object | `{}` |  |
| secondary.podSecurityContext.enabled | bool | `true` |  |
| secondary.podSecurityContext.fsGroup | int | `1001` |  |
| secondary.readinessProbe.enabled | bool | `true` |  |
| secondary.readinessProbe.failureThreshold | int | `6` |  |
| secondary.readinessProbe.initialDelaySeconds | int | `5` |  |
| secondary.readinessProbe.periodSeconds | int | `10` |  |
| secondary.readinessProbe.successThreshold | int | `1` |  |
| secondary.readinessProbe.timeoutSeconds | int | `10` |  |
| secondary.replicaCount | int | `2` |  |
| secondary.resources | object | `{}` |  |
| secondary.resourcesPreset | string | `"micro"` |  |
| secondary.service.headless.annotations | object | `{}` |  |
| secondary.sidecars | list | `[]` |  |
| secondary.startupProbe.enabled | bool | `true` |  |
| secondary.startupProbe.failureThreshold | int | `30` |  |
| secondary.startupProbe.initialDelaySeconds | int | `10` |  |
| secondary.startupProbe.periodSeconds | int | `10` |  |
| secondary.startupProbe.successThreshold | int | `1` |  |
| secondary.startupProbe.timeoutSeconds | int | `10` |  |
| secondary.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| upgradeCheck.allowedFeatureCompatibilityVersions[0] | string | `"8.0"` |  |
| upgradeCheck.allowedFeatureCompatibilityVersions[1] | string | `"8.3"` |  |
| upgradeCheck.allowedFeatureCompatibilityVersions[2] | string | `"9.0"` |  |
| upgradeCheck.enabled | bool | `true` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
