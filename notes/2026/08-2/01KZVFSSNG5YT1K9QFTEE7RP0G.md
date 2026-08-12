---
id: 01KZVFSSNG5YT1K9QFTEE7RP0G
created: 2026-08-12T17:19:57.104357Z
updated: 2026-08-12T17:19:57.104357Z
type: task
title: Nuclei runner — shape-aware asset_kind classification for transport/DNS findings
label: bug
task_status: done
assignee: steve
priority: medium
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 347
---
**Type:** Bug
**Source:** Surfaced by Steve's re-smoke after Brief 047 (DEV-256) landed.

## Symptom

Workflow: `subfinder → httpx → nuclei` against 22 Moneypenny domains.

| Metric | Before Brief 047 | After Brief 047 |
| -- | -- | -- |
| `finding_count` | 631 | 525 |
| `…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-257](https://linear.app/stevevine/issue/DEV-257/nuclei-runner-shape-aware-asset-kind-classification-for-transportdns)