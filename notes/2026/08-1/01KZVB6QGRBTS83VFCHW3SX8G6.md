---
id: 01KZVB6QGRBTS83VFCHW3SX8G6
created: 2026-08-12T15:59:38.008722Z
updated: 2026-08-12T15:59:38.008722Z
type: task
title: CASCADE deletes could be expensive under load
imported_from: linear
label: tech_debt
assignee: steve
priority: low
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 106
---
Every tenant-scoped table cascades from `companies` — deleting a large company could traverse projects → targets → assets → findings / asset_history in a single transaction. Not a problem at current scale. Consider soft-delete + background cleanup before any company has >100k findings.

Source: Obsidian Issues Tracker #10 (P4 Low, Open). Flagged in Brief 003 session summary.

---

Imported from Linear [DEV-22](https://linear.app/stevevine/issue/DEV-22/cascade-deletes-could-be-expensive-under-load)