---
id: 01KZVB1QGX2H7EYBZBEJ89M53X
created: 2026-08-12T15:56:54.173447Z
updated: 2026-08-12T15:56:54.173447Z
type: task
title: Read-only role coverage gap on projects/targets endpoints
label:
- follow_up
- tech_debt
imported_from: linear
assignee: steve
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 88
---
`test_projects_endpoints.py` and `test_targets_endpoints.py` exercise GETs with `analyst`; the scan listing test covers `read_only`. All three share `get_current_user` so trivially correct, but a one-line `read_only` GET assertion in each suite closes the gap explicitly.

Source: Obsidian To Do § From Brief 008a.

---

Imported from Linear [DEV-43](https://linear.app/stevevine/issue/DEV-43/read-only-role-coverage-gap-on-projectstargets-endpoints) · parent DEV-13