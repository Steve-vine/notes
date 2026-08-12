---
id: 01KZVAXVYCHAF2H4G1W63S04QV
created: 2026-08-12T15:54:47.628917Z
updated: 2026-08-12T15:55:55.879977Z
type: task
title: Rate-limiting on non-login endpoints
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 75
sprint: sb1sfzd
assignee: steve
imported_from: linear
label:
- feature
priority: medium
task_status: backlog
---
Login already has progressive backoff. Apply per-tenant rate limits on writes (e.g. scan create, project create) to bound resource use.

Source: Obsidian To Do § Backlog.

---

Imported from Linear [DEV-62](https://linear.app/stevevine/issue/DEV-62/rate-limiting-on-non-login-endpoints)