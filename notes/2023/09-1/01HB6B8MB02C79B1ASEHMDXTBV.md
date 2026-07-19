---
id: 01HB6B8MB02C79B1ASEHMDXTBV
created: 2023-09-25T14:18:04Z
updated: 2024-09-12T13:44:46Z
type: memo
title: Preparation
imported_from: Obsidian
---
25-09-2023 13:44

Tags: #crossplane #argocd #kubernetes #aws 


---
# Preparation

This assumes that a Kubernetes cluster has been built and kubeconfig has been setup

## Install Software Dependencies

### Argo-CD

Create the Argo-CD Namespace
```
kubectl create namespace argocd
```

Install Argo-CD
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

If running on an internal network with an internal load balancer, change the Argo-CD service to type LoadBalancer
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the initial Argo-CD Admin password
(Linux)
```
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep 'password:' | awk '{print $2}' | base64 -d
```
(Windows)
```
$secret = kubectl get secret argocd-initial-admin-secret -n argocd -o yaml; $passwordEncoded = ($secret -split "`n" | Where-Object { $_ -match 'password:' } | ForEach-Object { ($_ -split ':')[1].Trim() }); [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($passwordEncoded))
```
Login to Argo-CD with user: Admin and this password, then reset the password

### Crossplane

Add/Update the Crossplane Helm repo
```
helm repo add crossplane-stable https://charts.crossplane.io/stable
```
```
helm repo update
```

Install Crossplane
```
helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane 
```

## Install the Secrets

Install the image repository secret
```
kubectl apply -f _creds/crossplane-dockerhub.yaml
```

Install the AWS Access Keys secret
```
kubectl apply -f _creds/crossplane-aws.yaml
```

# Install the Crossplane Build Manifest

Clone a copy of the master-buildmanifest locally
```
git clone git@github.com:Steve-vine/master-buildmanifest.git
```

Apply the Providers
```
kubectl apply -f providers
```

Apply the ProviderConfig and the API's
```
kubectl apply -f providerconfig,apis,apis/net,apis/eks,apis/efs,apis/rds,apis/ebs,apis/cnpg
```


---
## References