# memcached

Memcached in-memory caching system

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-memcached kubelauncher/memcached
```

Or via OCI:

```bash
helm install my-memcached oci://ghcr.io/kubelauncher/charts/memcached
```

## Introduction

This chart deploys Memcached on Kubernetes using the [kubelauncher/memcached](https://github.com/kubelauncher/docker) Docker image.

Memcached is a single-node in-memory cache. The default configuration allocates 64MB of memory with 4 threads and 1024 max connections. Verbose logging is enabled by default via the `-v` flag.

```bash
helm install my-memcached kubelauncher/memcached \
  --set memcachedMaxMemory=128 \
  --set memcachedThreads=8
```

The service listens on port `11211`.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-memcached kubelauncher/memcached
```

Or via OCI:

```bash
helm install my-memcached oci://ghcr.io/kubelauncher/charts/memcached
```

## Uninstalling the Chart

```bash
helm uninstall my-memcached
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.memcached | int | `11211` |  |
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
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/memcached"` |  |
| image.tag | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| memcachedExtraFlags | string | `"-v"` |  |
| memcachedMaxConnections | int | `1024` |  |
| memcachedMaxMemory | int | `64` |  |
| memcachedThreads | int | `4` |  |
| metrics.containerPorts.metrics | int | `9150` |  |
| metrics.enabled | bool | `false` |  |
| metrics.image.pullPolicy | string | `"Always"` |  |
| metrics.image.registry | string | `"ghcr.io"` |  |
| metrics.image.repository | string | `"kubelauncher/memcached-exporter"` |  |
| metrics.image.tag | string | `"0.15.5"` |  |
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
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `5` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.labels | object | `{}` |  |
| service.nodePorts.memcached | string | `""` |  |
| service.ports.memcached | int | `11211` |  |
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
