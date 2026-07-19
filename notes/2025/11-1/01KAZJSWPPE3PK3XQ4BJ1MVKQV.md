---
id: 01KAZJSWPPE3PK3XQ4BJ1MVKQV
created: 2025-11-26T07:59:45.366Z
updated: 2026-02-21T16:11:31.970999Z
type: memo
title: EC2 k3s Crossplane Build
---
ns26-11-2025 07:59

Tags: 


---
### Launch EC2 Instance
From the AWS console, launch a new instance
Typically, this will be something like an t3.xlarge or m6i.xlarge with a 40GiB EBS Volume
Choose Ubuntu for the OS
Select or create a key pair - Ensure you have the public key installed locally
Ensure it's installed in a private subnet
Open the following ports:

| Type       | Port Range | Source                  |
| ---------- | ---------- | ----------------------- |
| SSH        | 22         | VPC Private Subnet CIDR |
| Custom TCP | 6443       | VPC Private Subnet CIDR |
### Setup Twingate
Get the IP address of the instance from the AWS console
Create a new Twingate resource pointing to the instance IP address, with ports 22 and 6443

### Setup the Instance
ssh into the new instance e.g.
```
ssh -i ~/.ssh/bootstrap-cluster-kp.pem ubuntu@172.17.1.51
```

Install k3s
```
curl -sfL https://get.k3s.io | sh -s server \
  --cluster-init \
  --disable=servicelb \
  --disable=traefik
```

Get the context
```
sudo cat /etc/rancher/k3s/k3s.yaml
```
You'll need to change the IP address in the context from 127.0.0.1 to the IP of the instance and rename it from default to something usable
### Install Crossplane
Change to context to the new instance
Add the Crossplane Helm repo if if not already installed, otherwise just update it.
```
helm repo add crossplane-stable https://charts.crossplane.io/stable
```

Install Crossplane
```
helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane 
```

### Install Crossplane Library
Clone the github repo locally
```
git clone git@github.com:Moneypenny-Development/devops.library.crossplane.git
```

Within the library install the providers and functions
```
kubectl apply -f providers,functions
```
Wait for the providers and functions to become healthy before proceeding

Install the required API's
E.g.
```
kubectl apply -f apis/app
kubectl apply -f apis/cloudflare
kubectl apply -f apis/ebs
kubectl apply -f apis/efs
kubectl apply -f apis/eks
kubectl apply -f apis/net
kubectl apply -f apis/rds
kubectl apply -f apis/route53
kubectl apply -f apis/s3
kubectl apply -f apis/tgw
kubectl apply -f apis/twingate
```

Install the Crossplane Stacks
```
kubectl apply -f stacks
```
### Configure Access 
Crossplane 2 scopes resources to namespaces, meaning that projects (XR's) are installed in namespaces and will look for credentials in the same namespace.
Create a namespace for the project you are working on

Create a secret for the Crossplane user to allow creation of resources in the target account
The AWS keys belong to the 'svc-crossplane_build' user in the target account
Create a txt file called 'aws-credentials.txt'
```
[default]
aws_access_key_id = <aws-accesskey-id>
aws_secret_access_key = <aws-accesskey>
```

Create the secret from the credentials file
account-name Refers to the target account e.g.  sandbox 
```
kubectl create secret generic secret-aws-<account-name> \
	-n <namespace> \
	--from-file=aws-creds=aws-credentials.txt \
	--dry-run=client -o yaml | kubectl apply -f -
```

Create a ProviderConfig for the account
```
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
	name: providerconfig-aws-<account-name>
	namespace: <namespace>
spec:
	credentials:
		source: Secret
		secretRef:
			namespace: <namespace>
			name: secret-aws-<account-name>
			key: aws-creds
```
