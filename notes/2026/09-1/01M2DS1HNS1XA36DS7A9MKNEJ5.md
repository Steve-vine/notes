---
id: 01M2DS1HNS1XA36DS7A9MKNEJ5
created: 2026-09-13T16:19:11.67306Z
updated: 2026-09-15T16:38:54.223117Z
type: memo
title: Compass installation
project: 01KXGC5PTGYHV30VM3E78G76S1
---
## Secrets

## Minikube
```
minikube start --cpus 2 --memory 4096
```
```
helm install compass oci://ghcr.io/steve-vine/compass/charts/compass --version 0.2.0 \
    -n compass --create-namespace --wait --timeout 10m \
    --set image.tag=0.2.0 --set frontend.image.tag=0.2.0 \
    --set size=evaluation --set postgres.enabled=true --set config.auth.cookieSecure=false \
    --set bootstrap.admin.enabled=true --set bootstrap.admin.email=mail@stevevine.uk
```
```
kubectl port-forward -n compass svc/compass-frontend 8080:80
```
## EKS
### Prerequisites
1. Cluster 
