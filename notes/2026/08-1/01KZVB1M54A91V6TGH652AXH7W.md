---
id: 01KZVB1M54A91V6TGH652AXH7W
created: 2026-08-12T15:56:50.724193Z
updated: 2026-08-12T15:58:09.944636Z
type: task
title: '`errors.py` docstring claims wrong wire format'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 87
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- chore
priority: low
task_status: backlog
---
Claims wire format is `{"error": {...}}` but FastAPI's `HTTPException` wraps under `detail` -> actual on-the-wire format is `{"detail": {"error": {...}}}`. Pre-existing, but now visible alongside the new code. Trivial doc fix.

Source: Obsidian To Do § From Brief 008a.

---

Imported from Linear [DEV-44](https://linear.app/stevevine/issue/DEV-44/errorspy-docstring-claims-wrong-wire-format) · parent DEV-13