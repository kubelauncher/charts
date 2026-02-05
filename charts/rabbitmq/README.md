# rabbitmq

RabbitMQ message broker

## TL;DR

```bash
helm install my-rmq oci://ghcr.io/kubelauncher/charts/rabbitmq \
  --set auth.password=secret
```

## Introduction

This chart deploys RabbitMQ on Kubernetes using the [kubelauncher/rabbitmq](https://github.com/kubelauncher/docker) Docker image. Management UI and Prometheus plugin are enabled by default.

The values structure follows the same conventions as popular community charts, allowing easy migration.

## Installing the Chart

```bash
helm install my-rmq oci://ghcr.io/kubelauncher/charts/rabbitmq \
  --set auth.username=admin \
  --set auth.password=secret \
  --set replicaCount=3
```

## Uninstalling the Chart

```bash
helm uninstall my-rmq
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.erlangCookie | string | `""` |  |
| auth.existingErlangSecret | string | `""` |  |
| auth.existingPasswordSecret | string | `""` |  |
| auth.existingSecretErlangKey | string | `"rabbitmq-erlang-cookie"` |  |
| auth.existingSecretPasswordKey | string | `"rabbitmq-password"` |  |
| auth.password | string | `""` |  |
| auth.username | string | `"user"` |  |
| clusterDomain | string | `"cluster.local"` |  |
| clustering.addressType | string | `"hostname"` |  |
| clustering.enabled | bool | `true` |  |
| clustering.partitionHandling | string | `"autoheal"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| communityPlugins | string | `""` |  |
| containerPorts.amqp | int | `5672` |  |
| containerPorts.dist | int | `25672` |  |
| containerPorts.epmd | int | `4369` |  |
| containerPorts.manager | int | `15672` |  |
| containerPorts.metrics | int | `9419` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| extraConfiguration | string | `""` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVars | list | `[]` |  |
| extraPlugins | string | `""` |  |
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
| image.repository | string | `"kubelauncher/rabbitmq"` |  |
| image.tag | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `"rabbitmq.local"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | bool | `false` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `120` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `20` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.labels | object | `{}` |  |
| persistence.mountPath | string | `"/data/rabbitmq/data"` |  |
| persistence.size | string | `"8Gi"` |  |
| persistence.storageClass | string | `""` |  |
| plugins | string | `"rabbitmq_management rabbitmq_prometheus"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `20` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"micro"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.headless.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.nodePorts.amqp | string | `""` |  |
| service.nodePorts.dist | string | `""` |  |
| service.nodePorts.epmd | string | `""` |  |
| service.nodePorts.manager | string | `""` |  |
| service.nodePorts.metrics | string | `""` |  |
| service.ports.amqp | int | `5672` |  |
| service.ports.dist | int | `25672` |  |
| service.ports.epmd | int | `4369` |  |
| service.ports.manager | int | `15672` |  |
| service.ports.metrics | int | `9419` |  |
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
| tolerations | list | `[]` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher |  |  |
