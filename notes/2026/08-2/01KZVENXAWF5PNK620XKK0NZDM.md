---
id: 01KZVENXAWF5PNK620XKK0NZDM
created: 2026-08-12T17:00:21.212756Z
updated: 2026-08-12T17:00:21.212756Z
type: task
title: Brief 117 — Report + current-state/audit/graph reads + UI (STACK)
imported_from: linear
label: feature
task_status: done
assignee: steve
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 255
---
ADR-037 sequence step 5 — the closing step: makes the current-state / audit / endpoint-graph model visible. **Design/epic** for a 2-unit STACK.

**Brief merged:** `docs/briefs/117-report-and-reads.md` (#310).

The prior briefs made the model writable but left it unread (Brief 114's edges are write-only). This surfaces it. Reports stay frozen point-in-time snapshots (ADR-037 §4); the run report only gains the `asset_new_vs_known` field (407 alrea…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-409](https://linear.app/stevevine/issue/DEV-409/brief-117-report-current-stateauditgraph-reads-ui-stack)