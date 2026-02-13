# keycloak

Keycloak identity and access management

## TL;DR

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-keycloak kubelauncher/keycloak \
  --set auth.adminPassword=secret
```

Or via OCI:

```bash
helm install my-keycloak oci://ghcr.io/kubelauncher/charts/keycloak \
  --set auth.adminPassword=secret
```

## Introduction

This chart deploys Keycloak on Kubernetes using the [kubelauncher/keycloak](https://github.com/kubelauncher/docker) Docker image. Keycloak provides identity and access management with support for OpenID Connect, SAML, and OAuth 2.0.

An external database (PostgreSQL by default) is required. Configure the database connection via the `database` values.

```bash
helm install my-keycloak kubelauncher/keycloak \
  --set auth.adminPassword=secret \
  --set database.vendor=postgres \
  --set database.url=jdbc:postgresql://mydb:5432/keycloak \
  --set database.username=keycloak \
  --set database.password=dbpass
```

The HTTP port is `8080` and the management port is `9000`. Both Ingress and Gateway API (HTTPRoute) are supported for external access.

## Installing the Chart

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm install my-keycloak kubelauncher/keycloak \
  --set auth.adminPassword=secret
```

Or via OCI:

```bash
helm install my-keycloak oci://ghcr.io/kubelauncher/charts/keycloak \
  --set auth.adminPassword=secret
```

## Uninstalling the Chart

```bash
helm uninstall my-keycloak
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| auth.adminPassword | string | `""` |  |
| auth.adminUser | string | `"admin"` |  |
| auth.existingSecret | string | `""` |  |
| auth.existingSecretAdminPasswordKey | string | `"keycloak-admin-password"` |  |
| auth.existingSecretAdminUserKey | string | `"keycloak-admin-user"` |  |
| clusterDomain | string | `"cluster.local"` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerPorts.http | int | `8080` |  |
| containerPorts.management | int | `9000` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| database.existingSecret | string | `""` |  |
| database.existingSecretPasswordKey | string | `"db-password"` |  |
| database.existingSecretUsernameKey | string | `"db-username"` |  |
| database.password | string | `""` |  |
| database.url | string | `""` |  |
| database.username | string | `""` |  |
| database.vendor | string | `"postgres"` |  |
| enableServiceLinks | bool | `false` |  |
| extraDeploy | list | `[]` |  |
| extraEnvVars | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| hostname | string | `""` |  |
| httpRoute.enabled | bool | `false` |  |
| httpRoute.hostnames | list | `[]` |  |
| httpRoute.parentRefs.name | string | `"traefik-gateway"` |  |
| httpRoute.parentRefs.namespace | string | `"traefik"` |  |
| httpRoute.path | string | `"/"` |  |
| httpRoute.pathType | string | `"PathPrefix"` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.registry | string | `"ghcr.io"` |  |
| image.repository | string | `"kubelauncher/keycloak"` |  |
| image.tag | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
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
| persistence.mountPath | string | `"/opt/keycloak/data"` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| proxyHeaders | string | `"xforwarded"` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.labels | object | `{}` |  |
| service.nodePorts.http | string | `""` |  |
| service.ports.http | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecars | list | `[]` |  |
| startupProbe.enabled | bool | `true` |  |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `15` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| kubelauncher | <platform@kubelauncher.com> | <https://www.kubelauncher.com> |
