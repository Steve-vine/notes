---
id: 01H75VFAPR0XRS5CGWXFG1N6KK
created: 2023-08-06T16:39:19Z
updated: 2023-08-06T17:47:10Z
type: memo
title: Crossplane deployment
---
06-08-2023 17:39

Tags: #eks #crossplane 


---
### Create the infrastructure

Deploy the following manifests
```Bash
kubectl apply -f vpc.yaml,subnets.yaml,routetables.yaml,gateways.yaml,eks.yaml,efs.yaml
```

Retrieve kube config
```Bash
aws eks update-kubeconfig --region <region-code> --name <cluster-name>
```
### Install the EFS CSI Driver

Add the EFS CSI driver Helm repository
```Bash
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
```

Update your Helm repository
```Bash
helm repo update
```

Install the EFS CSI driver
```Bash
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver --namespace kube-system
```
### Setup OIDC

Associate IAM OIDC Provider with cluster
```Bash
eksctl utils associate-iam-oidc-provider --region=<region-name> --cluster=<cluster-name> --approve
```
### Create Service Account

Create a Kubernetes service account
```Bash
eksctl create iamserviceaccount --cluster=<cluster-name> --region <region-name> --namespace=kube-system --name=efs-csi-controller-sa --override-existing-serviceaccounts --attach-policy-arn=arn:aws:iam::<account-id>:policy/efs-csi-controller-iam-policy --approve
```

### View all CRD's

```Bash
watch -n 1 kubectl get vpc,subnets,routetable,routetableassociation,internetgateway,eip,natgateway,route.ec2,role.iam,policy.iam,rolepolicyattachment,securitygroup,securitygrouprule,cluster.eks,nodegroup.eks,filesystem,mounttarget
```

---
## References