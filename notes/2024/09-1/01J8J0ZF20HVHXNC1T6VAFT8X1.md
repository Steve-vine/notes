---
id: 01J8J0ZF20HVHXNC1T6VAFT8X1
created: 2024-09-24T12:44:24Z
updated: 2024-10-04T13:09:50Z
type: memo
title: OpenRita Steering
imported_from: Obsidian
---
24-09-2024 13:44

Tags: #openrita #meetings


---
### Objectives

Get OpenAnswer working in containers (Docker / Kubernetes)
Identify CI Solution that will be used to build the images and perform testing steps
Setup CI platform and build scripts to build images and store in ECR
Incorporate required testing steps into image build

Create the infrastructure build script to deploy the EKS cluster (create claim and add additional infrastructure - DB
Create the application deploy script (Helm chart to be managed by ArgoCD)

Support functionality and load tests on new environment - QA


### Challenges

(Tue, 24 Sep 2024)
Multi-config (Test US, Test UK, Prod US, Prod UK)
Images pushed to Azure
Need to document everything including manual steps

- [ ] Where are the build repos?
- [ ] Why is Argo Workflows running in it's own cluster?
- [ ] Why is Argo Workflows using an RDS instance?
 

---
## References