---
id: 01KY738CG1C00V6N2PH6CQGPPG
created: 2026-07-23T09:00:13.185775Z
updated: 2026-07-23T21:05:07.297474Z
type: task
title: Project list updates
project: 01KY6W9951TW0904DT0GGJVGE7
number: 367
sprint: segj1dz
comments:
- id: 01KY7RG8NVKJS0GBM5TZ7D6SMQ
  author: Steve Vine
  at: 2026-07-23T15:11:31.514763Z
  text: 'PR #358 (branch not-367-panel-refresh): swept all panels — two gaps found and fixed: the projects list (Planner/Dashboard/Workspace) and the Properties panel''s dependency pills now follow noteRev, which external repo changes bump via note-changed. All other panels were already wired. svelte-check + 195 tests green.'
assignee: steve
label:
- bug
priority: medium
task_status: done
---
The project list in the left hand pane while in planner view doesn't update automatically when a change has occured in the underlying repo.

Sweep all left and right panels and ensure that they automatically reload if an incoming change has been detected in the repo.

---

Linear DEV-1020 · created 2026-07-23 · backlog