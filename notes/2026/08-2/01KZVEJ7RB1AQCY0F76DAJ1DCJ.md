---
id: 01KZVEJ7RB1AQCY0F76DAJ1DCJ
created: 2026-08-12T16:58:20.811795Z
updated: 2026-08-12T16:58:20.811795Z
type: task
title: Audit engines' optional pattern params for the blank-"" vs omitted trap
label: follow_up
task_status: done
priority: medium
assignee: steve
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 247
---
## Context

Surfaced from DEV-374. In `cloudflare-dns-discovery`, an optional `name_pattern` field left blank in the UI submits `""` (not omitted/`None`); the `fnmatch` glob then matched nothing and filtered out every record. Fixed there by normalising blank → `None` at par…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-425](https://linear.app/stevevine/issue/DEV-425/audit-engines-optional-pattern-params-for-the-blank-vs-omitted-trap) · parent DEV-374