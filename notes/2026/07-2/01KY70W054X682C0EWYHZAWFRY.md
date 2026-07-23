---
id: 01KY70W054X682C0EWYHZAWFRY
created: 2026-07-23T08:18:30.180876Z
updated: 2026-07-23T11:00:29.929996Z
type: task
title: Task ID
imported_from: null
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 173
comments:
- id: 01KY70W5YY6AH4XAKFTK4XZ0BE
  author: Steve Vine
  at: 2026-07-23T08:18:36.125886Z
  text: |-
    Steve Vine · 2026-07-04:

    Done as agreed — `BoardCard` carries an explicit `loose: bool` (task board only; a task in a project without an identifier still shows nothing rather than lying). Card shows a muted italic "Loose" in the display-id slot.

    **Decisions on the fly:** styled it italic + fainter than a real display id so it reads as a marker, not an identifier. Say if you'd rather it match the normal id style.

    **Problems encountered:** none. New Rust test covers unparented/parented/projects; full gate green.

    PR: https://github.com/Steve-vine/notuvia/pull/151
sprint: ssy6aak
label: null
---
When tasks are not part of a project, display 'Loose' where the project ID would normally be.

## Agreed work (planned 2026-07-04)

* Backend: `BoardCard` gains an explicit `loose: bool` — set in `task_board()` when the task has no project link; always false on the projects board. Explicit flag rather than "display_id is null", so a task in a project whose project lacks an identifier isn't mislabelled.
* Frontend: mirror `loose` in `board.ts`; `KanbanBoard.svelte` renders "Loose" (muted) in the `.card-id` slot when set.
* Rust tests: unparented task card carries `loose: true`; parented `false`.

---

Linear DEV-815 · Kanban board Improvements · created 2026-07-04 · done 2026-07-04