---
id: 01KY6YVMEATZ7GY9HHWETQABDY
created: 2026-07-23T07:43:21.034685Z
updated: 2026-07-23T09:18:26.23794Z
type: task
title: 'Kanban sidebar: collapsible Tasks menu with single + Cmd-multi project selection'
label:
- brief
task_status: done
assignee: steve
number: 66
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
sprint: sr2wq8c
---
Restructure the Kanban tab's left menu.

Below the `Projects` entry and its `<hr>`, add a collapsible **Tasks** menu (expanded by default) containing:

* **\[All Tasks\]** — all tasks across all projects *and* non-project tasks.
* **\[Ungrouped\]** — tasks not in any project.
* then the list of projects.

```
Projects
----------
v Tasks
  [All Tasks]
  [Ungrouped]
  Project 1
  Project 2
```

**Selection model:** change from add/remove toggling to **individual selection** — a plain click selects just that one item. **Cmd/Ctrl+click on a project** toggles it within a multi-project selection (so you can view several projects' tasks at once). All Tasks / Ungrouped are single-select.

Frontend-only; reuses the existing `task_board(projectIds, includeUnparented)` (All Tasks = all project ids + unparented).

---

Linear DEV-599 · M8 - Styling · created 2026-06-23 · done 2026-06-23