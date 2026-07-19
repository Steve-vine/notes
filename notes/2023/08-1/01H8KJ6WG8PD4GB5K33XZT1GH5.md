---
id: 01H8KJ6WG8PD4GB5K33XZT1GH5
created: 2023-08-24T10:42:29Z
updated: 2023-08-24T10:42:29Z
type: memo
title: Build OCI Image from Helm Chart and Upload to Docker Hub
imported_from: Obsidian
---
24-08-2023 11:19

Tags: #helm #oci #docker


---
#### Create chart template
```Bash
helm create <chart-name>
```
Update the chart as appropriate
The name and version will be taken from the Chart.yaml 

#### Package the chart as a tarball
```
helm package <chart-name>
```

#### Push the chart tarball to the registry
log in to Docker Hub
```Bash
helm registry login registry-1.docker.io -u <username>
```

Push the tarball up
```Bash
helm push <tarball-file> oci://registry-1.docker.io/<username>
```

#### Pull the OCI image back down
```Bash
helm pull oci://registry-1.docker.io/<username/<repository> --version <version-tag> --untar
```

---
## References