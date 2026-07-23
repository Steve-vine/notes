---
id: 01KY70D9M9D6XFF6DWY97SMTF2
created: 2026-07-23T08:10:28.36125Z
updated: 2026-07-23T08:10:36.762955Z
type: task
title: Kanban card selection + open-as-overlay
imported_from: linear
assignee: steve
task_status: done
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 147
comments:
- id: 01KY70DHTTEGWEYM59P1HQC0MJ
  author: Steve Vine
  at: 2026-07-23T08:10:36.762544Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/132

    **What was done**
    - `KanbanBoard`/`KanbanView`: `onOpenNote` split into `onSelect` (click) + `onOpen` (dblclick/Enter/Space); new `selectedId` prop paints the selected card's accent border.
    - Main: `boardSelectedCardId` + `boardOverlayNoteId`/`boardOverlayMode`, cleared on tab/view/board-selection changes; the right panel resolves overlay ?? selected card ?? single scoped project; the overlay renders over the still-mounted board with a slim X bar + one `NotePane` (own read/live/source mode); Esc leaves edit first, then closes; `openFromBoard` and the mode switch are gone.
    - `NotePane`: `onSplit`/`onClose` optional — split buttons hidden in the overlay; overlay delete closes + clears selection.

    **Decisions made on the fly**
    - The X sits in a slim bar above the pane rather than floating over it — a floating X would overlap the pane's status-bar timestamp.
    - Esc semantics: first Esc drops the overlay's editor to Read (matching pane behaviour), second closes the overlay.
    - Opening a child task from an overlaid project note navigates **within the overlay** (and re-selects that card) instead of jumping to Browse.
    - Drive-by: removed a stray NUL byte in `KanbanBoard.svelte`'s `" none"` column sentinel (predates the milestone) — git was treating the file as binary, hiding all its diffs. That's why PR #131's diff showed `Bin` for this file.

    **Problems encountered**
    - None. svelte-check 0/0, vitest 109/109, gate green. Review pass: select → panel edit; dblclick overlay; edit status in the overlay and watch the board column change underneath; drag without spurious opens; Esc/X close; overlay clearing on tab/view/selection changes.
---
R10 of the Revamp UI milestone (parent DEV-754). Single click selects a card; double click opens it over the board.

* `KanbanBoard` gains `onSelect(id)` (click → `boardSelectedCardId`, properties shown in the right panel) and `onOpen(id)` (dblclick → overlay). Click-before-dblclick is harmless since select is idempotent; dragstart already suppresses click.
* Overlay: board stays mounted; absolutely-positioned layer over the center cell renders one `NotePane` (`active`, own read/live/source mode) with an "X" close button top-left; Escape also closes. Overlay edits refresh the board via the existing `noteRev` → `loadBoard` effect.
* `NotePane` split/close props become optional (hidden in the overlay).
* Deletes `openFromBoard` / `lastNoteViewTab`; selection cleared on board-selection or view change.

Depends on: DEV-768 (R8), DEV-769 (R9).

Checklist:

- [ ] Click select → right panel shows card properties
- [ ] Dblclick overlay with X + Escape close, board state intact underneath
- [ ] No more mode-switch when opening from the board

---

Linear DEV-770 · Revamp UI · created 2026-07-02 · done 2026-07-02