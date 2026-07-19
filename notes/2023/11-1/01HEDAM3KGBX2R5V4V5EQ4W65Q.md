---
id: 01HEDAM3KGBX2R5V4V5EQ4W65Q
created: 2023-11-04T14:08:38Z
updated: 2023-12-05T17:07:58Z
type: memo
title: Update buildmanifest Repos
imported_from: Obsidian
---
04-11-2023 14:09

Tags: #helm #orchestration


---
### Argo-CD

Add Helm repo
```
helm repo add argo https://argoproj.github.io/argo-helm
```
```
helm repo update
```

Find latest version
```
helm search repo argo
```

Pull latest version
```
helm pull argo/argo-cd
```

Log in to Docker Hub
```
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

### External Secrets Operator

Add Helm repo
```
helm repo add external-secrets https://charts.external-secrets.io
```
```
helm repo update
```

Find latest version
```
helm search repo external
```

Pull latest version
```
helm pull external-secrets/external-secrets
```

Log in to Docker Hub
```
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

### ESO Cluster Dependancies

Clone the GitHub repo
```
git clone git@github.com:Steve-vine/eks-eso-provisioning.git
```

After making changes, update chart version accordingly

Package the chart
```
helm package eks-eso-provisioning
```

log in to Docker Hub
```Bash
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```Bash
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

### EFS Cluster Dependancies

Clone the GitHub repo
```
git clone git@github.com:Steve-vine/eks-efs-provisioning.git
```

Add the driver Helm repo
```
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
```
```
helm repo update
```

Find latest version
```
helm search repo efs
```

Pull latest version
```
helm pull aws-efs-csi-driver/aws-efs-csi-driver --untar
```

Replace the aws-efs-csi-driver folder in the eks-efs-provisioning repo with the newly pulled chart

After making changes, update chart version accordingly

Package the chart
```
helm package eks-efs-provisioning
```

log in to Docker Hub
```Bash
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```Bash
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

### EBS Cluster Dependancies

Clone the GitHub repo
```
git clone git@github.com:Steve-vine/eks-ebs-provisioning.git
```

Add the driver Helm repo
```
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
```
```
helm repo update
```

Find latest version
```
helm search repo ebs
```

Pull latest version
```
helm pull aws-ebs-csi-driver/aws-ebs-csi-driver --untar
```

Replace the aws-ebs-csi-driver folder in the eks-ebs-provisioning repo with the newly pulled chart

After making changes, update chart version accordingly

Package the chart
```
helm package eks-ebs-provisioning
```

log in to Docker Hub
```Bash
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```Bash
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

---
## References