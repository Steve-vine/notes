---
id: 01HHYCGT5GBJSTBA6Z0YDQK1VD
created: 2023-12-18T11:55:58Z
updated: 2023-12-18T12:08:09Z
type: memo
title: Install Step-ca
imported_from: Obsidian
---
18-12-2023 11:56

Tags: #step-ca #kubernetes 


---
### Add the repo

```
helm repo add smallstep https://smallstep.github.io/helm-charts/
```  
```
helm repo update
```

### Install step locally

```
brew install step
```

### Create a Helm values.yaml
```
step ca init --helm > values.yaml
```

### Create password
```
echo "password" | base64 > password.txt
```

### Install the chart
```
helm install -f values.yaml \
     --set inject.secrets.ca_password=$(cat password.txt) \
     --set inject.secrets.provisioner_password=$(cat password.txt) \
     --set service.targetPort=9000 \
     step-certificates smallstep/step-certificates
```

### Get the PKI and Provisioner secrets
```
kubectl get -n default -o jsonpath='{.data.password}' secret/step-certificates-ca-password | base64 --decode
```

```
kubectl get -n default -o jsonpath='{.data.password}' secret/step-certificates-provisioner-password | base64 --decode
```
   



---
## References