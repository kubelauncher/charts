# cassandra

Apache Cassandra distributed NoSQL database

## TL;DR

```bash
helm install my-cassandra oci://ghcr.io/kubelauncher/charts/cassandra
```

## Introduction

This chart deploys Apache Cassandra on Kubernetes using the [kubelauncher/cassandra](https://github.com/kubelauncher/docker) Docker image. Cassandra uses a peer-to-peer gossip protocol — every node is equal and there is no single point of failure.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Architecture

### Single node (default)

A single Cassandra node. Suitable for development and testing.

```bash
helm install my-cassandra oci://ghcr.io/kubelauncher/charts/cassandra
```

### Cluster

Scale the cluster by increasing `replicaCount`. All nodes join the same cluster via gossip and share data according to the configured replication factor.

```bash
helm install my-cassandra oci://ghcr.io/kubelauncher/charts/cassandra \
  --set replicaCount=3 \
  --set cluster.name=cassandra \
  --set cluster.datacenter=dc1 \
  --set cluster.rack=rack1
```

The CQL port is `9042`, the intra-node port is `7000`. Persistence is enabled by default with 16Gi volumes. The default snitch is `SimpleSnitch`.

## Installing the Chart

```bash
helm install my-cassandra oci://ghcr.io/kubelauncher/charts/cassandra \
  --set replicaCount=3
```

## Uninstalling the Chart

```bash
helm uninstall my-cassandra
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| clusterName | string | `"cassandra"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.cql | int | `9042` |  |
| containerPorts.intraNode | int | `7000` |  |
| containerPorts.tlsIntraNode | int | `7001` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| datacenter | string | `"dc1"` |  |
| enableServiceLinks | bool | `false` |  |
| endpointSnitch | string | `"SimpleSnitch"` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVars | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| heapNewSize | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/cassandra"` |  |
| image.tag | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `10` |  |
| maxHeapSize | string | `"512M"` |  |
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
| persistence.mountPath | string | `"/data/cassandra"` |  |
| persistence.size | string | `"16Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| rack | string | `"rack1"` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `5` |  |
| readinessProbe.initialDelaySeconds | int | `60` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `10` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"small"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.headless.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.nodePorts.cql | string | `""` |  |
| service.nodePorts.intraNode | string | `""` |  |
| service.nodePorts.tlsIntraNode | string | `""` |  |
| service.ports.cql | int | `9042` |  |
| service.ports.intraNode | int | `7000` |  |
| service.ports.tlsIntraNode | int | `7001` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecars | list | `[]` |  |
| startupProbe.enabled | bool | `true` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `60` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `10` |  |
| tolerations | list | `[]` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
