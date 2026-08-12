---
id: 01KZVG48EJGMXMMDH27ZKGMWE2
created: 2026-08-12T17:25:39.922517Z
updated: 2026-08-12T17:26:36.500409Z
type: task
title: Add frontend toast notification system
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 380
sprint: s5d7bqn
assignee: steve
imported_from: linear
label: null
priority: low
task_status: done
---
Brief 016 (DEV-173) discovered the frontend has no toast/notification system. Cancel-scan ended up using an inline error banner because there was nothing to wire into. Other flows that should have toasts but don't: trigger-scan, target delete, project delete.

## Scope

Add a minimal toast …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-174](https://linear.app/stevevine/issue/DEV-174/add-frontend-toast-notification-system)