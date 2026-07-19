---
id: 01HFRMCSW84KR0DCRR42Q1MFNS
created: 2023-11-21T09:46:45Z
updated: 2023-11-21T10:07:11Z
type: memo
title: Install Nginx Ingress Controller
---
21-11-2023 09:53

Tags: #nginx #ingress


---
### Install Helm chart
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
```
helm repo update
```
```
helm install <chart-name> ingress-nginx/ingress-nginx
```

### Create a Service to use Ingress
```
apiVersion: v1
kind: Service
metadata:
  name: <service-name>
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  selector:
    app: <app-selector>
```

### Create an Ingress Resource
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: <name>
  annotations: {}
    #cert-manager.io/issuer: "letsencrypt-staging"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - <domain-name>
    secretName: quickstart-example-tls
  rules:
  - host: <domain-name>
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: <service-name>
            port:
              number: 80
```

### Wait for the address to populate
```
kubectl get ingress
```

![[Pasted image 20231121100649.png]]





---
## References