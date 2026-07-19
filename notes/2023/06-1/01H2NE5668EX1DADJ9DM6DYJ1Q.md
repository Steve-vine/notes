---
id: 01H2NE5668EX1DADJ9DM6DYJ1Q
created: 2023-06-11T14:35:57Z
updated: 2023-06-23T13:10:37Z
type: memo
title: Deploy Local Kubernetes Management Cluster
---
11-06-2023 15:36

Tags: #kubernetes #install


---
### Setup instances
Setup one or more VM's to act as the cluster.  Install linux, configure static IP's and assign DNS names.
Ensure that they can be contacted from the bastion machine used to build the cluster, preferably using keys.

### Install the Kubernetes cluster
Follow the instructions from the 'ansible-k3scluster' git repo.

### Copy down the kube config
[[Import kube config]]

### Add a secret to access an image repo to the required Namespace
[[Pull an Image from a Private Registry]]

### Install ArgoCD
[[Installing Argo CD on a Cluster]]

### Install Crossplane
[[Installing Crossplane]]

### Install Istio
[[Install Istio]]


---
## References