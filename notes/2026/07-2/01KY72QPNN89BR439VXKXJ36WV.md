---
id: 01KY72QPNN89BR439VXKXJ36WV
created: 2026-07-23T08:51:06.549334Z
updated: 2026-07-23T09:17:57.367925Z
type: task
title: 'Taxonomy value rows: redesign the cramped control grid'
label: null
task_status: done
priority: high
assignee: steve
project: 01KY6W9951TW0904DT0GGJVGE7
number: 306
sprint: sf9yevt
---
## Context

A taxonomy value row (`src/lib/TaxonomySettings.svelte:458-594`) packs up to eleven controls into one CSS-grid line: label input, id input, colour toggle (🎨/✕) + a conditional `<input type="color">`, up to four conditional checkboxes (done / hide / default / me), an initials input, ↑, ↓, remove, and a ⋯ menu. The grid (DEV-707) keeps columns aligned but the result doesn't fit comfortably even in a wider panel — inputs shrink to slivers, the flag checkboxes read as noise, and the emoji colour toggle is a two-step dance to set a colour.

This is the core of the "taxonomy settings don't fit and are fiddly" complaint.

## Change

Redesign the row so the common case is calm and the rare controls get out of the way:

* **Always visible per row**: colour swatch, label, id (muted/mono), active flag chips (e.g. small "done", "default", "me" badges only when set), and a single ⋯ actions menu on the right.
* **Colour**: the swatch itself is the button — click opens the native colour input directly; a "no colour" state shows an empty swatch. Kill the 🎨/✕ toggle pair.
* **Flags and initials**: move the conditional checkboxes (done/hide/default/me) and the initials field out of the grid line — either an expandable row detail or into the row's ⋯ menu as toggles. Setting "default"/"me" (single-holder flags) keeps its move-the-flag behaviour.
* Remove moves into the ⋯ menu (alongside rename/merge, which DEV-960 reworks).
* Rows use the app's list-row height/spacing conventions from `theme.css`.

Reordering (currently ↑/↓ buttons) is DEV-961 — leave the buttons in place here if it lands first, or drop them if drag has landed.

## Acceptance

* A Status-scoped taxonomy (the worst case: done + hide + default columns) fits the settings pane with no horizontal squeeze, in both themes.
* Setting a colour is one click + pick; clearing it is available in the same control.
* Every current capability (label edit, id edit for new values, done/hide/default/initials/me, remove) is still reachable, and flag state is visible at a glance when set.

---

Linear DEV-959 · Settings Window · created 2026-07-12 · done 2026-07-12