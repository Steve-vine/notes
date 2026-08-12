---
id: 01KZVB6GS8Z96W8GN3E2HFMH73
created: 2026-08-12T15:59:31.112899Z
updated: 2026-08-12T16:00:47.750859Z
type: task
title: Refresh tokens not revoked on user soft-delete
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 104
sprint: sb1sfzd
assignee: steve
imported_from: linear
label:
- bug
priority: medium
task_status: backlog
---
If a user is soft-deleted, their access tokens are rejected next request (via `get_current_user`'s `deleted_at` check), but existing refresh tokens remain usable-looking in the DB. Harmless today — refresh rotation would fail at the user reload step — but cleaner to revoke proactively when the user-deletion endpoint lands.

Source: Obsidian Issues Tracker #13 (P3 Medium, Open). Flagged in Brief 004 session summary.

---

Imported from Linear [DEV-24](https://linear.app/stevevine/issue/DEV-24/refresh-tokens-not-revoked-on-user-soft-delete)