---
id: 01JBCBJNWVDHB0TZKG6T2NHW3T
created: 2024-10-29T14:41:18.235Z
updated: 2025-04-07T16:16:01.348Z
type: memo
title: Cold Start
imported_from: Obsidian
---
29-10-2024 14:41

Tags: #crossplane #eks #aws #minikube 


---
## Description
This run-through describes how to build a Crossplane management cluster in EKS when no existing management cluster is available.  In other words, from a local cluster to bootstrap a new management cluster, in this case Minikube.

---
## Create Minikube instance
Create a local Minikube instance to bootstrap the build process
### Start up Minikube
Create a new Minikube instance (profile), this will be the bootstrap cluster
```
minikube start --profile=crossplane-bootstrap --cpus 8 --memory 8g
```

Check that the instance is running
```
minikube profile list
```

---
### Install Crossplane
If not already installed, install the Crossplane Helm repo
```
helm repo add crossplane-stable https://charts.crossplane.io/stable
```

If it is installed, make sure it's up to date
```
helm repo update
```

Install Crossplane from the Helm chart
```
helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane 
```

---
## Install the Crossplane Provisioner
Install the Crossplane provisioner into the Minikube cluster
### Obtain crossplane-provisioner
Clone the repo from Github
```
git clone git@github.com:Moneypenny-Development/crossplane-provisioner.git
```

Install the Helm chart
```
helm install crossplane-provisioner -n crossplane-system .
```
This may take about 4 minutes to install, you can watch the Providers to see progress 

---
## Install the Secrets
Install the secrets to allow Crossplane to download images from the OCI container registry and build resources in AWS
### AWS Administrative Secret
Create an IAM account in AWS called 'svc-crossplane_build' in the target AWS Account with the permissions required to build the required resources.  'AdministratorAccess' will do it but best practice should restrict this down to just the permissions required.

Create a set of access keys for this user and note down the <aws_access_key_id> and <aws_secret_access_key>

Create a file called 'aws-credentials.txt' with the following content
```
[default]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
```

Create a secret in the Minikube cluster 
```
kubectl create secret generic secret-aws-<account-name> -n crossplane-system --from-file=aws-creds=./aws-credentials.txt
```
Where  account-name is the name of the target AWS account e.g. secret-aws-management
### ECR Image Pull Secret
Create a secret in the Minikube cluster for the 'secret-crossplane-ecr-pull' AWS user from the Resource Account.
```
apiVersion: v1
kind: Secret
metadata:
	name: secret-crossplane-ecr-pull
	namespace: crossplane-system
data:
	aws_access_key_id: <aws_access_key_id>
	aws_secret_access_key: <aws_secret_access_key>
```

From the 'ecrtoken-provisioner' repo install the following:
```
kubectl apply -f templates/init/ecr-login-sa.yaml
kubectl apply -f templates/init/ecr-login-role.yaml
kubectl apply -f templates/init/ecr-login-rolebinding.yaml
kubectl apply -f templates/ecr-temp-token/ecr-token-refresh-job.yaml
kubectl apply -f templates/ecr-temp-token/ecr-token-refresh-cron.yaml
```
This will create a cron job that generates a temporary token called 'secret-helmrepo' which will be used to pull images from the AWS Resource account. 

---
## Deploy Komoplane
If required, Komoplane can be installed into the Minikube cluster

Deploy Komoplane
```
helm repo add komodorio https://helm-charts.komodor.io \
  && helm repo update komodorio \
  && helm upgrade --install komoplane komodorio/komoplane -n komoplane --create-namespace
```

To port forward Komoplane, run the following
```
export POD_NAME=$(kubectl get pods --namespace komoplane -l "app.kubernetes.io/name=komoplane,app.kubernetes.io/instance=komoplane" -o jsonpath="{.items[0].metadata.name}")
    export CONTAINER_PORT=$(kubectl get pod --namespace komoplane $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
    echo "Visit http://127.0.0.1:8090 to use your application"
    kubectl --namespace komoplane port-forward $POD_NAME 8090:$CONTAINER_PORT
```

---
## Deploy the AWS Cluster
You should now be able to deploy a cluster into AWS, just apply the XRD, Composition and Claim as required

---
## References