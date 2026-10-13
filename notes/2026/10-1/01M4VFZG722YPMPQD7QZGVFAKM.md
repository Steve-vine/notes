---
id: 01M4VFZG722YPMPQD7QZGVFAKM
created: 2026-10-13T20:41:33.154368Z
updated: 2026-10-13T20:41:33.997386Z
type: task
title: 'Bug: a sprint link doesn''t switch the Planner back to the Kanban board'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 544
sprint: sd52non
assignee: steve
label:
- bug
priority: medium
task_status: backlog
tech: null
---
Clicking a sprint's "Show this sprint's tasks on the board" link (a roadmap entry's linked sprint on the note, the Sprints section's task count, or a sprint row on the Roadmap chart) scopes the board to the project and applies the sprint filter, but never resets the tab's view choice. If the tab was last on the Roadmap (or Gantt) view it stays on that chart, so from the Roadmap view the click looks like it did nothing — the filtered board is behind it.

Found on 1.3.0 after NOT-543; the gap arrived with the Roadmap view (NOT-533), since Gantt rows at least show the sprint.

## Proposed fix

- `openSprintBoard` in `Main.svelte` sets `active.kanban.view = "board"` alongside the scope and sprint filter, so the jump always lands on the Kanban board.
- Probably the same for `openProjectBoard` (an initiative note's project row jump, NOT-525), which has the same shape.