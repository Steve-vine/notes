---
id: 01M4QNPQ7Z2KDWPZ12QXWD8A3M
created: 2026-10-12T09:04:39.167231Z
updated: 2026-10-12T09:17:45.980047Z
type: task
title: Add ability to select multiple cards in Kanban view
project: 01KY6W9951TW0904DT0GGJVGE7
number: 536
sprint: sd52non
assignee: steve
label:
- brief
priority: medium
task_status: active
tech:
- svelte
---
Allow the user to select multiple cards by holding down CMD on MAC so that they can be moved across columns in one go.

## Agreed work

Frontend only — the per-note writes (`set_status`, `set_card_position`,
`set_card_order`) already exist, so a multi-card move is a loop over them
with a single refetch. Cmd **or** Ctrl is the additive modifier, matching the
sidebar's existing multi-pick idiom (`KanbanSidebar`, `ProjectSection`,
`InitiativeSection`) and so Windows/Linux get it for free.

### Selection (`Main.svelte`)

- [ ] `boardSelectedCardIds: Set<string>` beside `boardSelectedCardId` — the
      card selection, of which `boardSelectedCardId` stays the *primary* (the
      one the right panel shows). One helper sets both, so every existing
      clear point (board scope change, overlay restore, tab/view swap, note
      delete) clears the multi-selection too.
- [ ] `selectCard(id, additive)`: a plain click selects one card; Cmd/Ctrl
      toggles the card in the set. Removing the primary promotes another
      member; emptying the set clears the selection. Existing one-argument
      callers (Gantt, Timeline, Search) are unaffected.

### Board (`KanbanBoard.svelte`, `KanbanView.svelte`)

- [ ] `selectedIds` prop threaded down; every member draws the selected ring.
- [ ] Card click passes `e.metaKey || e.ctrlKey`. Arrow-key navigation
      (NOT-370) resets to a single selection. Double-click still opens one.
- [ ] Drag state carries **ids** rather than one id: dragging a selected card
      drags the whole selection (in board visual order, so relative order is
      kept); dragging an unselected card resets the selection to it first, as
      today. Every dragged card fades.
- [ ] `onMove` takes a list of `{ id, order }` moves plus the target column,
      so the board keeps owning the drop-key maths and the view just writes
      them. `KanbanView.moveCard` loops the writes, marks each note
      self-written (NOT-381), then refetches once — including after a failure,
      so a partial move never leaves the board lying.
- [ ] Cross-column drop in a sorted mode: cards already in the target column
      are skipped, the rest restatus (null order, manual keys untouched).
- [ ] Manual mode: N cards land contiguously at the insertion line. The
      fractional-key helper generalises from one key to N evenly spaced ones
      between the neighbours; the keyless-prelude path (DEV-820) keys the
      cards above the slot then slots the dragged run after them.

### Tests + docs

- [ ] Extract the selection toggle, the visual-order collapse and the drop-key
      maths into `src/lib/boardSelect.ts` (the `boardNav.ts` pattern) with
      vitest coverage: toggle/promote/empty, multi-column ordering, N keys
      between two neighbours, the open-ended and prelude cases.
- [ ] `brief/ui.md`: a line on Cmd/Ctrl-click multi-select and the group drag.

Out of scope: Shift-click range select, a marquee, multi-select on the Gantt /
Timeline / list views, and bulk edits other than the column move.
