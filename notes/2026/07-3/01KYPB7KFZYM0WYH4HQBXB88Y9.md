---
id: 01KYPB7KFZYM0WYH4HQBXB88Y9
created: 2026-07-29T07:08:12.671273Z
updated: 2026-07-30T13:16:44.738368Z
type: task
title: Kanban view prefs scope
project: 01KY6W9951TW0904DT0GGJVGE7
number: 377
order: 1.25
sprint: segj1dz
comments:
- id: 01KYSFXS6WR031V8HRBY34SHE7
  author: Steve Vine
  at: 2026-07-30T12:27:57.020482Z
  text: |-
    Up for review together with NOT-380: PR #369 (branch not-377-380-scoped-board-prefs) — one PR because "Columns" here and the visible-columns section there share the same scope plumbing.

    Scopes: All Tasks, Loose Tasks, the Projects board, and each project (a multi-select keeps a stable scope of its own). Order persists per scope (old global choice is the fallback until a scope is retuned). Filter and View By stay transient across launches — as before, deliberately — but now remember themselves per selection within a session. Say the word if you'd rather they persist across launches too.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Make Kanban view preferences (Filter, Columns and Order) scoped to the task selected in tasks (All tasks, Loose tasks or individual projects).