
### Monitoring reference through Grafana and Prometheus using Docker / Native Kubernetes / EKS implementations.

Grafana + Prometheus demo (Docker sidecar, Kubernetes native, EKS IRSA).

This archive contains three implementations demonstrating how to store secrets in AWS Secrets Manager
and inject them into Grafana and Prometheus workloads:

1) Docker Compose (sidecar) - secrets-sidecar fetches secrets from AWS Secrets Manager and writes provisioning files.
2) Kubernetes native - uses ExternalSecrets operator (recommended) and includes raw Deployments/Services/ConfigMaps/PVCs.
3) EKS (IRSA) - Terraform skeleton to create IAM role for service account and manifests to annotate the service account, plus ExternalSecrets SecretStore and ExternalSecret manifests for syncing.

Assumptions:
- Secrets already exist in AWS Secrets Manager. Example names used in manifests: grafana/admin, grafana/datasource, prometheus/alertmanager
- You have AWS credentials (or IRSA for EKS) configured with permission: secretsmanager:GetSecretValue for the secrets.
- For Terraform k8s provider usage, kubeconfig must be available to the terraform process.

Quick start (Docker):
  cd docker
  cp .env.example .env
  # Ensure AWS credentials available to sidecar (mount ~/.aws or set env vars)
  docker-compose up --build

Quick start (Kubernetes native):
  kubectl apply -f k8s/common/namespaces.yaml
  kubectl apply -n monitoring -f k8s/common/grafana-provisioning-configmap.yaml
  kubectl apply -n monitoring -f k8s/common/prometheus-configmap.yaml
  # Install ExternalSecrets operator into the external-secrets namespace (recommended via Helm)
  kubectl apply -f k8s/native/secretstore.yaml -n external-secrets
  kubectl apply -f k8s/native/externalsecret.yaml -n monitoring
  kubectl apply -f k8s/native/grafana-deployment.yaml -n monitoring
  kubectl apply -f k8s/native/prometheus-deployment.yaml -n monitoring

Quick start (EKS + IRSA):
  - Create OIDC provider for your EKS cluster (if not already)
  - Use terraform/eks to create an IAM role and attach policy (fill in OIDC provider ARN)
  - Replace REPLACE_WITH_ROLE_ARN in k8s/eks/externalsecret_and_store.yaml ServiceAccount annotation
  - Install ExternalSecrets operator into external-secrets namespace using that ServiceAccount (annotated)
  - Apply k8s/eks manifests (ConfigMaps, ExternalSecret, Deployments)

See the per-folder README files for more details.


By the way,
> **_NOTE:_** Monitoring is essential - and effective monitoring and alerting is crucial for your services reliability and uptime. Have you had the thought and comparison of whether you want to build your own monitoring platform or do you want to buy it and pass on the responsibility to a vendor? Please feel free to reach out to us, we can help you decide: 

- [Devfero Info](mailto:info@devfero.cm?subject=Reaching%20out%20to%20Devfero)  
- [Devfero Dev](mailto:dev@devfero.com?subject=Reaching%20out%20to%20Devfero)

Prometheus and Grafana are great to get started, however, you can opt for managed services like Datadog and New Relic which are just as capable. It really depends on what you want to focus on for your business.