# mysql

MySQL relational database

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-mysql kubelauncher/mysql \
  --set auth.rootPassword=secret
```

Or via OCI:

```bash
helm install my-mysql oci://ghcr.io/kubelauncher/charts/mysql \
  --set auth.rootPassword=secret
```

## Introduction

This chart deploys MySQL on Kubernetes using the [kubelauncher/mysql](https://github.com/kubelauncher/docker) Docker image. It supports standalone and replication architectures.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Standalone (default)

A single MySQL instance. Suitable for development and small production workloads.

```bash
helm install my-mysql kubelauncher/mysql \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

### Replication

One primary with multiple secondaries using GTID-based replication. Secondaries serve read-only queries and provide data redundancy.

```bash
helm install my-mysql kubelauncher/mysql \
  --set architecture=replication \
  --set auth.rootPassword=secret \
  --set auth.replicationUser=replicator \
  --set auth.replicationPassword=replsecret \
  --set secondary.replicaCount=2
```

The primary enables GTID mode (`gtid-mode=ON`, `enforce-gtid-consistency=ON`) and binary logging. Secondaries use `MASTER_AUTO_POSITION=1` for automatic replication positioning.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-mysql kubelauncher/mysql \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

Or via OCI:

```bash
helm install my-mysql oci://ghcr.io/kubelauncher/charts/mysql \
  --set auth.rootPassword=secret \
  --set auth.username=myuser \
  --set auth.password=mypass \
  --set auth.database=mydb
```

## Uninstalling the Chart

```bash
helm uninstall my-mysql
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| architecture | string | `"standalone"` |  |
| auth.database | string | `""` |  |
| auth.existingSecret | string | `""` |  |
| auth.password | string | `""` |  |
| auth.rootPassword | string | `""` |  |
| auth.secretKeys.rootPasswordKey | string | `"mysql-root-password"` |  |
| auth.secretKeys.userPasswordKey | string | `"mysql-password"` |  |
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
| global.mysql.auth.database | string | `""` |  |
| global.mysql.auth.existingSecret | string | `""` |  |
| global.mysql.auth.password | string | `""` |  |
| global.mysql.auth.rootPassword | string | `""` |  |
| global.mysql.auth.username | string | `""` |  |
| global.mysql.service.ports.mysql | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/mysql"` |  |
| image.tag | string | `""` |  |
| metrics.containerPorts.metrics | int | `9104` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.pullPolicy | string | `"IfNotPresent"` |  |
| metrics.image.registry | string | `"docker.io"` |  |
| metrics.image.repository | string | `"prom/mysqld-exporter"` |  |
| metrics.image.tag | string | `"v0.16.0"` |  |
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
| primary.containerPorts.mysql | int | `3306` |  |
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
| primary.persistence.mountPath | string | `"/data/mysql"` |  |
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
| primary.replicaCount | int | `1` |  |
| primary.resources | object | `{}` |  |
| primary.resourcesPreset | string | `"nano"` |  |
| primary.service.annotations | object | `{}` |  |
| primary.service.clusterIP | string | `""` |  |
| primary.service.headless.annotations | object | `{}` |  |
| primary.service.labels | object | `{}` |  |
| primary.service.nodePorts.mysql | string | `""` |  |
| primary.service.ports.mysql | int | `3306` |  |
| primary.service.type | string | `"ClusterIP"` |  |
| primary.sidecars | list | `[]` |  |
| primary.startupProbe.enabled | bool | `true` |  |
| primary.startupProbe.failureThreshold | int | `30` |  |
| primary.startupProbe.initialDelaySeconds | int | `10` |  |
| primary.startupProbe.periodSeconds | int | `10` |  |
| primary.startupProbe.successThreshold | int | `1` |  |
| primary.startupProbe.timeoutSeconds | int | `5` |  |
| primary.tolerations | list | `[]` |  |
| replication.password | string | `""` |  |
| replication.user | string | `"replicator"` |  |
| secondary.affinity | object | `{}` |  |
| secondary.containerPorts.mysql | int | `3306` |  |
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
| secondary.livenessProbe.timeoutSeconds | int | `5` |  |
| secondary.nodeSelector | object | `{}` |  |
| secondary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| secondary.persistence.annotations | object | `{}` |  |
| secondary.persistence.enabled | bool | `true` |  |
| secondary.persistence.existingClaim | string | `""` |  |
| secondary.persistence.labels | object | `{}` |  |
| secondary.persistence.mountPath | string | `"/data/mysql"` |  |
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
| secondary.readinessProbe.timeoutSeconds | int | `5` |  |
| secondary.replicaCount | int | `2` |  |
| secondary.resources | object | `{}` |  |
| secondary.resourcesPreset | string | `"nano"` |  |
| secondary.service.annotations | object | `{}` |  |
| secondary.service.clusterIP | string | `""` |  |
| secondary.service.labels | object | `{}` |  |
| secondary.service.nodePorts.mysql | string | `""` |  |
| secondary.service.ports.mysql | int | `3306` |  |
| secondary.service.type | string | `"ClusterIP"` |  |
| secondary.sidecars | list | `[]` |  |
| secondary.startupProbe.enabled | bool | `true` |  |
| secondary.startupProbe.failureThreshold | int | `30` |  |
| secondary.startupProbe.initialDelaySeconds | int | `10` |  |
| secondary.startupProbe.periodSeconds | int | `10` |  |
| secondary.startupProbe.successThreshold | int | `1` |  |
| secondary.startupProbe.timeoutSeconds | int | `5` |  |
| secondary.tolerations | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
