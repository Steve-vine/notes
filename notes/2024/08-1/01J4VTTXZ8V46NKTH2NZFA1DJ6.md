---
id: 01J4VTTXZ8V46NKTH2NZFA1DJ6
created: 2024-08-09T15:06:41Z
updated: 2024-08-29T09:45:01Z
type: memo
title: Create IAM role for managing AN EKS Cluster
---
09-04-2024 16:07

Tags: #aws #eks #iam  


---
### Overview
In order to access a Kubernetes (EKS) cluster from another account, and/or with a user that was not used to create the cluster, a cross-account role needs to be created, that has access to the cluster that a user can assume.
### Create a Custom IAM Policy
Create a policy that will be used locally to access the cluster
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

Edit the aws-auth ConfigMap in your EKS cluster to map this IAM role to a Kubernetes role
```
kubectl edit configmap aws-auth -n kube-system
```

Add a new section to mapRoles
```
- groups:
  - system:masters
  rolearn: arn:aws:iam::<EKS_ACCOUNT_ID>:role/EKSClusterAdminRole
  username: cross-account-admin
```

### Assume the Identity

Ensure that you are currently authenticated as your main login account
```
aws sts get-caller-identity
```

This should return something like
```
{
    "UserId": "AROAQIJRRZFYT3D7QR36I:S.Vine@moneypenny.co.uk",
    "Account": "017820666225",
    "Arn": "arn:aws:sts::017820666225:assumed-role/AWSReservedSSO_AdministratorAccess_6241051e8e63225e/S.Vine@moneypenny.co.uk"
}
```

Option 1 - Manually assume the role
```
aws sts assume-role --role-arn arn:aws:iam::024848449080:role/EKSClusterAdminRole --role-session-name MySession
```

This will return some json containing a temporary AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN

These can be set in the environmental variables
```
export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="AWS_SESSION_TOKEN"
```

Option 2 - Assume the role and set the variables with a single command
```
eval $(aws sts assume-role --role-arn arn:aws:iam::024848449080:role/EKSClusterAdminRole --role-session-name MySession --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text | awk '{print "export AWS_ACCESS_KEY_ID="$1"\nexport AWS_SECRET_ACCESS_KEY="$2"\nexport AWS_SESSION_TOKEN="$3}')
```

### Revert to IAM Identity Center User

To revert back, clear the environmantal variables
```
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```



---
## References