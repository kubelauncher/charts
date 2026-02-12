# openldap

OpenLDAP directory service

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-ldap kubelauncher/openldap \
  --set auth.adminPassword=secret
```

Or via OCI:

```bash
helm install my-ldap oci://ghcr.io/kubelauncher/charts/openldap \
  --set auth.adminPassword=secret
```

## Introduction

This chart deploys OpenLDAP on Kubernetes using the [kubelauncher/openldap](https://github.com/kubelauncher/docker) Docker image. It provides a lightweight LDAP directory server.

```bash
helm install my-ldap kubelauncher/openldap \
  --set auth.adminPassword=secret \
  --set env.LDAP_ROOT="dc=myorg,dc=com"
```

The LDAP port is `1389` and the LDAPS port is `1636` (non-root ports). Persistence is enabled by default with 8Gi volumes.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-ldap kubelauncher/openldap \
  --set auth.adminPassword=secret
```

Or via OCI:

```bash
helm install my-ldap oci://ghcr.io/kubelauncher/charts/openldap \
  --set auth.adminPassword=secret
```

## Uninstalling the Chart

```bash
helm uninstall my-ldap
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.adminPassword | string | `""` |  |
| auth.existingSecret | string | `""` |  |
| auth.existingSecretPasswordKey | string | `"ldap-admin-password"` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.ldap | int | `1389` |  |
| containerPorts.ldaps | int | `1636` |  |
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
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/openldap"` |  |
| image.tag | string | `""` |  |
| initContainers | list | `[]` |  |
| ldapAdminUsername | string | `"admin"` |  |
| ldapRoot | string | `"dc=example,dc=org"` |  |
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
| persistence.mountPath | string | `"/data/openldap"` |  |
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
| service.nodePorts.ldap | string | `""` |  |
| service.nodePorts.ldaps | string | `""` |  |
| service.ports.ldap | int | `389` |  |
| service.ports.ldaps | int | `636` |  |
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
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
