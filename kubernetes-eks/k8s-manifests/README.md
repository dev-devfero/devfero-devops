
# Kubernetes Manifests for Demo App

This folder contains **mature Kubernetes manifests** for a demo application:

- Deployment with 3 replicas, liveness and readiness probes, and resource limits
- LoadBalancer service
- Namespace isolation
- ConfigMap and Secret for environment variables and secrets

Apply manifests with:

```bash
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
