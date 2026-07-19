---
id: 01HFRNK3F0XQBMZPH1346CHPFX
created: 2023-11-21T10:07:40Z
updated: 2023-11-21T11:59:59Z
type: memo
title: Install Cert Manager
---
21-11-2023 10:07

Tags: #certmanager #ingress #ssl


---
### Install Cert Manager Helm Chart
```
helm repo add jetstack https://charts.jetstack.io
```
```
helm repo update
```

#### CRD's can be installed separately of as part of the Helm chart
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.crds.yaml
```

```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.2 \
  --set installCRDs=true
```

### Configure an issuer
#### Create a Staging Issuer
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # The ACME server URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: <email-address>
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-staging
    # Enable the HTTP-01 challenge provider
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
```

#### Create a Production Issuer
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: <email-address>
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
```

### Update the Ingress to include an annotation for the ingress-shim
```
metadata:
  name: <name>
  annotations:
    cert-manager.io/issuer: "letsencrypt-staging"
```

#### Check the certificate
```
kubectl get certificate
```
![[Pasted image 20231121115957.png]]

---
## References