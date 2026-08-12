---
id: 01KZVFG3VPWVT775D8P2VXCVRA
created: 2026-08-12T17:14:39.862339Z
updated: 2026-08-12T17:18:25.499116Z
type: task
title: Engine-controller doesn't retry failed EngineVersion validation
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 322
sprint: ssxh43d
assignee: steve
imported_from: linear
label: null
priority: medium
task_status: done
---
## Symptom

On a fresh `helm install` of the RedVektor chart, only 1 of 5 seeded EngineVersions reaches `Ready=True`. The other 4 stick at `Ready=False` indefinitely with:

```
Reason:  ValidationFailed
Message: engineRef.name '<engine>' does not resolve to a known Engine — apply the Engine CR first.
```

…even though the referenced `Engine` CR is present in the cluster and `Ready=True`.

Observed live on the EC2 cluster (k3s) after running `set…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-290](https://linear.app/stevevine/issue/DEV-290/engine-controller-doesnt-retry-failed-engineversion-validation)