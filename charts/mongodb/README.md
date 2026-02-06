# mongodb

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.2.0](https://img.shields.io/badge/AppVersion-8.2.0-informational?style=flat-square)

MongoDB document database

**Homepage:** <https://github.com/kubelauncher/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |

## Source Code

* <https://github.com/kubelauncher/docker>
* <https://github.com/kubelauncher/charts>

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
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/mongodb"` |  |
| image.tag | string | `""` |  |
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
| primary.livenessProbe.timeoutSeconds | int | `5` |  |
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
| primary.readinessProbe.timeoutSeconds | int | `5` |  |
| primary.resources | object | `{}` |  |
| primary.resourcesPreset | string | `"nano"` |  |
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
| primary.startupProbe.timeoutSeconds | int | `5` |  |
| primary.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
