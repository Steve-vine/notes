---
id: 01HJTP90XTJYNQAW5D9R97HJMM
created: 2023-12-29T11:45:12.634Z
updated: 2023-12-29T11:46:41.197999Z
type: memo
title: Force a Re-sync of a Secret
imported_from: Obsidian
---
29-12-2023 11:45

Tags: #eso #secret  


---
To force an es to re-sync with its vault run the following
```
kubectl annotate es <es-name> -n <es-namespane> force-sync=$(date +%s) --overwrite
```

---
## References