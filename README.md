# kubelauncher/charts

Helm charts for Redis, PostgreSQL, RabbitMQ, and kubectl.

## Charts

| Chart | App Version | Description |
|-------|-------------|-------------|
| [redis](charts/redis) | 8.4.0 | Redis in-memory data store |
| [postgresql](charts/postgresql) | 17 | PostgreSQL relational database |
| [rabbitmq](charts/rabbitmq) | 4.2.3 | RabbitMQ message broker |
| [kubectl](charts/kubectl) | 1.35.0 | kubectl utility (Job/CronJob) |

## Usage

### OCI registry (recommended)

```bash
helm install my-redis oci://ghcr.io/kubelauncher/charts/redis
helm install my-pg oci://ghcr.io/kubelauncher/charts/postgresql
helm install my-rmq oci://ghcr.io/kubelauncher/charts/rabbitmq
```

### Helm repo

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm repo update
helm install my-redis kubelauncher/redis
```

## Values structure

The charts use a familiar values structure with common top-level keys:

```yaml
image:
  registry: ghcr.io
  repository: kubelauncher/redis
auth:
  enabled: true
  password: "secret"
master:                        # redis
  persistence:
    size: 16Gi
primary:                       # postgresql
  persistence:
    size: 16Gi
persistence:                   # rabbitmq
  size: 16Gi
```

## CI/CD

Charts are linted on every PR and published to both OCI (`ghcr.io`) and GitHub Pages on merge to `main`.

## Dependency updates

Renovate tracks `appVersion` in `Chart.yaml` for each chart and creates PRs when new upstream versions are released.
