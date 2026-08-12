---
id: 01KZVB6DAEWDT9405QWERB4MZ1
created: 2026-08-12T15:59:27.566435Z
updated: 2026-08-12T15:59:27.566435Z
type: task
title: FastAPI route modules must import `AsyncSession` at module top
priority: low
label: chore
task_status: backlog
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 103
---
`from __future__ import annotations` stringifies type hints; FastAPI uses `typing.get_type_hints` which can't resolve `TYPE_CHECKING`-only imports. Workaround: import `AsyncSession` at module top in any file defining FastAPI dependencies. Worth a note in `CLAUDE.md` so future route modules don't trip on it.

Source: Obsidian Issues Tracker #15 (P4 Low, Open). Discovered mid-Brief 004.

---

Imported from Linear [DEV-25](https://linear.app/stevevine/issue/DEV-25/fastapi-route-modules-must-import-asyncsession-at-module-top)