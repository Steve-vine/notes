---
id: 01KY70BS07EDBAP5HG0RQPVZWN
created: 2026-07-23T08:09:38.567486Z
updated: 2026-07-23T08:09:38.567486Z
type: task
title: Kanban card redesign + borderless column chrome
task_status: done
assignee: steve
label: brief
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 146
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