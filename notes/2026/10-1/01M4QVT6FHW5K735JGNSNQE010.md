---
id: 01M4QVT6FHW5K735JGNSNQE010
created: 2026-10-12T10:51:24.529551Z
updated: 2026-10-12T10:54:42.432308Z
type: task
title: 'Bulk edit a Kanban card selection: Sprint, Status, Priority, Assignee and user taxonomies'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 539
sprint: sd52non
assignee: steve
label:
- feature
- follow_up
priority: medium
task_status: backlog
tech:
- svelte
---
Follow-up to **NOT-536** (Cmd/Ctrl-click multi-select on the Kanban board).

Multi-select currently only moves cards between columns. Set a field across
the whole selection without having to regroup the board for it.

## What already works, and why this is still worth doing

Since NOT-536, a drop writes whatever axis the board is grouped by (DEV-838),
so **View By → Sprints + a group drag already is a bulk sprint assignment**,
and the same holds for Priority, Assignee and the project's user taxonomies.
The gap is the gesture, not the write: you have to regroup the whole board to
change one field on a few cards.

The right panel can't fill that gap — it holds a single note's shared
`DocHandle` (ADR 0010), so it is single-note by construction. Pointing it at
N cards would be a second write path, not a tweak.

## Agreed scope

A **right-click menu on a selected card, acting on the whole selection**:
Status ▸, Sprint ▸, Priority ▸, Assignee ▸, then the project's single-value
user taxonomies — exactly the fields that go through the one generic
`set_taxonomy_value` call, so no backend change is needed.

- Reuse `KanbanView.moveCard`'s per-note write loop: N writes, each
  `noteWrittenInApp`-marked (NOT-381), one refetch at the end, and the refetch
  still happens after a partial failure (NOT-536).
- Right-clicking an **unselected** card selects it first, then opens the menu
  — the `dragSet` rule, so a single-card right-click behaves as expected.
- **Sprint is disabled unless every selected card is in one project** — sprint
  ids are per-project (ADR 0024), the existing `sprintsEnabled` rule.
- Precedent to follow: `WorkspaceView.svelte` is the only right-click menu in
  the app today; `BoardColumnsMenu` / `BoardFilterMenu` / `BoardSortMenu`
  carry the popover styling to match.
- `brief/ui.md` gains the gesture.

Open question for planning: **no undo.** Twenty cards re-sprinted by mistake
is recoverable from git history but not from the UI. Decide whether a confirm
step above some card count is wanted, or whether a general undo is its own
task.

## Out of scope

- Due/start date and milestone — separate write paths plus a date picker in
  the menu; a later brief if wanted.
- The project link. Moving a task between projects sweeps taxonomies across
  the family (ADR 0027) — too much to do silently to a selection.
- Shift-click range select and marquee selection (also out of NOT-536).
- Multi-select on the Gantt, Timeline and list views.
