# etcd

etcd distributed key-value store

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-etcd kubelauncher/etcd
```

Or via OCI:

```bash
helm install my-etcd oci://ghcr.io/kubelauncher/charts/etcd
```

## Introduction

This chart deploys etcd on Kubernetes using the [kubelauncher/etcd](https://github.com/kubelauncher/docker) Docker image.

etcd is a distributed, reliable key-value store for the most critical data of a distributed system. It uses the Raft consensus algorithm to guarantee strong consistency.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Single node (default)

A single etcd node. Suitable for development and testing.

```bash
helm install my-etcd kubelauncher/etcd
```

### Cluster

Scale the cluster by increasing `replicaCount`. Use an odd number (3, 5, 7) for proper Raft quorum. A majority of nodes must be available for the cluster to operate.

```bash
helm install my-etcd kubelauncher/etcd \
  --set replicaCount=3
```

The client port is `2379`, the peer port is `2380`, and the metrics port is `2381`. Persistence is enabled by default with 8Gi volumes.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-etcd kubelauncher/etcd \
  --set replicaCount=3
```

Or via OCI:

```bash
helm install my-etcd oci://ghcr.io/kubelauncher/charts/etcd \
  --set replicaCount=3
```

## Uninstalling the Chart

```bash
helm uninstall my-etcd
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.client | int | `2379` |  |
| containerPorts.metrics | int | `2381` |  |
| containerPorts.peer | int | `2380` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| enableServiceLinks | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVars | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| image.digest | string | `"sha256:0819f2a2590f615091496053bdd3849fba1ef561775f7dfc9a0f3b27a137d47b"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/etcd"` |  |
| image.tag | string | `"3.6.8"` |  |
| initContainers | list | `[]` |  |
| initialClusterState | string | `"new"` |  |
| initialClusterToken | string | `"etcd-cluster"` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| networkPolicy.additionalRules | list | `[]` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.labels | object | `{}` |  |
| persistence.mountPath | string | `"/data/etcd"` |  |
| persistence.size | string | `"8Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `6` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.headless.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.nodePorts.client | string | `""` |  |
| service.nodePorts.peer | string | `""` |  |
| service.ports.client | int | `2379` |  |
| service.ports.peer | int | `2380` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecars | list | `[]` |  |
| startupProbe.enabled | bool | `true` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `5` |  |
| startupProbe.periodSeconds | int | `5` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
