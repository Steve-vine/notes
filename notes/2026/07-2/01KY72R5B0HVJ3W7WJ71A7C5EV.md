---
id: 01KY72R5B0HVJ3W7WJ71A7C5EV
created: 2026-07-23T08:51:21.568981Z
updated: 2026-07-23T08:51:21.568981Z
type: task
title: 'Taxonomy values: drag-to-reorder replaces ↑/↓ buttons'
assignee: steve
task_status: done
priority: medium
imported_from: linear
project: 01KY6W9951TW0904DT0GGJVGE7
number: 308
---
## Context

Reordering taxonomy values means clicking tiny ↑/↓ ghost buttons one step at a time (`src/lib/TaxonomySettings.svelte:556-557`) — moving a value from the bottom of a long Status list to the top is a click per row. Order matters here: it drives Kanban column order and value-picker order (the value-object `order` field, ADR 0005).

## Change

* Add a drag handle at the left edge of each value row; drag to reorder with an insertion indicator, matching whatever drag affordance conventions the app already has (Kanban cards, timeline bars).
* Reordering only mutates the draft (like today's moveValue) — persisted on Save.
* Remove the ↑/↓ buttons once drag works. Keep keyboard reordering available (e.g. Alt+↑/↓ while a row's input is focused) so the mouse isn't the only path.

## Acceptance

* A value can be dragged from bottom to top of a 10-value list in one gesture, in both themes, without scroll misbehaviour when the list overflows the pane.
* Keyboard reorder works and is discoverable (title/tooltip on the handle).
* Saved order round-trips through `taxonomies.yaml` exactly as today.

---

Linear DEV-961 · Settings Window · created 2026-07-12 · done 2026-07-12