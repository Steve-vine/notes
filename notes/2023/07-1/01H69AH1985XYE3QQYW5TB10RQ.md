---
id: 01H69AH1985XYE3QQYW5TB10RQ
created: 2023-07-26T14:44:25Z
updated: 2023-08-23T09:59:30Z
type: memo
title: Provisioning EFS Storage to an EKS Cluster with Dynamic Provisioning
---
hel26-07-2023 14:43

Tags: #eks #efs


---
#### 1. Create an EFS file system

Open the Amazon EFS console at [https://console.aws.amazon.com/efs/](https://console.aws.amazon.com/efs/).

Ensure you are in the same region as the cluster.

Choose "Create file system".

Create a "Name" for the filesystem.

For "VPC", select the VPC that your EKS nodes are running in.

Create the file system.

Once the file system is created, note down the EFS file system ID.

#### 2. Install the Amazon EFS CSI driver in your EKS cluster

***When running this after the cluster was created with eksctl there was a service account already created called efs-csi-controller-sa -n kube-system that prevented the helm chart from installing correctly.  Manually deleting this account allowed the helm chart to run successfully.  The sa could have been created when I created the EKS storage volume***

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

#### 3. Add the Inbound Rule to the EFS Security Groups

Open the VPC console console.aws.amazon.com/vpc

Select **Security Groups** from the navigation

Find and select the security group associated with the EFS.
This can be found on the EFS Console by selecting the file system, going to the Network tab and checking the **Security Group** column

In the "Inbound Rules" tab, select "Edit Inbound Rules".

Click "Add Rule", select Type as "NFS", and in the "Source", Enter the security group of your EKS worker nodes.
The Security Group can be found by going to the EC2 Console, locating the nodes and copying the security group

Click "Save Rules".

#### 4. Add IAM Role to Worker Nodes

Navigate to the IAM service in the AWS Management Console.

Find the IAM role associated with your EKS worker nodes.

Click "Attach Policies", search for `AmazonElasticFileSystemFullAccess`, select it, and click "Add Permissions".

### Dynamic Provisioning

#### 1. Setup Permissions

Download the IAM Policy document
```Bash
curl -S https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.2.0/docs/iam-policy-example.json -o iam-policy.json
```

Create the IAM policy
```Bash
aws iam create-policy --policy-name EFSCSIControllerIAMPolicy --policy-document file://iam-policy.json
```

Associate IAM OIDC Provider with cluster
```Bash
eksctl utils associate-iam-oidc-provider --region=<region-name> --cluster=<cluster-name> --approve
```

Create a Kubernetes service account
```Bash
eksctl create iamserviceaccount --cluster=<cluster-name> --region <region-name> --namespace=kube-system --name=efs-csi-controller-sa --override-existing-serviceaccounts --attach-policy-arn=arn:aws:iam::<account-id>:policy/EFSCSIControllerIAMPolicy --approve
```

### Troubleshooting

Check the status of the AWS EFS CSI driver
```Bash
kubectl get pods -n kube-system | grep efs
```
Should be in the running state

Verify the Kubernetes Events: Check the events of the PVC and the EFS CSI driver's pods for any errors
```Bash
`kubectl describe pvc <pvc-name>` and `kubectl describe pod <efs-csi-pod-name> -n kube-system`
```

---
## References

https://aws.amazon.com/blogs/containers/introducing-efs-csi-dynamic-provisioning/
https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html