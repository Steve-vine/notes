---
id: 01KYC3R4XF8CB915F088M8WTGX
created: 2026-07-25T07:45:01.871621Z
updated: 2026-07-26T14:08:30.991047Z
type: task
title: Keyboard navigation in planner
project: 01KY6W9951TW0904DT0GGJVGE7
number: 370
sprint: segj1dz
comments:
- id: 01KYF98TQ6JM8E0YW896H32QYP
  author: Steve Vine
  at: 2026-07-26T13:19:14.662275Z
  text: |-
    Implemented in PR #362 (shared with NOT-372): https://github.com/Steve-vine/notuvia/pull/362

    With a card selected on the Kanban board, bare arrows move the highlight — ↑/↓ within a column, ←/→ to the nearest non-empty column keeping the row — and Enter opens the selected card over the board; the first arrow press selects the first card when nothing is selected. Stepping is a pure stepCard() in the new boardNav.ts (unit-tested); suppressed while the overlay or a time view owns the board. Needs a manual pass before merge.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
In planner mode, if a note is selected, allow the keyboard cursor keys to navigate the highlight between the cards.