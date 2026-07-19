---
id: 01HE1FBGGG2S994ARAX4N48XAF
created: 2023-10-30T23:40:26Z
updated: 2023-11-01T17:11:56Z
type: memo
title: Setup and Install ESO
imported_from: Obsidian
---
30-10-2023 12:55

Tags: #eso #kubernetes #secret 


---
Add the Repo
```
helm repo add external-secrets https://charts.external-secrets.io
```

Install the Helm chart
```
helm install external-secrets external-secrets/external-secrets --set serviceAccount.name=<sa-name> --set serviceAccount.create=false -n external-secrets --create-namespace
```


---
## References