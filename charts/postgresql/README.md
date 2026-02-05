# postgresql

PostgreSQL relational database

## TL;DR

```bash
helm install my-pg oci://ghcr.io/kubelauncher/charts/postgresql \
  --set auth.postgresPassword=secret
```

## Introduction

This chart deploys PostgreSQL on Kubernetes using the [kubelauncher/postgresql](https://github.com/kubelauncher/docker) Docker image. It supports standalone and replication architectures with init script support.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Installing the Chart

```bash
helm install my-pg oci://ghcr.io/kubelauncher/charts/postgresql \
  --set auth.postgresPassword=admin \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

## Uninstalling the Chart

```bash
helm uninstall my-pg
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| architecture | string | `"standalone"` |  |
| auth.database | string | `""` |  |
| auth.enablePostgresUser | bool | `true` |  |
| auth.existingSecret | string | `""` |  |
| auth.password | string | `""` |  |
| auth.postgresPassword | string | `""` |  |
| auth.replicationPassword | string | `""` |  |
| auth.replicationUsername | string | `"repl_user"` |  |
| auth.secretKeys.adminPasswordKey | string | `"postgres-password"` |  |
| auth.secretKeys.replicationPasswordKey | string | `"replication-password"` |  |
| auth.secretKeys.userPasswordKey | string | `"password"` |  |
| auth.username | string | `""` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| extraDeploy | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.postgresql.auth.database | string | `""` |  |
| global.postgresql.auth.existingSecret | string | `""` |  |
| global.postgresql.auth.password | string | `""` |  |
| global.postgresql.auth.postgresPassword | string | `""` |  |
| global.postgresql.auth.username | string | `""` |  |
| global.postgresql.service.ports.postgresql | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/postgresql"` |  |
| image.tag | string | `""` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| primary.affinity | object | `{}` |  |
| primary.configuration | string | `""` |  |
| primary.containerPorts.postgresql | int | `5432` |  |
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
| primary.initdb.args | string | `""` |  |
| primary.initdb.scripts | object | `{}` |  |
| primary.initdb.scriptsConfigMap | string | `""` |  |
| primary.initdb.scriptsSecret | string | `""` |  |
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
| primary.persistence.mountPath | string | `"/data/postgresql"` |  |
| primary.persistence.size | string | `"8Gi"` |  |
| primary.persistence.storageClass | string | `""` |  |
| primary.pgHbaConfiguration | string | `""` |  |
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
| primary.service.nodePorts.postgresql | string | `""` |  |
| primary.service.ports.postgresql | int | `5432` |  |
| primary.service.type | string | `"ClusterIP"` |  |
| primary.sidecars | list | `[]` |  |
| primary.startupProbe.enabled | bool | `true` |  |
| primary.startupProbe.failureThreshold | int | `30` |  |
| primary.startupProbe.initialDelaySeconds | int | `10` |  |
| primary.startupProbe.periodSeconds | int | `10` |  |
| primary.startupProbe.successThreshold | int | `1` |  |
| primary.startupProbe.timeoutSeconds | int | `5` |  |
| primary.tolerations | list | `[]` |  |
| readReplicas.affinity | object | `{}` |  |
| readReplicas.containerPorts.postgresql | int | `5432` |  |
| readReplicas.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| readReplicas.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| readReplicas.containerSecurityContext.enabled | bool | `true` |  |
| readReplicas.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| readReplicas.containerSecurityContext.runAsGroup | int | `1001` |  |
| readReplicas.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| readReplicas.containerSecurityContext.runAsUser | int | `1001` |  |
| readReplicas.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readReplicas.extraEnvVars | list | `[]` |  |
| readReplicas.extraVolumeMounts | list | `[]` |  |
| readReplicas.extraVolumes | list | `[]` |  |
| readReplicas.initContainers | list | `[]` |  |
| readReplicas.name | string | `"read"` |  |
| readReplicas.nodeSelector | object | `{}` |  |
| readReplicas.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| readReplicas.persistence.annotations | object | `{}` |  |
| readReplicas.persistence.enabled | bool | `true` |  |
| readReplicas.persistence.existingClaim | string | `""` |  |
| readReplicas.persistence.labels | object | `{}` |  |
| readReplicas.persistence.mountPath | string | `"/data/postgresql"` |  |
| readReplicas.persistence.size | string | `"8Gi"` |  |
| readReplicas.persistence.storageClass | string | `""` |  |
| readReplicas.podAnnotations | object | `{}` |  |
| readReplicas.podLabels | object | `{}` |  |
| readReplicas.podSecurityContext.enabled | bool | `true` |  |
| readReplicas.podSecurityContext.fsGroup | int | `1001` |  |
| readReplicas.replicaCount | int | `1` |  |
| readReplicas.resources | object | `{}` |  |
| readReplicas.resourcesPreset | string | `"nano"` |  |
| readReplicas.service.annotations | object | `{}` |  |
| readReplicas.service.clusterIP | string | `""` |  |
| readReplicas.service.headless.annotations | object | `{}` |  |
| readReplicas.service.labels | object | `{}` |  |
| readReplicas.service.nodePorts.postgresql | string | `""` |  |
| readReplicas.service.ports.postgresql | int | `5432` |  |
| readReplicas.service.type | string | `"ClusterIP"` |  |
| readReplicas.sidecars | list | `[]` |  |
| readReplicas.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
