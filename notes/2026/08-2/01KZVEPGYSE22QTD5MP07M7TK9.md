---
id: 01KZVEPGYSE22QTD5MP07M7TK9
created: 2026-08-12T17:00:41.305289Z
updated: 2026-08-12T17:00:41.305289Z
type: task
title: Brief 114 — Asset relationship graph (typed, temporal) + audit edge events
assignee: steve
imported_from: linear
label:
- brief
- feature
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 259
---
Second brief in the ADR-037 sequence (milestone "Resolve asset DB conflicts"). The keystone schema — but de-risked by grounding (see below).

Implements ADR-037 §2 (relationship graph) + §3 (audit trail), narrowed to the structural foundation:

**Grounding findings:**

* The asset **audit trail already exists**: `AssetHistory` + event types DISCOVERED/SEEN/DISAPPEARED/REAPPEARED/META_CHANGED, written by `AssetUpsertService`. "New vs known" is al…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-385](https://linear.app/stevevine/issue/DEV-385/brief-114-asset-relationship-graph-typed-temporal-audit-edge-events)