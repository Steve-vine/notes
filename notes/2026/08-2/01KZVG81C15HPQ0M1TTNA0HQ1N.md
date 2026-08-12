---
id: 01KZVG81C15HPQ0M1TTNA0HQ1N
created: 2026-08-12T17:27:43.745112Z
updated: 2026-08-12T17:27:43.745112Z
type: task
title: Make brief-PR + implementation-PR separation explicit in docs/workflow.md
priority: high
task_status: done
label:
- follow_up
- chore
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 393
---
During Brief 010's implementation, Claude Code branched off the brief PR's branch (`brief-010-scan-engine-yaml`) instead of creating a new `scan-engine-yaml-loader` branch off main. As a result, the brief markdown commit and the implementation commits ended up in the same PR (#19). This conflates two things that should be separate:

* **The brief itself** — should land first as a planning doc, before any implementation begins.
* **The implementa…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-157](https://linear.app/stevevine/issue/DEV-157/make-brief-pr-implementation-pr-separation-explicit-in-docsworkflowmd) · parent DEV-16