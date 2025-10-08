
Docker Compose (sidecar) - Grafana + Prometheus

- secrets-sidecar: container that fetches secrets from AWS Secrets Manager and writes files under /secrets.
- grafana: uses provisioning files and reads admin username/password from files (safer than plain env).
- prometheus: reads prometheus.yml from /etc/prometheus (mounted from shared volume).

Use .env.example as a starting point to set AWS_REGION and secret names.
