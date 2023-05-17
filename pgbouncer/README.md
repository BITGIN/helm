# Helm Chart for PgBouncer

## Installation

### Add Helm repository

```bash
helm repo add bitgin https://bitgin.github.io/helm
helm repo update
```

### Install the chart

Install the pgbouncer helm chart with a release name `my-release`:

```bash
helm install --name my-release bitgin/pgbouncer
```

## Uninstallation

To uninstall/delete the `my-release` deployment:

```bash
helm delete --purge my-release
```

