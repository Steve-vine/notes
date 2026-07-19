---
id: 01H22YJ578SPB8E9PKS77HG8HD
created: 2023-06-04T10:17:05Z
updated: 2023-10-18T10:39:40Z
type: memo
title: Installing Crossplane
---
helmhelm list04-06-2023 11:17

Tags: #crossplane #kubernetes 


---
Add the Helm repo
```Bash
helm repo add crossplane-stable https://charts.crossplane.io/stable
```

Update the repo
```Bash
helm repo update
```

Install the Helm chart
```Bash
helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane 
```

Install CLI
```Bash
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
```
```
sudo mv kubectl-crossplane /usr/local/bin
```


---
## References