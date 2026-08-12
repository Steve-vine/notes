---
id: 01KZVAXY4JMGGVYF6AV1Y22KYN
created: 2026-08-12T15:54:49.874018Z
updated: 2026-08-12T15:55:58.170329Z
type: task
title: Audit log (who did what, when)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 76
sprint: sb1sfzd
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: backlog
---
Phase 8 work but worth scoping earlier so the schema stays consistent. Every state-changing API call writes an immutable audit row with actor, timestamp, action, target.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-61](https://linear.app/stevevine/issue/DEV-61/audit-log-who-did-what-when)