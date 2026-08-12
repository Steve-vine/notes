---
id: 01KZVB1M54A91V6TGH652AXH7W
created: 2026-08-12T15:56:50.724193Z
updated: 2026-08-12T15:56:50.724193Z
type: task
title: '`errors.py` docstring claims wrong wire format'
assignee: steve
label:
- follow_up
- chore
priority: low
imported_from: linear
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 87
---
Claims wire format is `{"error": {...}}` but FastAPI's `HTTPException` wraps under `detail` -> actual on-the-wire format is `{"detail": {"error": {...}}}`. Pre-existing, but now visible alongside the new code. Trivial doc fix.

Source: Obsidian To Do § From Brief 008a.

---

Imported from Linear [DEV-44](https://linear.app/stevevine/issue/DEV-44/errorspy-docstring-claims-wrong-wire-format) · parent DEV-13