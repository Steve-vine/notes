---
id: 01KZVAXHDPGD62B9N43PKMTKAH
created: 2026-08-12T15:54:36.854995Z
updated: 2026-08-12T15:54:36.854995Z
type: task
title: Beat HA in production
label: tech_debt
imported_from: linear
priority: low
assignee: steve
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 72
---
Currently single-replica by design. Revisit when a one-minute outage of scheduled tasks becomes meaningful — likely needs redbeat or celery-redbeat for distributed scheduler locking.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-67](https://linear.app/stevevine/issue/DEV-67/beat-ha-in-production)