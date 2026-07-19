---
id: 01HBGT42W0Y4AMNQ2DA63PK4N5
created: 2023-09-29T15:50:08Z
updated: 2023-09-29T15:50:08Z
type: memo
title: Create a new backup
imported_from: Obsidian
---
29-09-2023 15:30

Tags: #velero #kubernetes #backup


---
# Create a new backup

## Backup a namespace
```
velero backup create namespace-isms --include-namespaces isms
```

## List all backups
```
velero get backups
```

## Create a Restore
```
velero restore create namespace-isms --from-backup namespace-isms
```





---
## References