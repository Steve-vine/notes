---
id: 01KZVAXHDPGD62B9N43PKMTKAH
created: 2026-08-12T15:54:36.854995Z
updated: 2026-08-12T15:55:46.441772Z
type: task
title: Beat HA in production
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 72
sprint: sw9wx5e
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: backlog
---
Currently single-replica by design. Revisit when a one-minute outage of scheduled tasks becomes meaningful — likely needs redbeat or celery-redbeat for distributed scheduler locking.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-67](https://linear.app/stevevine/issue/DEV-67/beat-ha-in-production)