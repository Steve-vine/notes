---
id: 01M4VFZG722YPMPQD7QZGVFAKM
created: 2026-10-13T20:41:33.154368Z
updated: 2026-10-13T20:58:03.283326Z
type: task
title: 'Bug: a sprint link doesn''t switch the Planner back to the Kanban board'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 544
sprint: sd52non
comments:
- id: 01M4VGXQ44BDWVSBYETDD0TCKW
  author: Steve Vine
  at: 2026-10-13T20:58:03.267295Z
  text: |-
    Fixed in PR #537 (merged 2026-10-13).

    openSprintBoard and openProjectBoard in Main.svelte now set active.kanban.view = "board" alongside the scope and sprint filter, so every sprint link (roadmap entry's linked sprint, Sprints section tally, Roadmap chart sprint row, pop-out link, right-panel sprint pick) and the initiative note's project-row jump land on the Kanban board rather than the tab's last chart.
assignee: steve
label:
- bug
priority: medium
task_status: done
tech: null
---
Clicking a sprint's "Show this sprint's tasks on the board" link (a roadmap entry's linked sprint on the note, the Sprints section's task count, or a sprint row on the Roadmap chart) scopes the board to the project and applies the sprint filter, but never resets the tab's view choice. If the tab was last on the Roadmap (or Gantt) view it stays on that chart, so from the Roadmap view the click looks like it did nothing — the filtered board is behind it.

Found on 1.3.0 after NOT-543; the gap arrived with the Roadmap view (NOT-533), since Gantt rows at least show the sprint.

## Proposed fix

- `openSprintBoard` in `Main.svelte` sets `active.kanban.view = "board"` alongside the scope and sprint filter, so the jump always lands on the Kanban board.
- Probably the same for `openProjectBoard` (an initiative note's project row jump, NOT-525), which has the same shape.