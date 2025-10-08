
#!/usr/bin/env bash
set -euo pipefail
echo "Sidecar: fetching secrets from AWS Secrets Manager"
OUT_DIR=/secrets
mkdir -p "$OUT_DIR/grafana-provisioning/datasources"
# Default secret names (can be overridden via env)
GRAFANA_ADMIN_SECRET="${SECRET_GRAFANA_ADMIN_NAME:-grafana/admin}"
GRAFANA_DS_SECRET="${SECRET_GRAFANA_DATASOURCE_NAME:-grafana/datasource}"
PROM_ALERT_SECRET="${SECRET_PROM_ALERT_NAME:-prometheus/alertmanager}"
region="${AWS_REGION:-us-east-1}"
fetch() {
  aws secretsmanager get-secret-value --secret-id "$1" --region "$region" --query SecretString --output text 2>/dev/null || true
}
# Grafana admin
admin_json=$(fetch "$GRAFANA_ADMIN_SECRET")
if [[ -n "$admin_json" ]] && echo "$admin_json" | jq -e . >/dev/null 2>&1; then
  username=$(echo "$admin_json" | jq -r .username)
  password=$(echo "$admin_json" | jq -r .password)
  echo "$username" > "$OUT_DIR/grafana-provisioning/grafana-admin-user"
  echo "$password" > "$OUT_DIR/grafana-provisioning/grafana-admin-password"
  echo "Written grafana admin user/password files."
else
  echo "Grafana admin secret missing or not JSON."
fi
# Grafana datasource provisioning (example: simple API key datasource stored in secret)
ds_json=$(fetch "$GRAFANA_DS_SECRET")
if [[ -n "$ds_json" ]] ; then
  apiKey=$(echo "$ds_json" | jq -r '.apiKey // empty' 2>/dev/null || echo "$ds_json")
  cat > "$OUT_DIR/grafana-provisioning/datasources/datasource.yaml" <<EOF
apiVersion: 1
datasources:
- name: DemoAPI
  type: simplejson
  access: proxy
  url: https://example-datasource.local
  secureJsonData:
    apiKey: "$apiKey"
  isDefault: true
EOF
  echo "Written grafana datasource provisioning."
fi
# Prometheus alertmanager auth (example writing a basic config file)
prom_json=$(fetch "$PROM_ALERT_SECRET")
if [[ -n "$prom_json" ]] && echo "$prom_json" | jq -e . >/dev/null 2>&1; then
  webhook=$(echo "$prom_json" | jq -r .webhook_url)
  token=$(echo "$prom_json" | jq -r .auth_token)
  cat > "$OUT_DIR/alertmanager-credentials" <<EOF
webhook_url=$webhook
auth_token=$token
EOF
  echo "Written alertmanager credentials."
fi
echo "Sidecar finished writing secrets. Sleeping."
while true; do sleep 3600; done
