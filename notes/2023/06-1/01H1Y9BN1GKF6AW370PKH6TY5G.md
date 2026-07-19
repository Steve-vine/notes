---
id: 01H1Y9BN1GKF6AW370PKH6TY5G
created: 2023-06-02T14:49:34Z
updated: 2026-06-28T07:30:07.36155463Z
type: memo
title: Installing Argo CD on a Cluster
---
02-06-2023 15:49

Tags: #argodc #kubernetes  


---
https://argo-cd.readthedocs.io/en/stable/getting_started/

Create a namespace
```Bash
kubectl create namespace argocd
```


Install
```Bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
[[crossplane 1.png]]
Install the CLI
```Bash
brew install argocd
```

Change the service type to load balancer
```Bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Create a port forward to access the server
```Bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

Get the admin password - Username is 'admin'
```Bash
kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
```
```Bash
echo <base64 encoded password> | base64 --decode
```

---
## References