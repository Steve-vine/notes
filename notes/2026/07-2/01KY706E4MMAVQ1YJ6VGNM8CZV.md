---
id: 01KY706E4MMAVQ1YJ6VGNM8CZV
created: 2026-07-23T08:06:43.604267Z
updated: 2026-07-23T11:04:50.709577Z
type: task
title: Extract Main.svelte into shell components (pure refactor)
imported_from: linear
assignee: steve
comments:
- id: 01KY706S276N95R2VFRNP1B509
  author: Steve Vine
  at: 2026-07-23T08:06:54.790739Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/124

    **What was done**
    - Extracted five components from `Main.svelte` (1232 → 721 lines), as pure code motion:
      - `Sidebar.svelte` — chrome host (tab strip, error/io notices, footer with SyncIndicator + import/export/settings); the per-tab body renders via a `children` snippet so Main stays the wiring point.
      - `SearchSection.svelte` (input + results incl. `segments()` highlighting), `BrowseSection.svelte` (axis select + filter + single-axis tree), `KanbanSidebar.svelte` (Projects/Tasks selector) — all fully presentational.
      - `KanbanView.svelte` — owns `loadBoard`/`moveCard`/`addBoardNote`/`reorderColumns` and the board-refresh effect (the `tab === "board"` guard fell away since it only mounts on the Kanban tab); `columns` is a bindable prop so Main's export logic still counts board notes.
    - `BoardSel` type moved to `board.ts`; shared `noteLabel()` helper added to `notes.ts` (was a per-component 3-line `label()`).

    **Decisions made on the fly**
    - All view state (tab, query/results, browse state, boardSel, `tasksExpanded`, `valueFilter`) deliberately stays in Main and flows down as props/bindables — moving ownership now would change tab-switch survival semantics; that happens properly in DEV-764 (workspace store).
    - Sidebar list styles (`.results`/`.folder`/…) are duplicated into each section's scoped styles rather than promoted to globals — temporary by design; DEV-763 replaces this chrome with `CollapsibleSection`.
    - Kept the collapse button's original CSS cascade (`.tabs button` beats `.collapse-btn` on specificity) rather than "fixing" it, to stay pixel-identical.

    **Problems encountered**
    - None. svelte-check 0 errors, vitest 94/94, pre-push gate fully green. Worth a quick manual sweep in review: search/browse/kanban selection, card move/add/column-reorder, pane split/resize, import/export, panel collapse.
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 139
sprint: sa8cznq
---
R2 of the Revamp UI milestone (parent DEV-754). Pure code-motion refactor of `Main.svelte` (1232 lines) with **zero behaviour change**, de-risking everything after it.

* Move search UI → `SearchSection.svelte` (input + results incl. `segments()` highlighting).
* Move browse UI → `BrowseSection.svelte` (still single-axis).
* Move kanban Projects/Tasks selector → `KanbanSidebar.svelte`.
* Move board data loading/mutations (`loadBoard`, `moveCard`, `addBoardNote`, `reorderColumns`) → `KanbanView.svelte` (center).
* Move sidebar chrome/footer (SyncIndicator, import/export/settings buttons, collapse rail) → `Sidebar.svelte`.
* Main keeps state and passes props; reviewable as code motion.

Depends on: DEV-761 (R1).

Checklist:

- [X] Components extracted, Main slimmed
- [X] No visual or behavioural diff (manual pass: search, browse, kanban, panes, import/export)
- [X] Lint/typecheck/tests green

---

Linear DEV-762 · Revamp UI · created 2026-07-02 · done 2026-07-02