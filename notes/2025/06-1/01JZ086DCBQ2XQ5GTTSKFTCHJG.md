---
id: 01JZ086DCBQ2XQ5GTTSKFTCHJG
created: 2025-06-30T11:05:13.867Z
updated: 2025-06-30T11:08:01.947Z
type: memo
title: Adding another cluster
imported_from: Obsidian
---
30-06-2025 12:05

Tags: #argocd 


---
Log in to Argo-CD via CLI
```
argocd login k3s-sandbox-argo-cd.citops.net --username admin --password admin --insecure --grpc-web
```

If the cluster to be added is in the current kube context
```
argocd cluster add vcluster-test --server k3s-sandbox-argo-cd.citops.net
```

If the context is in another file
```
KUBECONFIG=~/.kube/<context-file> argocd cluster add vcluster-test --server k3s-sandbox-argo-cd.citops.net
```


---
## References