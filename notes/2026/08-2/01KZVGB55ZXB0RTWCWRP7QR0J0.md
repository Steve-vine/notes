---
id: 01KZVGB55ZXB0RTWCWRP7QR0J0
created: 2026-08-12T17:29:25.951708Z
updated: 2026-08-12T17:29:25.951708Z
type: task
title: Brief 004 — Authentication (local + JWT)
assignee: steve
imported_from: linear
label: brief
task_status: done
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 405
---
Argon2id, HS256 JWT with `kid` dispatch, 15 min access / 14 d refresh with rotation + breach detection, unscoped → company-pick flow, `redvektor-admin` CLI, progressive backoff. 138 tests, 86.27% coverage. Post-merge: alembic `env.py` decoupled from `Settings`.

**Brief spec:** [docs/briefs/004-authentication.md](<https://github.com/Steve-vine/redvektor/blob/main/docs/briefs/004-authentication.md>)
**Session summary:** [docs/sessions/004-authent…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-8](https://linear.app/stevevine/issue/DEV-8/brief-004-authentication-local-jwt)