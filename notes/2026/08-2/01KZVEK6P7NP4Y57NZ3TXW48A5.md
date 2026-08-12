---
id: 01KZVEK6P7NP4Y57NZ3TXW48A5
created: 2026-08-12T16:58:52.487003Z
updated: 2026-08-12T16:58:52.487003Z
type: task
title: Brief 118 — Scope-vs-Observed coverage view (+ CIDR expansion)
assignee: steve
imported_from: linear
task_status: done
label: feature
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 254
---
ADR-037 sequence step 6 — final brief. Depends on the Scope feed + anchor model (Briefs 115/116) and ideally the report surface (Brief 117).

Scope sketch (settled when Brief 118 is written):

* **Coverage = point-in-time diff of Declared Scope vs Observed State** (ADR-037 §1, no stored link): for the declared scope, what has/hasn't been observed. Match on natural identity (e.g. declared CIDR vs observed member).
* Absorbs the original DEV…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-410](https://linear.app/stevevine/issue/DEV-410/brief-118-scope-vs-observed-coverage-view-cidr-expansion)