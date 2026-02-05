# kubelauncher/charts

Helm charts for databases, message brokers, and utilities.

## Charts

- [cassandra](charts/cassandra) - Apache Cassandra
- [kafka](charts/kafka) - Apache Kafka
- [keycloak](charts/keycloak) - Keycloak IAM
- [kubectl](charts/kubectl) - kubectl utility (Job/CronJob)
- [mariadb](charts/mariadb) - MariaDB
- [memcached](charts/memcached) - Memcached
- [mongodb](charts/mongodb) - MongoDB
- [mysql](charts/mysql) - MySQL
- [openldap](charts/openldap) - OpenLDAP
- [postgresql](charts/postgresql) - PostgreSQL
- [rabbitmq](charts/rabbitmq) - RabbitMQ
- [redis](charts/redis) - Redis (standalone, sentinel, cluster)
- [zookeeper](charts/zookeeper) - Apache ZooKeeper

## Usage

### OCI registry (recommended)

```bash
helm install my-release oci://ghcr.io/kubelauncher/charts/<chart-name>
```

### Helm repo

```bash
helm repo add kubelauncher https://kubelauncher.github.io/charts
helm repo update
helm install my-release kubelauncher/<chart-name>
```
