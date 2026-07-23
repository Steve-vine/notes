---
id: 01KY72QY6Q86V4E1H3TPKMNNTH
created: 2026-07-23T08:51:14.263872Z
updated: 2026-07-23T09:08:58.788872Z
type: task
title: 'Taxonomy values: clearer rename & merge flow'
label: null
assignee: steve
priority: medium
task_status: done
project: 01KY6W9951TW0904DT0GGJVGE7
number: 307
---
## Context

Renaming a taxonomy value id swaps the whole row into an inline rename mode (`src/lib/TaxonomySettings.svelte:460-481`): the old label goes dim, an unlabelled input appears, and confirm/cancel are two unlabelled icon squares. Merging is a flat list of "Merge into X" items in the ⋯ popover with no confirmation, even though both operations rewrite notes on disk immediately — a materially different weight from the other in-row edits, which are draft-only until Save.

## Change

Give rename and merge a small dedicated dialog (in-panel, matching the app's confirm patterns) instead of the inline row swap:

* **Rename…** opens a dialog: current id shown, new-id field, one line explaining "rewrites every note using this value now", confirm/cancel.
* **Merge into…** opens a dialog with a target-value picker (searchable if the value list is long), the same rewrite warning, and an explicit count if cheap to obtain ("affects N notes").
* Both stay in the row's ⋯ menu as entry points. On success, keep the current behaviour of reloading and reopening the editor so the changed state is visible.
* Errors surface in the dialog, not the pane-level error strip.

## Acceptance

* Rename and merge each take one clearly-labelled confirmation before touching notes; cancelling changes nothing.
* No more inline row-swap rename mode.
* A merge cannot silently target the wrong value — the target is explicitly picked and named in the confirm step.

---

Linear DEV-960 · Settings Window · created 2026-07-12 · done 2026-07-12