---
id: 01KZVFY9Q1K4T2R9D8ZTVV27HN
created: 2026-08-12T17:22:24.609787Z
updated: 2026-08-12T17:23:18.042409Z
type: task
title: 'Workflow composer: extend renderer for string / enum-string / typed-enum-list params'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 363
sprint: sv5cbvq
assignee: steve
imported_from: linear
label:
- follow_up
- bug
priority: medium
task_status: done
---
## Context

Surfaced during Brief 029 smoke test of the Cloudflare Selector (DEV-184). The workflow composer's schema-driven form renderer (Brief 021, `app/frontend/src/features/workflows/json-schema.ts`) only handles four field shapes today: `boolean`, `integer`, `number`, and `stringList` (the `Optional[list[str]]…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-215](https://linear.app/stevevine/issue/DEV-215/workflow-composer-extend-renderer-for-string-enum-string-typed-enum) · parent DEV-184