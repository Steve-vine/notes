---
id: 01JWGC1C1MEE9WHQHHME898J8W
created: 2025-05-30T10:33:08.404Z
updated: 2025-06-02T06:38:33.085Z
type: memo
title: Installing EFS as an EKS Add-on
imported_from: Obsidian
---
30-05-2025 11:33

Tags: #aws #efs 


---
##### This process describes how to install and setup the EFS CSI Driver using the IAM Roles for Service Accounts (IRSA) Method

### Step 1 - Create a new Role

- Type: Web Identity
- Identity Provider: OpenID Connect Provider URL for Cluster
- Audience: sts.amazonaws.com
- Permissions Policy: AmazonEFSCSIDriverPolicy

Edit the Role Trust Relationship
In the Condition section, directly below **"StringEquals": {**  add the following line
```
"oidc.eks.<region>.amazonaws.com/id/<OIDC-Provider-ID>:sub": "system:serviceaccount:kube-system:efs-csi-*",
```

Modify the Condition operator from "StringEquals" to "StringLike"

The Trust relationship should look like this
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::124355659293:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/21A4A7FFB3968CCC94BFDD9469264724"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringLike": {
				    "oidc.eks.eu-west-2.amazonaws.com/id/21A4A7FFB3968CCC94BFDD9469264724:sub": "system:serviceaccount:kube-system:efs-csi-*",
					"oidc.eks.eu-west-2.amazonaws.com/id/21A4A7FFB3968CCC94BFDD9469264724:aud": "sts.amazonaws.com"
				}
			}
		}
	]
}
```

### Step 2 - Install the Amazon EFS CSI Driver
Install the add-on
- Name: EFS CSI Driver
- Version: v2.1.8-eksbuild.1
- Add-on access: IRSA
- IAM Role: *Created in previous step*

### Step 3 - Setup EFS Filesystem
Deploy the Crossplane EFS Provisioner
- Create Mount Target Security Group
- Create File System
- Create Mount Target - Zone 1
- Create Mount Target - Zone 2
- Add the Inbound Rule to the EFS Security Groups - Private Subnet 1
- Add the Inbound Rule to the EFS Security Groups - Private Subnet 2
- Attach Policy to EKS Node Role (AmazonElasticFileSystemFullAccess)

### Step 4 - Deploy EFS Provisioner
Deploy as part of the Crossplane EFS Provisioner
- Install the StorageClass
- Install the ServiceAccount

---
## References

https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html