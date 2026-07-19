---
id: 01GWV9J6E0GBYXF9N2T6REYXWZ
created: 2023-03-31T07:36:56Z
updated: 2023-03-31T07:36:56Z
type: memo
title: Deploy Kubernetes with Juju
---
31-03-2023 08:30

Tags: #juju #kubernetes 


---
https://ubuntu.com/kubernetes/docs/quickstart

Add the Kubernetes model
```Bash
juju add-model k8s
```

Deploy the kubernetes model
```Bash
juju deploy charmed-kubernetes
```

Monitor the deployment
```Bash
watch -c juju status --color
```

## Basic Operations
https://ubuntu.com/kubernetes/docs/operations



---
## References