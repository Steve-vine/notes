---
id: 01H989GZVGN2QG070XPB07ZPPS
created: 2023-09-01T11:54:46Z
updated: 2023-09-01T11:54:46Z
type: memo
title: Create Kubernetes secrets for AWS API
imported_from: Obsidian
---
01-09-2023 12:47

Tags: #aws #kubernetes #secret


---
### Create credentials template

Create a txt file with the secrets (aws-credentials.txt)
```
[default]
aws_access_key_id = <aws_access_key>
aws_secret_access_key = <aws_secret_key>
```

### Create the Kubernetes secret

#### Using kubectl

Create the secret from the command line
```
kubectl create secret generic crossplane-secret-aws -n crossplane-system --from-file=aws-creds=./aws-credentials.txt
```

---
#### Using a manifest file

Base64 encode the credentials template
```
$ cat aws-credentials.txt | base64
```

Add the base64 encoded credentials to the manifest
```
apiVersion: v1
kind: Secret
metadata:
  name: crossplane-secret-aws
  namespace: crossplane-system
type: Opaque
data:
  aws-creds: <base64-encoded-credentials>
```

---
## References