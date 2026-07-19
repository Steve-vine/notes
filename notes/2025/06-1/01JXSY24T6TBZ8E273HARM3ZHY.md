---
id: 01JXSY24T6TBZ8E273HARM3ZHY
created: 2025-06-15T13:56:59.846Z
updated: 2025-06-21T13:07:06.915999Z
type: memo
title: K3s Full Install
---
15-06-2025 14:56

Tags: #k3s 


---
This document details the installation process for a K3s Cluster complete with the following operators and configuration

- Cert-Manager
- External-Secrets-Operator
- External-DNS (Cloudflare)
- Ingress-Nginx (Internal)
- Komoplane
- Crossplane
### Pre-requisites

Must have a secret manifest for AWS where the Clousflare secret is stored
**~/code/_creds/eso-secret.yaml**

Add the following Helm Repos

```
helm repo add metallb https://metallb.github.io/metallb
```
```
helm repo add jetstack https://charts.jetstack.io
```
```
helm repo add external-secrets https://charts.external-secrets.io
```
```
helm repo add komodorio https://helm-charts.komodor.io
```
```
helm repo add argo https://argoproj.github.io/argo-helm
```

A Linux VM setup with static IP address
### Create the Cluster

SSH into the VM and run the K3s install, without the loadbalancer or Traefic
```
curl -sfL https://get.k3s.io | sh -s server \
--cluster-init \
--disable=servicelb \
--disable=traefik \
--tls-san <dns-name>
```
\<dns-name> specifies fully qualified domain name of the server for the certificate

View the K3s kube config
```
sudo cat /etc/rancher/k3s/k3s.yaml
```
Copy it locally to ./kube/\<clustername>.yaml
Change the URL IP Address to the FQDN, and change the 'default' name to the clustername
### Install the Operators

Back on your laptop, change config to the newly created one.
#### Install MetalLB
Set the MetalLB address pool to the desired range.
```
helm install metallb metallb/metallb --namespace metallb-system --create-namespace
```
Once the pods are running, apply the address pool and advertisement
Set the MetalLB address pool to the desired range in ./metallb/metallb-addr-pool.yaml
```
kubectl apply -f metallb
```
#### Install External-Secrets
```
helm install external-secrets \
external-secrets/external-secrets \
-n external-secrets \
--create-namespace
```
Install AWS Secret for Secrets Manager
```
kubectl apply -f ~/code/_creds/eso-secret.yaml
```
Wait for all the pods to start
Install cluster scoped secret store
```
kubectl apply -f external-secrets
```
#### Install Cert-Manager
```
helm install \
cert-manager jetstack/cert-manager \
--namespace cert-manager \
--create-namespace \
--set crds.enabled=true
```
Install the Cert-Manager cluster scoped Test and Prod Issuers
```
kubectl apply -f cert-manager
```
#### Install External-DNS
```
helm install external-dns ./external-dns -n external-dns-cloudflare --create-namespace
```
#### Install Ingress-Nginx
```
helm install ingress-nginx ./ingress-nginx -n ingress-internal --create-namespace
```
#### Install Komoplane
```
helm upgrade --install komoplane komodorio/komoplane -n komoplane --create-namespace
```
Install Komoplane cert and ingress
```
kubectl apply -f komoplane
```
#### Install Argo Rollouts
```
helm install argo-rollouts argo/argo-rollouts -n argo-rollouts --set dashboard.enabled=true --create-namespace
```
Install Argo Rollouts cert and ingress
```
kubectl apply -f argo-rollouts
```
### Install Argo CD
```
helm install argo-cd argo/argo-cd -n argo-cd -f ./argo-cd/values/values.yaml --create-namespace
```
Install Argo CD cert and ingress
```
kubectl apply -f argo-cd
```



---
## References