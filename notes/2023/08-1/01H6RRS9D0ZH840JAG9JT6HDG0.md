---
id: 01H6RRS9D0ZH840JAG9JT6HDG0
created: 2023-08-01T14:42:12Z
updated: 2023-08-01T19:48:09Z
type: memo
title: EKS Deployment with eksctl
imported_from: Obsidian
---
01-08-2023 15:42

Tags: #eks #eksctl


---
### Create the Cluster

Create a definition yaml file
E.g. 'cluster.yaml'
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: u-eks-cluster
  region: eu-central-1
  version: "1.27"
  tags:
    project: u-test

nodeGroups:
  - name: u-eks-worker
    instanceType: t3.medium
    desiredCapacity: 3
```

Run eksctl create
```Bash
eksctl create cluster -f cluster.yaml
```

### Setup EFS

(Optional)
Check to see if an IAM OIDC driver is associated
```Bash
oidc_id=$(aws eks describe-cluster --name <cluster-name> --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
```
```Bash
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
```
This should the ID or the driver, if no output is given, associate the driver as below.

Associate the IAM OIDC Driver
```Bash
eksctl utils associate-iam-oidc-provider --cluster <cluster-name> --approve
```



---
## References

[Amazon EFS CSI driver - Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)