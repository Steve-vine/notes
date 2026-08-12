---
id: 01KZVFXGKQX4P49HBGC5WH35QY
created: 2026-08-12T17:21:58.903584Z
updated: 2026-08-12T17:22:55.168169Z
type: task
title: Add index on Asset.last_seen_at
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 357
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- chore
priority: null
task_status: done
---
Add a B-tree index on `Asset.last_seen_at` to support efficient recency filtering by the asset-query Selector (Brief 037 / DEV-183).

## Context

Brief 037 introduced the asset-query Selector with an optional `last_seen_within_days` filter that translates to `Asset.last_seen_at >= now() - interval`. The Asset table…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-243](https://linear.app/stevevine/issue/DEV-243/add-index-on-assetlast-seen-at)