---
id: 01KZVB1ZBDGMCMYFQ982J8EQKS
created: 2026-08-12T15:57:02.189506Z
updated: 2026-08-12T15:58:16.69678Z
type: task
title: Verify `helm upgrade` doesn't drop the database
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 90
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: backlog
---
Issue #21 (resolved) noted that the CNPG `Cluster` is annotated `pre-install` only, NOT `pre-upgrade`. Worth a manual upgrade run (deliberately change a config value, `helm upgrade`, verify Postgres pod uptime is preserved) before any production deploy.

Source: Obsidian To Do § From Brief 007.

---

Imported from Linear [DEV-39](https://linear.app/stevevine/issue/DEV-39/verify-helm-upgrade-doesnt-drop-the-database) · parent DEV-12