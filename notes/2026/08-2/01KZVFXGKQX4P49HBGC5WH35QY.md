---
id: 01KZVFXGKQX4P49HBGC5WH35QY
created: 2026-08-12T17:21:58.903584Z
updated: 2026-08-12T17:21:58.903584Z
type: task
title: Add index on Asset.last_seen_at
label: chore
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 357
---
Add a B-tree index on `Asset.last_seen_at` to support efficient recency filtering by the asset-query Selector (Brief 037 / DEV-183).

## Context

Brief 037 introduced the asset-query Selector with an optional `last_seen_within_days` filter that translates to `Asset.last_seen_at >= now() - interval`. The Asset table…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-243](https://linear.app/stevevine/issue/DEV-243/add-index-on-assetlast-seen-at)