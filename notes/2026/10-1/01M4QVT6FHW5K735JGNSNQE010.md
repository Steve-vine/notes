---
id: 01M4QVT6FHW5K735JGNSNQE010
created: 2026-10-12T10:51:24.529551Z
updated: 2026-10-12T12:36:30.943694Z
type: task
title: 'Bulk edit a Kanban card selection: Sprint, Status, Priority, Assignee and user taxonomies'
project: 01KY6W9951TW0904DT0GGJVGE7
number: 539
sprint: sd52non
comments:
- id: 01M4R1T2YX8KTPBVF9FM2XW3VZ
  author: Steve Vine
  at: 2026-10-12T12:36:12.378752Z
  text: |-
    Done on brief-539-bulk-edit-selection, PR #531 (squash `afb38f4`).

    Right-click a selected card and set one field on every selected card: pick an
    axis, pick a value. Status, Sprint, Priority, Assignee and the project's
    single-value user taxonomies — exactly the fields that ride the one generic
    `set_taxonomy_value` call, so no backend change was needed. Each value list
    ends with "No <axis>", which clears the field.

    Decisions made on the fly:

    - **Two pages, not hover submenus.** The popover shows the axis list, then
      swaps to that axis's values with a back row. No submenu positioning to get
      wrong, and the menu stays small whatever the vocabulary.
    - **The vocabulary is the filter menu's existing sections**, passed down from
      Main rather than re-derived, so there's one source for what the axes are
      called and which user taxonomies qualify.
    - **Sprint sits straight after Status** rather than in taxonomy order — it's
      the field this task existed for.
    - **Task boards only.** These are a task's fields and a project has no sprint,
      so on the Projects and Initiatives boards the menu doesn't open at all
      (`onCardMenu` is undefined there rather than opening an empty menu).
    - **It edits what the board is showing.** The targets come from
      `selectionInBoardOrder(viewColumns, …)` — the group-drag rule — so a card
      filtered out by the text filter or elided by the per-column cap is never
      edited unseen, even if it's still in the selection set.
    - **Refetch after a partial failure**, as in the group move: a bulk edit that
      stopped half way really has changed some cards, and the board has to show
      which.
    - Axis ordering came out as a pure `bulkEditAxes()` with tests, keeping the
      component thin — the `boardSelect.ts` module now holds the whole NOT-536/539
      feature's logic.

    Problems: none in the code. 657 tests pass, full local pre-push gate green
    (cargo jobs included), CI green.

    Not exercised by hand in a running app — the menu wants eyes on a real window.

    Deliberate limits, each an easy follow-up if wanted: **no undo** (a mistaken
    bulk edit is recoverable from git history but not from the UI — whether a
    confirm step above some card count is wanted is still open); due/start date and
    milestone are out (separate write paths plus a date picker); the project link
    is out because moving a task between projects sweeps taxonomies across the
    family (ADR 0027); and the Projects board has no bulk menu.
assignee: steve
label:
- feature
- follow_up
priority: medium
task_status: done
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

- [x] Reuse `KanbanView.moveCard`'s per-note write loop: N writes, each
      `noteWrittenInApp`-marked (NOT-381), one refetch at the end, and the
      refetch still happens after a partial failure (NOT-536).
- [x] Right-clicking an **unselected** card selects it first — the `dragSet`
      rule, so a single-card right-click behaves as expected.
- [x] **Sprint only while the board is scoped to one project** — sprint ids
      are per-project (ADR 0024), the existing `sprintsEnabled` rule. The axis
      is absent rather than disabled, so it never offers ids the cards can't
      hold.
- [x] New `BoardCardMenu.svelte` following `WorkspaceView`'s right-click menu
      (DEV-913) for the backdrop dismissal and the board menus for the
      popover styling. Two pages — axes, then values — rather than hover
      submenus.
- [x] Axis ordering as a pure `bulkEditAxes()` in `boardSelect.ts`, with
      tests (Status, Sprint, then the rest, user taxonomies last; Sprint
      dropped when unscoped).
- [x] Each value list ends with "No &lt;axis&gt;", which clears the field.
- [x] `brief/ui.md` gains the gesture.

Open question, **still open**: no undo. Twenty cards re-sprinted by mistake is
recoverable from git history but not from the UI. Whether a confirm step above
some card count is wanted — or whether undo is its own task — is a planning
call, not something to settle inside this brief.

## Out of scope

- Due/start date and milestone — separate write paths plus a date picker in
  the menu; a later brief if wanted.
- The project link. Moving a task between projects sweeps taxonomies across
  the family (ADR 0027) — too much to do silently to a selection.
- The Projects and Initiatives boards: these are a task's fields and a project
  has no sprint, so the menu doesn't open there. An easy follow-up.
- Shift-click range select and marquee selection (also out of NOT-536).
- Multi-select on the Gantt, Timeline and list views.

Shipped in PR #531 (squash `afb38f4`). Not exercised by hand in a running
app — the menu wants eyes on a real window.
