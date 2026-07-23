---
id: 01KY70BS07EDBAP5HG0RQPVZWN
created: 2026-07-23T08:09:38.567486Z
updated: 2026-07-23T11:00:28.557381Z
type: task
title: Kanban card redesign + borderless column chrome
task_status: done
assignee: steve
imported_from: null
comments:
- id: 01KY70CW0PTNANWGWCYE5BK9QV
  author: Steve Vine
  at: 2026-07-23T08:10:14.42174Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/131

    **What was done**
    - Card property row: priority letter chip (label's first letter — L/M/H/C — coloured from the pool, tooltip carries the full label) + dormant blocked/blocking icons (new `Icon.svelte` glyphs; optional TS-only `BoardCard` fields, rendered only when set) ahead of the generic taxonomy chips.
    - Card dates row: `C: <created>` left / `D: <due>` right; date-only `due` parsed as local Y-M-D to avoid the UTC day-shift.
    - Rust: `priority`/`priority_label`/`priority_colour` resolved onto `BoardCard` in `task_board()` (the previously-discarded value); `card_chips()` skips priority (no double render); projects carry `None`.
    - Columns: borderless bare regions on gaps; drag-over indicator is now a background tint; the resize handle sits in the inter-column gap with the hover gradient removed; the add button is a full-width `+` bar pinned at the column bottom, composer opening in its place.

    **Decisions made on the fly**
    - The priority letter chip is a first-class card property, independent of the `show_on_cards` flag — the flag still governs generic chips (the rewritten test exercises it via `assignee` both ways). If you want the flag to hide the letter chip too, that's a one-line change to discuss.
    - The composer moved to the column **bottom** with the add bar (it was top) — new cards appear where you invoked them.
    - Local Y-M-D parsing for `due` — `new Date("2026-07-31")` is UTC midnight and renders as July 30 in UTC-negative timezones.

    **Problems encountered**
    - The gate caught a clippy `cloned_ref_to_slice_refs` lint in the rewritten test on first push; fixed with `std::slice::from_ref`. Otherwise clean: cargo 149/149, svelte-check 0/0, vitest 109/109. Visual review pass: priority letters against your pool, gap resize (no highlight), drag-over tint, bottom `+`/composer, dates row, and column-reorder indicator legibility without borders.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 146
sprint: sa8cznq
---
R9 of the Revamp UI milestone (parent DEV-754). Cleaner cards and columns per the DEV-754 mockup.

* Card layout: display-id / avatar top row; title; property-icon row — **priority letter chip** (letter derived from the priority value's label first character, since labels are user-editable: L/M/H/C…), dormant **blocked**/**blocking** icons (new `Icon.svelte` glyphs; optional TS-only `blocked?/blocking?` fields on BoardCard, rendered only when set — data & behaviour are an explicit follow-up), taxonomy chips; bottom row `C: <created>` left / `D: <due>` right.
* Rust: `priority`/`priority_label`/`priority_colour` on `BoardCard` (the task board already fetches the value and discards it at `runtime.rs:1129`); skip priority in `card_chips()` to avoid double-render.
* Column chrome: no borders, faint/transparent background, columns separated by gaps; drag-over indicator becomes a background tint; resize handle moves **into the inter-column gap** with the hover gradient removed (no highlight); add-card "+"/composer moves to the column bottom.

Depends on: DEV-767 (R7, due on cards). Parallelizable with DEV-768 (R8).

Checklist:

- [ ] New card layout incl. priority chip + due date
- [ ] Dormant blocked/blocking icons (no dead UI when unset)
- [ ] Borderless columns, gap resize without highlight
- [ ] "+" at column bottom

---

Linear DEV-769 · Revamp UI · created 2026-07-02 · done 2026-07-02