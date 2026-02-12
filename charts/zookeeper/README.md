# zookeeper

Apache ZooKeeper distributed coordination service

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-zk kubelauncher/zookeeper
```

Or via OCI:

```bash
helm install my-zk oci://ghcr.io/kubelauncher/charts/zookeeper
```

## Introduction

This chart deploys Apache ZooKeeper on Kubernetes using the [kubelauncher/zookeeper](https://github.com/kubelauncher/docker) Docker image.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Single node (default)

A single ZooKeeper node. Suitable for development and testing.

```bash
helm install my-zk kubelauncher/zookeeper
```

### Ensemble

Scale the ensemble by increasing `replicaCount`. Use an odd number (3, 5, 7) for proper quorum. ZooKeeper uses a leader election protocol — a majority of nodes must be available for the cluster to operate.

```bash
helm install my-zk kubelauncher/zookeeper \
  --set replicaCount=3
```

The client port is `2181`, the follower port is `2888`, and the election port is `3888`. Persistence is enabled by default with 8Gi volumes.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-zk kubelauncher/zookeeper \
  --set replicaCount=3
```

Or via OCI:

```bash
helm install my-zk oci://ghcr.io/kubelauncher/charts/zookeeper \
  --set replicaCount=3
```

## Uninstalling the Chart

```bash
helm uninstall my-zk
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.client | int | `2181` |  |
| containerPorts.election | int | `3888` |  |
| containerPorts.follower | int | `2888` |  |
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
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/zookeeper"` |  |
| image.tag | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `20` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
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
| persistence.mountPath | string | `"/data/zookeeper"` |  |
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
| service.nodePorts.election | string | `""` |  |
| service.nodePorts.follower | string | `""` |  |
| service.ports.client | int | `2181` |  |
| service.ports.election | int | `3888` |  |
| service.ports.follower | int | `2888` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecars | list | `[]` |  |
| startupProbe.enabled | bool | `true` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tickTime | int | `2000` |  |
| tolerations | list | `[]` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
