---
id: 01HGB6MJRGFKD5ERAVTKA979Z1
created: 2023-11-28T14:51:54Z
updated: 2023-11-28T15:02:32Z
type: memo
title: Create a Password Challenge  in Ingress
imported_from: Obsidian
---
28-11-2023 14:52

Tags: #ingress #password


---
### Create a Secret with User Credentials
```
htpasswd -c auth <username>
```
This will create a file called *auth* containing the encrypted password
### Create a Kubernetes secret from this file
```
kubectl create secret generic basic-auth --from-file=auth
```
### Configure ingress by adding annotations
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
spec:
  rules:
  - host: yourdomain.com
    http:
      paths:
      - path: /yourpath
        pathType: Prefix
        backend:
          service:
            name: your-service
            port:
              number: 80
```


---
## References