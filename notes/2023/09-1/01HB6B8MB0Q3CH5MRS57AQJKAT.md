---
id: 01HB6B8MB0Q3CH5MRS57AQJKAT
created: 2023-09-25T14:18:04Z
updated: 2023-09-25T15:43:27Z
type: memo
title: Preparation
---
25-09-2023 14:19

Tags: #crossplane #argocd #kubernetes #aws 


---
# Preparation

## Deployment Folder

Create a deployment folder with the following format
Name: \<project-name>-deploy
```
├── app-<app-name> (folder)
├── infra (folder)
├── <project-name>-app-<app-name>.yaml
└── <project-name>-infra.yaml
```
Each 'app' folder should contain a helm chart responsible for deploying an application into the environment.
The 'infra' folder should contain one or more Crossplane Claims to build components of the infrastructure.

'\<project-name>-app-\<app-name>.yaml' and '\<project-name>-infra.yaml' are Argo-CD application manifests which will deploy the infrastructure and applications.

## Argo-CD Repo Access

Log in to Argo-CD and connect the '\<project-name>-deploy' repository to allow Argo-CD to pull the infrastructure claim.

# Deploy the Infrastructure

Apply the infrastructure application manifest to Argo-CD
```
kubectl apply -f <project-name>-infra.yaml
```

Allow the infrastructure to build completely before continuing.

# Access and Configure the new Infrastructure

Retrieve the Kubeconfig for the new cluster
```
aws eks update-kubeconfig --region <region-code> --name <cluster-name>
```

Configure access to Argo-CD.  For production clusters, with internet access, this should be via a secure tunnel or internal network access.  This may require patching the service but Argo-CD should NOT be exposed to the internet
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the initial Argo-CD Admin password
```
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep 'password:' | awk '{print $2}' | base64 -d
```
Login to Argo-CD with user: 'admin' and this password, then reset the password

Log in to Argo-CD and connect the '\<project-name>-deploy' repository to allow Argo-CD to pull the infrastructure claim.

Install the AWS Access Keys secret
```
kubectl apply -f _creds/secret-docker.yaml
```

# Deploy the Applications

Using the Kubeconfig for the new cluster deploy the apps manifests into Argo-CD
```
kubectl apply -f <project-name>-app-<app-name>.yaml
```


---
## References