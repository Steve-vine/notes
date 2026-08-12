---
id: 01KZVFYBVBG4A2N5M88PYGVV5Y
created: 2026-08-12T17:22:26.79577Z
updated: 2026-08-12T17:23:20.759359Z
type: task
title: Switch to DB-encrypted external-API credentials (ADR 022)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 364
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- improvement
priority: medium
task_status: done
---
## Context

Brief 028 (DEV-184) shipped per-company external-API credentials as K8s Secrets in `redvektor-scans` (one Secret per `company × scanner`). Reconsidered immediately post-merge, before a second credential type lands and before any production data exists, the K8s-Secret approach has structural problems that…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-214](https://linear.app/stevevine/issue/DEV-214/switch-to-db-encrypted-external-api-credentials-adr-022)