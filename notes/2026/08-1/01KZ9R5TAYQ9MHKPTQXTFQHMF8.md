---
id: 01KZ9R5TAYQ9MHKPTQXTFQHMF8
created: 2026-08-05T19:59:59.838988Z
updated: 2026-08-06T08:02:26.911123Z
type: task
title: 'Fix: bulb opens Settings, eye hides the project name'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 395
sprint: segj1dz
assignee: steve
priority: high
task_status: done
---
Two faults from the sprint 35 work, both found on first use.

1. The hide-empty-sprints eye replaced the project name/link in the Project section's title row — a CSS specificity bug: `.results button { width: 100% }` beat the `.eye` rule, so the eye claimed the whole row and the name (with `min-width: 0`) collapsed.

2. The Suggest a feature bulb opened Settings → Projects on its first click. That was ADR 0050's designed behaviour for an unconfigured target, but a button labelled "Suggest a feature" opening a settings pane with no explanation reads as broken. It now asks inline and carries straight on into the capture form (ADR 0051 supersedes that one rule).

PR #386 — https://github.com/Steve-vine/notuvia/pull/386