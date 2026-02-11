# redis

Redis in-memory data store

## TL;DR

```bash
helm install my-redis oci://ghcr.io/kubelauncher/charts/redis
```

## Introduction

This chart deploys Redis on Kubernetes using the [kubelauncher/redis](https://github.com/kubelauncher/docker) Docker image. It supports standalone and replication architectures.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Installing the Chart

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
| cluster.image.pullPolicy | string | `"IfNotPresent"` |  |
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
| commonConfiguration | string | `"appendonly yes\nsave \"\""` |  |
| commonLabels | object | `{}` |  |
| enableServiceLinks | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.redis.password | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/redis"` |  |
| image.tag | string | `""` |  |
| master.affinity | object | `{}` |  |
| master.containerPorts.redis | int | `6379` |  |
| master.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| master.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| master.containerSecurityContext.enabled | bool | `true` |  |
| master.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| master.containerSecurityContext.runAsGroup | int | `1001` |  |
| master.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| master.containerSecurityContext.runAsUser | int | `1001` |  |
| master.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| master.count | int | `1` |  |
| master.extraEnvVars | list | `[]` |  |
| master.extraVolumeMounts | list | `[]` |  |
| master.extraVolumes | list | `[]` |  |
| master.initContainers | list | `[]` |  |
| master.livenessProbe.enabled | bool | `true` |  |
| master.livenessProbe.failureThreshold | int | `5` |  |
| master.livenessProbe.initialDelaySeconds | int | `20` |  |
| master.livenessProbe.periodSeconds | int | `5` |  |
| master.livenessProbe.successThreshold | int | `1` |  |
| master.livenessProbe.timeoutSeconds | int | `5` |  |
| master.nodeSelector | object | `{}` |  |
| master.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| master.persistence.annotations | object | `{}` |  |
| master.persistence.enabled | bool | `true` |  |
| master.persistence.existingClaim | string | `""` |  |
| master.persistence.labels | object | `{}` |  |
| master.persistence.mountPath | string | `"/data"` |  |
| master.persistence.size | string | `"8Gi"` |  |
| master.persistence.storageClass | string | `""` |  |
| master.podAnnotations | object | `{}` |  |
| master.podLabels | object | `{}` |  |
| master.podSecurityContext.enabled | bool | `true` |  |
| master.podSecurityContext.fsGroup | int | `1001` |  |
| master.readinessProbe.enabled | bool | `true` |  |
| master.readinessProbe.failureThreshold | int | `5` |  |
| master.readinessProbe.initialDelaySeconds | int | `5` |  |
| master.readinessProbe.periodSeconds | int | `5` |  |
| master.readinessProbe.successThreshold | int | `1` |  |
| master.readinessProbe.timeoutSeconds | int | `1` |  |
| master.resources | object | `{}` |  |
| master.resourcesPreset | string | `"nano"` |  |
| master.service.annotations | object | `{}` |  |
| master.service.clusterIP | string | `""` |  |
| master.service.labels | object | `{}` |  |
| master.service.nodePorts.redis | string | `""` |  |
| master.service.ports.redis | int | `6379` |  |
| master.service.type | string | `"ClusterIP"` |  |
| master.sidecars | list | `[]` |  |
| master.startupProbe.enabled | bool | `true` |  |
| master.startupProbe.failureThreshold | int | `30` |  |
| master.startupProbe.initialDelaySeconds | int | `5` |  |
| master.startupProbe.periodSeconds | int | `5` |  |
| master.startupProbe.successThreshold | int | `1` |  |
| master.startupProbe.timeoutSeconds | int | `5` |  |
| master.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| networkPolicy.additionalRules | list | `[]` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.enabled | bool | `false` |  |
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
| sentinel.image.pullPolicy | string | `"IfNotPresent"` |  |
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
