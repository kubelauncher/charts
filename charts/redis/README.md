# redis

Redis in-memory data store

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-redis kubelauncher/redis
```

Or via OCI:

```bash
helm install my-redis oci://ghcr.io/kubelauncher/charts/redis
```

## Introduction

This chart deploys Redis on Kubernetes using the [kubelauncher/redis](https://github.com/kubelauncher/docker) Docker image. It supports four deployment architectures: standalone, replication, sentinel, and cluster.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Standalone (default)

A single Redis primary instance. Suitable for development and caching workloads.

```bash
helm install my-redis kubelauncher/redis \
  --set auth.password=mysecret
```

### Replication

One primary with multiple read replicas. Replicas serve read traffic and provide data redundancy.

```bash
helm install my-redis kubelauncher/redis \
  --set architecture=replication \
  --set auth.password=mysecret \
  --set replica.replicaCount=3
```

### Sentinel

High-availability setup with automatic failover. Sentinel monitors the primary and promotes a replica if the primary fails.

```bash
helm install my-redis kubelauncher/redis \
  --set architecture=replication \
  --set auth.password=mysecret \
  --set sentinel.enabled=true \
  --set sentinel.replicaCount=3 \
  --set sentinel.quorum=2
```

Sentinels listen on port `26379`. The sentinel set name defaults to `mymaster`.

### Cluster

Horizontally sharded Redis with automatic data partitioning across multiple nodes. Uses a dedicated `redis-cluster` image.

```bash
helm install my-redis kubelauncher/redis \
  --set auth.password=mysecret \
  --set cluster.enabled=true \
  --set cluster.nodes=6 \
  --set cluster.replicas=1
```

Each node exposes the Redis port (`6379`) and the cluster bus port (`16379`).

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-redis kubelauncher/redis \
  --set auth.password=mysecret
```

Or via OCI:

```bash
helm install my-redis oci://ghcr.io/kubelauncher/charts/redis \
  --set auth.password=mysecret
```

## Uninstalling the Chart

```bash
helm uninstall my-redis
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| architecture | string | `"standalone"` |  |
| auth.enabled | bool | `true` |  |
| auth.existingSecret | string | `""` |  |
| auth.existingSecretPasswordKey | string | `"redis-password"` |  |
| auth.password | string | `""` |  |
| cluster.affinity | object | `{}` |  |
| cluster.containerPorts.bus | int | `16379` |  |
| cluster.containerPorts.redis | int | `6379` |  |
| cluster.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| cluster.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| cluster.containerSecurityContext.enabled | bool | `true` |  |
| cluster.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| cluster.containerSecurityContext.runAsGroup | int | `1001` |  |
| cluster.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| cluster.containerSecurityContext.runAsUser | int | `1001` |  |
| cluster.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| cluster.enabled | bool | `false` |  |
| cluster.extraEnvVars | list | `[]` |  |
| cluster.extraVolumeMounts | list | `[]` |  |
| cluster.extraVolumes | list | `[]` |  |
| cluster.image.digest | string | `""` |  |
| cluster.image.pullPolicy | string | `"Always"` |  |
| cluster.image.registry | string | `"ghcr.io"` |  |
| cluster.image.repository | string | `"kubelauncher/redis-cluster"` |  |
| cluster.image.tag | string | `""` |  |
| cluster.initContainers | list | `[]` |  |
| cluster.livenessProbe.enabled | bool | `true` |  |
| cluster.livenessProbe.failureThreshold | int | `5` |  |
| cluster.livenessProbe.initialDelaySeconds | int | `20` |  |
| cluster.livenessProbe.periodSeconds | int | `5` |  |
| cluster.livenessProbe.successThreshold | int | `1` |  |
| cluster.livenessProbe.timeoutSeconds | int | `5` |  |
| cluster.nodeSelector | object | `{}` |  |
| cluster.nodes | int | `6` |  |
| cluster.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| cluster.persistence.annotations | object | `{}` |  |
| cluster.persistence.enabled | bool | `true` |  |
| cluster.persistence.existingClaim | string | `""` |  |
| cluster.persistence.labels | object | `{}` |  |
| cluster.persistence.mountPath | string | `"/data"` |  |
| cluster.persistence.size | string | `"8Gi"` |  |
| cluster.persistence.storageClass | string | `""` |  |
| cluster.podAnnotations | object | `{}` |  |
| cluster.podLabels | object | `{}` |  |
| cluster.podSecurityContext.enabled | bool | `true` |  |
| cluster.podSecurityContext.fsGroup | int | `1001` |  |
| cluster.readinessProbe.enabled | bool | `true` |  |
| cluster.readinessProbe.failureThreshold | int | `5` |  |
| cluster.readinessProbe.initialDelaySeconds | int | `5` |  |
| cluster.readinessProbe.periodSeconds | int | `5` |  |
| cluster.readinessProbe.successThreshold | int | `1` |  |
| cluster.readinessProbe.timeoutSeconds | int | `1` |  |
| cluster.replicas | int | `1` |  |
| cluster.resources | object | `{}` |  |
| cluster.resourcesPreset | string | `"nano"` |  |
| cluster.service.annotations | object | `{}` |  |
| cluster.service.clusterIP | string | `""` |  |
| cluster.service.labels | object | `{}` |  |
| cluster.service.nodePorts.bus | string | `""` |  |
| cluster.service.nodePorts.redis | string | `""` |  |
| cluster.service.ports.bus | int | `16379` |  |
| cluster.service.ports.redis | int | `6379` |  |
| cluster.service.type | string | `"ClusterIP"` |  |
| cluster.sidecars | list | `[]` |  |
| cluster.startupProbe.enabled | bool | `true` |  |
| cluster.startupProbe.failureThreshold | int | `30` |  |
| cluster.startupProbe.initialDelaySeconds | int | `5` |  |
| cluster.startupProbe.periodSeconds | int | `5` |  |
| cluster.startupProbe.successThreshold | int | `1` |  |
| cluster.startupProbe.timeoutSeconds | int | `5` |  |
| cluster.tolerations | list | `[]` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonConfiguration | string | `"appendonly yes\nsave \"\"\nmaxmemory 256mb\nmaxmemory-policy allkeys-lru"` |  |
| commonLabels | object | `{}` |  |
| enableServiceLinks | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.redis.password | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `"sha256:59e751efb5d5613b9e7dc112006261c5a8a4cb257bcbd717e1770fd60ea8093d"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/redis"` |  |
| image.tag | string | `"8.6.0"` |  |
| metrics.containerPorts.metrics | int | `9121` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.pullPolicy | string | `"Always"` |  |
| metrics.image.registry | string | `"ghcr.io"` |  |
| metrics.image.repository | string | `"kubelauncher/redis-exporter"` |  |
| metrics.image.tag | string | `"1.81.0"` |  |
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
| primary.containerPorts.redis | int | `6379` |  |
| primary.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| primary.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| primary.containerSecurityContext.enabled | bool | `true` |  |
| primary.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| primary.containerSecurityContext.runAsGroup | int | `1001` |  |
| primary.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| primary.containerSecurityContext.runAsUser | int | `1001` |  |
| primary.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| primary.count | int | `1` |  |
| primary.extraEnvVars | list | `[]` |  |
| primary.extraVolumeMounts | list | `[]` |  |
| primary.extraVolumes | list | `[]` |  |
| primary.initContainers | list | `[]` |  |
| primary.livenessProbe.enabled | bool | `true` |  |
| primary.livenessProbe.failureThreshold | int | `5` |  |
| primary.livenessProbe.initialDelaySeconds | int | `20` |  |
| primary.livenessProbe.periodSeconds | int | `5` |  |
| primary.livenessProbe.successThreshold | int | `1` |  |
| primary.livenessProbe.timeoutSeconds | int | `5` |  |
| primary.nodeSelector | object | `{}` |  |
| primary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| primary.persistence.annotations | object | `{}` |  |
| primary.persistence.enabled | bool | `true` |  |
| primary.persistence.existingClaim | string | `""` |  |
| primary.persistence.labels | object | `{}` |  |
| primary.persistence.mountPath | string | `"/data"` |  |
| primary.persistence.size | string | `"8Gi"` |  |
| primary.persistence.storageClass | string | `""` |  |
| primary.podAnnotations | object | `{}` |  |
| primary.podLabels | object | `{}` |  |
| primary.podSecurityContext.enabled | bool | `true` |  |
| primary.podSecurityContext.fsGroup | int | `1001` |  |
| primary.readinessProbe.enabled | bool | `true` |  |
| primary.readinessProbe.failureThreshold | int | `5` |  |
| primary.readinessProbe.initialDelaySeconds | int | `5` |  |
| primary.readinessProbe.periodSeconds | int | `5` |  |
| primary.readinessProbe.successThreshold | int | `1` |  |
| primary.readinessProbe.timeoutSeconds | int | `1` |  |
| primary.resources | object | `{}` |  |
| primary.resourcesPreset | string | `"nano"` |  |
| primary.service.annotations | object | `{}` |  |
| primary.service.clusterIP | string | `""` |  |
| primary.service.labels | object | `{}` |  |
| primary.service.nodePorts.redis | string | `""` |  |
| primary.service.ports.redis | int | `6379` |  |
| primary.service.type | string | `"ClusterIP"` |  |
| primary.sidecars | list | `[]` |  |
| primary.startupProbe.enabled | bool | `true` |  |
| primary.startupProbe.failureThreshold | int | `30` |  |
| primary.startupProbe.initialDelaySeconds | int | `5` |  |
| primary.startupProbe.periodSeconds | int | `5` |  |
| primary.startupProbe.successThreshold | int | `1` |  |
| primary.startupProbe.timeoutSeconds | int | `5` |  |
| primary.tolerations | list | `[]` |  |
| replica.affinity | object | `{}` |  |
| replica.containerPorts.redis | int | `6379` |  |
| replica.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| replica.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| replica.containerSecurityContext.enabled | bool | `true` |  |
| replica.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| replica.containerSecurityContext.runAsGroup | int | `1001` |  |
| replica.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| replica.containerSecurityContext.runAsUser | int | `1001` |  |
| replica.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| replica.extraEnvVars | list | `[]` |  |
| replica.extraVolumeMounts | list | `[]` |  |
| replica.extraVolumes | list | `[]` |  |
| replica.initContainers | list | `[]` |  |
| replica.livenessProbe.enabled | bool | `true` |  |
| replica.livenessProbe.failureThreshold | int | `5` |  |
| replica.livenessProbe.initialDelaySeconds | int | `20` |  |
| replica.livenessProbe.periodSeconds | int | `5` |  |
| replica.livenessProbe.successThreshold | int | `1` |  |
| replica.livenessProbe.timeoutSeconds | int | `5` |  |
| replica.nodeSelector | object | `{}` |  |
| replica.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| replica.persistence.annotations | object | `{}` |  |
| replica.persistence.enabled | bool | `true` |  |
| replica.persistence.existingClaim | string | `""` |  |
| replica.persistence.labels | object | `{}` |  |
| replica.persistence.mountPath | string | `"/data"` |  |
| replica.persistence.size | string | `"8Gi"` |  |
| replica.persistence.storageClass | string | `""` |  |
| replica.podAnnotations | object | `{}` |  |
| replica.podLabels | object | `{}` |  |
| replica.podSecurityContext.enabled | bool | `true` |  |
| replica.podSecurityContext.fsGroup | int | `1001` |  |
| replica.readinessProbe.enabled | bool | `true` |  |
| replica.readinessProbe.failureThreshold | int | `5` |  |
| replica.readinessProbe.initialDelaySeconds | int | `5` |  |
| replica.readinessProbe.periodSeconds | int | `5` |  |
| replica.readinessProbe.successThreshold | int | `1` |  |
| replica.readinessProbe.timeoutSeconds | int | `1` |  |
| replica.replicaCount | int | `3` |  |
| replica.resources | object | `{}` |  |
| replica.resourcesPreset | string | `"nano"` |  |
| replica.service.annotations | object | `{}` |  |
| replica.service.clusterIP | string | `""` |  |
| replica.service.labels | object | `{}` |  |
| replica.service.nodePorts.redis | string | `""` |  |
| replica.service.ports.redis | int | `6379` |  |
| replica.service.type | string | `"ClusterIP"` |  |
| replica.sidecars | list | `[]` |  |
| replica.startupProbe.enabled | bool | `true` |  |
| replica.startupProbe.failureThreshold | int | `30` |  |
| replica.startupProbe.initialDelaySeconds | int | `5` |  |
| replica.startupProbe.periodSeconds | int | `5` |  |
| replica.startupProbe.successThreshold | int | `1` |  |
| replica.startupProbe.timeoutSeconds | int | `5` |  |
| replica.tolerations | list | `[]` |  |
| sentinel.affinity | object | `{}` |  |
| sentinel.containerPorts.sentinel | int | `26379` |  |
| sentinel.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| sentinel.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| sentinel.containerSecurityContext.enabled | bool | `true` |  |
| sentinel.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| sentinel.containerSecurityContext.runAsGroup | int | `1001` |  |
| sentinel.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| sentinel.containerSecurityContext.runAsUser | int | `1001` |  |
| sentinel.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| sentinel.downAfterMilliseconds | int | `5000` |  |
| sentinel.enabled | bool | `false` |  |
| sentinel.extraEnvVars | list | `[]` |  |
| sentinel.extraVolumeMounts | list | `[]` |  |
| sentinel.extraVolumes | list | `[]` |  |
| sentinel.failoverTimeout | int | `60000` |  |
| sentinel.image.digest | string | `""` |  |
| sentinel.image.pullPolicy | string | `"Always"` |  |
| sentinel.image.registry | string | `"ghcr.io"` |  |
| sentinel.image.repository | string | `"kubelauncher/redis-sentinel"` |  |
| sentinel.image.tag | string | `""` |  |
| sentinel.initContainers | list | `[]` |  |
| sentinel.livenessProbe.enabled | bool | `true` |  |
| sentinel.livenessProbe.failureThreshold | int | `5` |  |
| sentinel.livenessProbe.initialDelaySeconds | int | `20` |  |
| sentinel.livenessProbe.periodSeconds | int | `5` |  |
| sentinel.livenessProbe.successThreshold | int | `1` |  |
| sentinel.livenessProbe.timeoutSeconds | int | `5` |  |
| sentinel.masterSet | string | `"mymaster"` |  |
| sentinel.nodeSelector | object | `{}` |  |
| sentinel.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| sentinel.persistence.annotations | object | `{}` |  |
| sentinel.persistence.enabled | bool | `true` |  |
| sentinel.persistence.existingClaim | string | `""` |  |
| sentinel.persistence.labels | object | `{}` |  |
| sentinel.persistence.mountPath | string | `"/data"` |  |
| sentinel.persistence.size | string | `"8Gi"` |  |
| sentinel.persistence.storageClass | string | `""` |  |
| sentinel.podAnnotations | object | `{}` |  |
| sentinel.podLabels | object | `{}` |  |
| sentinel.podSecurityContext.enabled | bool | `true` |  |
| sentinel.podSecurityContext.fsGroup | int | `1001` |  |
| sentinel.quorum | int | `2` |  |
| sentinel.readinessProbe.enabled | bool | `true` |  |
| sentinel.readinessProbe.failureThreshold | int | `5` |  |
| sentinel.readinessProbe.initialDelaySeconds | int | `5` |  |
| sentinel.readinessProbe.periodSeconds | int | `5` |  |
| sentinel.readinessProbe.successThreshold | int | `1` |  |
| sentinel.readinessProbe.timeoutSeconds | int | `1` |  |
| sentinel.replicaCount | int | `3` |  |
| sentinel.resources | object | `{}` |  |
| sentinel.resourcesPreset | string | `"nano"` |  |
| sentinel.service.annotations | object | `{}` |  |
| sentinel.service.clusterIP | string | `""` |  |
| sentinel.service.labels | object | `{}` |  |
| sentinel.service.nodePorts.sentinel | string | `""` |  |
| sentinel.service.ports.sentinel | int | `26379` |  |
| sentinel.service.type | string | `"ClusterIP"` |  |
| sentinel.sidecars | list | `[]` |  |
| sentinel.startupProbe.enabled | bool | `true` |  |
| sentinel.startupProbe.failureThreshold | int | `30` |  |
| sentinel.startupProbe.initialDelaySeconds | int | `5` |  |
| sentinel.startupProbe.periodSeconds | int | `5` |  |
| sentinel.startupProbe.successThreshold | int | `1` |  |
| sentinel.startupProbe.timeoutSeconds | int | `5` |  |
| sentinel.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
