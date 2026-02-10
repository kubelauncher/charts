# kubectl

Kubectl CLI utility container for Kubernetes jobs and CronJobs

## TL;DR

```bash
helm install my-job oci://ghcr.io/kubelauncher/charts/kubectl \
  --set command='{kubectl}' \
  --set args='{get,pods,-A}'
```

## Introduction

This chart deploys a kubectl utility container as a Job or CronJob on Kubernetes using the [kubelauncher/kubectl](https://github.com/kubelauncher/docker) Docker image. Includes RBAC support, yq, jq, and git.

Set `schedule` to create a CronJob instead of a one-shot Job.

## Installing the Chart

```bash
# One-shot job
helm install my-job oci://ghcr.io/kubelauncher/charts/kubectl \
  --set command='{kubectl}' \
  --set args='{get,namespaces}'

# CronJob
helm install my-cron oci://ghcr.io/kubelauncher/charts/kubectl \
  --set schedule="0 */6 * * *" \
  --set command='{kubectl}' \
  --set args='{get,pods,-A}'
```

## Uninstalling the Chart

```bash
helm uninstall my-job
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args | list | `[]` |  |
| backoffLimit | int | `3` |  |
| command | list | `[]` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| enableServiceLinks | bool | `false` |  |
| extraEnvVars | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/kubectl"` |  |
| image.tag | string | `""` |  |
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
| rbac.clusterWide | bool | `false` |  |
| rbac.create | bool | `true` |  |
| rbac.rules | list | `[]` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| restartPolicy | string | `"OnFailure"` |  |
| schedule | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| ttlSecondsAfterFinished | int | `300` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
