---
id: 01H6KMWQ7GFZH0MFTXQJRQM36P
created: 2023-07-30T14:57:58Z
updated: 2023-07-30T15:05:05Z
type: memo
title: Restrict Access to an App Through LoadBalancer
imported_from: Obsidian
---
30-07-2023 15:58

Tags: #eks #nlb #elb


---
#### Restricting Access by IP Address

Use an annotation to specify an NLB (the default is Classic ELB) and add the loadBalancerSourceRanges property to specify a list of CIDR Blocks
```Bash
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  loadBalancerSourceRanges:
  - "86.149.89.230/32"
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: nginx
```

### Specify Internal Access Only

Add an annotation to use an internal load balancer, the type must be NLB
``` Bash
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: nginx
```

---
## References

https://repost.aws/knowledge-center/eks-cidr-ip-address-loadbalancer