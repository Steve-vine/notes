---
id: 01M2DS1HNS1XA36DS7A9MKNEJ5
created: 2026-09-13T16:19:11.67306Z
updated: 2026-09-18T20:44:34.989035Z
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
1. Cluster version must be >= 1.28
```
kubectl get nodes -o wide
```
2. Get the StorageClass name
```
kubectl get sc
```
3. Decide on hostname
4. Determine the bucket name
5. IAM Role for the pods

### Create S3 Bucket
```
AWS_PROFILE=<|Profile|> CLUSTER=cluster-envstaginguk-ekscluster BUCKET=mp-compass-files ./s3-irsa.sh
```

### Install Helm chart
```
helm upgrade --install compass oci://ghcr.io/steve-vine/compass/charts/compass --version <|Version|> \
      -n compass -f staging-aws.yaml --set image.tag=<|Version|> --set frontend.image.tag=<|Version|> --wait
```

### Create Admin account
```
kubectl -n compass exec deploy/compass-api -- \
      python -m compass_api.cli create-admin --email <|Email|> --password '<|Password|>' --name '<|Name|>'
```
E.g.
```
AWS_PROFILE=production CLUSTER=cluster-envproductionukpri-ekscluster \
  BUCKET=mp-envproductionpri-compass-prod-files NAMESPACE=compass-prod \
  examples/aws/s3-irsa.sh

---

# AWS Moneypenny Deployment
### Create the S3 Bucket
```
AWS_PROFILE=<|Profile|> CLUSTER=<|Cluster-Name|> BUCKET=<|Bucket-Name|> ./scripts/s3-irsa.sh
```
