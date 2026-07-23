---
id: 01KY72MR4QXTTR49Z4V69G3DS2
created: 2026-07-23T08:49:29.751218Z
updated: 2026-07-23T11:03:36.340838Z
type: task
title: Gantt view skeleton — Board ⇄ Gantt toggle and read-only chart
task_status: done
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 296
sprint: scnde4j
label: null
---
Part 2 of the Gantt capability (DEV-685). Depends on DEV-948 (start dates).

A segmented **Board ⇄ Gantt** control in the Kanban toolbar, shown only when the board is scoped to one project; the choice persists per tab (`KanbanState.view`). Board-only controls (View By, sort, columns) hide while the Gantt shows.

New `GanttChart.svelte` (custom Svelte CSS-grid/SVG, no chart dependency), read-only in this issue:

* Left rail: sprint group headers + task rows (display id + title); click opens the card overlay.
* Time grid: day columns, **today line**, **weekend shading**.
* **Sprint bands** spanning their member tasks (min start/due → max due) with a **% complete** chip (DEV-831 is_done counting rule).
* Task bars tinted by status colour; ghost tasks in the DEV-901 violet; **project envelope** from the project's Start/End (derived from tasks when unset).
* "Unscheduled" collapsible list for dateless tasks.
* Data from the existing `task_board` cards (which gain `start` in DEV-948) + `project_sprints`; refreshes on noteRev/taxonomyRev like the board.

`brief/ui.md` update lands here.

---

Linear DEV-949 · Project Enhancements · created 2026-07-11 · done 2026-07-12