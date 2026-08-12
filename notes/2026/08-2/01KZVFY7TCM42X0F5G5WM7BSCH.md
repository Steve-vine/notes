---
id: 01KZVFY7TCM42X0F5G5WM7BSCH
created: 2026-08-12T17:22:22.668889Z
updated: 2026-08-12T17:22:22.668889Z
type: task
title: 'Workflow run/schedule modals: false "engine no longer registered" for input-less Selectors'
assignee: steve
label:
- follow_up
- bug
task_status: done
priority: medium
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 362
---
## Symptoms

Clicking **Run** on a workflow whose first step is the Cloudflare Selector shows:

> This workflow's first step uses an engine that's no longer registered. Edit the workflow before running it.

…and the "Edit workflow" link below the message is a no-op (it points back to the workflow detail page the user is already on).

The same logic governs the **schedule** modal (`schedule-editor-modal.tsx`), so input-less Selector workflows alm…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-232](https://linear.app/stevevine/issue/DEV-232/workflow-runschedule-modals-false-engine-no-longer-registered-for)