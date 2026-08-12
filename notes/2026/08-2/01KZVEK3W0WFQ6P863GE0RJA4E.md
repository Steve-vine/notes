---
id: 01KZVEK3W0WFQ6P863GE0RJA4E
created: 2026-08-12T16:58:49.600754Z
updated: 2026-08-12T16:59:54.665251Z
type: task
title: Edge-level relink/reappear audit events
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 253
sprint: sv10nf2
assignee: steve
imported_from: linear
label:
- feature
priority: low
task_status: done
---
Deferred from Brief 115 (DEV-407, ingest reconciliation).

When a previously time-bound `DERIVED_FROM` (or other) edge is re-observed, `upsert_asset_relationship` currently clears `disappeared_at` **silently** — it emits `LINKED` only on first insert (Brief 114). Brief 115…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-411](https://linear.app/stevevine/issue/DEV-411/edge-level-relinkreappear-audit-events)