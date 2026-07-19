---
id: 01J4VTTXZ8RK915CVCAVYMEVHT
created: 2024-08-09T15:06:41Z
updated: 2024-11-29T11:34:16.937999Z
type: memo
title: Please edit the object below. Lines beginning with a '#' will be ignored,
imported_from: Obsidian
---
:q:q
09-04-2024 16:07

Tags: #aws #eks #iam  


---
### Overview
In order to access a Kubernetes (EKS) cluster from another account, and/or with a user that was not used to create the cluster, a cross-account role needs to be created, that has access to the cluster that a user can assume.
### Create a Custom IAM Policy
Create a policy in the account with the cluster to be managed that will be used to access the cluster
Policy Name: EKSClusterAccess
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:ListNodegroups",
                "eks:DescribeNodegroup",
                "ec2:DescribeInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        }
    ]
}
```
### Create an IAM role in the Cluster account
In the AWS account where the EKS cluster is hosted, create an IAM role that users from the other account can assume.

Go to the IAM console in the EKS account.
Create a new IAM role (AWS Account).
For the "Trusted entities," specify the AWS account ID of the other account.
Attach the EKSClusterAccess policy

Role Name: EKSClusterAdminRole
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<org-admin-account-id>:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
### Update aws-auth Config Map

##### *The below is accomplished using the eksconfig-provisioner now but this describes the manual steps*

Edit the aws-auth ConfigMap in your EKS cluster to map this IAM role to a Kubernetes role
```
kubectl edit configmap aws-auth -n kube-system
```

Add a new section to mapRoles
```
- rolearn: arn:aws:iam::509399617384:role/EKSClusterAdminRole
	username: cross-account-admin
	groups:
	- system:masters
```

The initial default configmap will look like this
```
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
	mapRoles: |
	- groups:
		- system:bootstrappers
		- system:nodes
		rolearn: arn:aws:iam::509399617384:role/mc-networksandbox-role-eksnode
		username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
	creationTimestamp: "2024-10-31T16:10:43Z"
	name: aws-auth
	namespace: kube-system
	resourceVersion: "1130"
	uid: 9941ba85-c06a-4290-8cc5-ae6b27f7be9b
```

Ultimately we want it to look like this
```
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
	mapRoles: |
	- groups:
		- system:bootstrappers
		- system:nodes
		rolearn: arn:aws:iam::509399617384:role/mc-networksandbox-role-eksnode
		username: system:node:{{EC2PrivateDNSName}}
	- rolearn: arn:aws:iam::509399617384:role/EKSClusterAdminRole
		username: cross-account-admin
		groups:
		- system:masters
kind: ConfigMap
metadata:
	creationTimestamp: "2024-10-31T16:10:43Z"
	name: aws-auth
	namespace: kube-system
	resourceVersion: "1130"
	uid: 9941ba85-c06a-4290-8cc5-ae6b27f7be9b
```

---
## References