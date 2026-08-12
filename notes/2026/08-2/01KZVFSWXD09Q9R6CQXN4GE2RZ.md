---
id: 01KZVFSWXD09Q9R6CQXN4GE2RZ
created: 2026-08-12T17:20:00.429023Z
updated: 2026-08-12T17:21:03.125947Z
type: task
title: Finding ingest — host-level Asset fallback when matched_at path doesn't resolve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 348
sprint: sz0gev3
assignee: steve
imported_from: linear
label:
- bug
priority: medium
task_status: done
---
**Type:** Bug / ingest behaviour
**Source:** Surfaced by Steve's first complete nuclei smoke run after DEV-112 (Brief 046) landed. Risk #10 in Brief 046 flagged this exact possibility; the smoke proves it materialises at scale.

## Symptom

Workflow: `subfinder → httpx → nuclei` against 22 Moneypenny domains. N…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-256](https://linear.app/stevevine/issue/DEV-256/finding-ingest-host-level-asset-fallback-when-matched-at-path-doesnt)