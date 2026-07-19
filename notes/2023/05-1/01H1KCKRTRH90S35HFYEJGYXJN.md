---
id: 01H1KCKRTRH90S35HFYEJGYXJN
created: 2023-05-29T09:14:47Z
updated: 2023-05-29T15:56:34Z
type: memo
title: Connect to Bash on a Kubernetes Pod
imported_from: Obsidian
---
29-05-2023 10:15

Tags: #kubernetes #kubectl 


---
Exec into Bash on a pod
```Bash
kubectl exec <pod> -c <container> -i -t -- bash -il
```

---
## References