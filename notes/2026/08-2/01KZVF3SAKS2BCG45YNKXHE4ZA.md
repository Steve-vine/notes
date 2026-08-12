---
id: 01KZVF3SAKS2BCG45YNKXHE4ZA
created: 2026-08-12T17:07:55.859735Z
updated: 2026-08-12T17:07:55.859735Z
type: task
title: 'Post-P7 cleanup: retire write-dead ScanJob inputs path + audit tables'
assignee: steve
imported_from: linear
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 286
---
Post-P7 (DEV-326) cleanup. With `dispatch_scan` gone, nothing creates `ScanJob`s, so the legacy `/internal/scans/{id}/jobs/{id}/inputs` inputs-fetcher route and the `Scan`/`ScanJob` models are now write-dead. P7 left them in place (scope-respecting). This issue retires them on…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-336](https://linear.app/stevevine/issue/DEV-336/post-p7-cleanup-retire-write-dead-scanjob-inputs-path-audit-tables)