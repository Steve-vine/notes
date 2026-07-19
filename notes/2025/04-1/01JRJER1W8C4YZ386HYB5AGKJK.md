---
id: 01JRJER1W8C4YZ386HYB5AGKJK
created: 2025-04-11T12:56:10.376Z
updated: 2025-04-11T13:23:35.891999Z
type: memo
title: Setup API Gateway
---
11-04-2025 13:56

Tags: #aws #apigateway


---
### Requirements
Setup a service with an internal NLB
e.g.
```
apiVersion: v1
kind: Service
metadata:
  name: integrations-api-svc
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  selector:
    app: integrations-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

Get the name of the new load balancer
e.g.
```
a566f8deb293a42758d9f3c6760e9f25-7785e1b0a77c78a4.elb.eu-west-2.amazonaws.com
```

Deploy the API Gateway and a Resource via Crossplane
### Setup the API Gateway
In the API's service console create a new VPC Link, select the new load balancer as the target.
This may take a few minutes to setup

Select the Resource and create the required Methods, select an integration type of VPC Link, select the VPC Link from the dropdown.  The Endpoint URL should be the load balancer prefixed with http://






---
## References