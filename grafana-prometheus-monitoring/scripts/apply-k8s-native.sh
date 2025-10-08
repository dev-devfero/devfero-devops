
#!/usr/bin/env bash
set -euo pipefail
kubectl apply -f k8s/common/namespaces.yaml
kubectl apply -n monitoring -f k8s/common/grafana-provisioning-configmap.yaml
kubectl apply -n monitoring -f k8s/common/prometheus-configmap.yaml
kubectl apply -f k8s/native/secretstore.yaml -n external-secrets
kubectl apply -f k8s/native/externalsecret.yaml -n monitoring
kubectl apply -f k8s/native/grafana-deployment.yaml -n monitoring
kubectl apply -f k8s/native/prometheus-deployment.yaml -n monitoring
