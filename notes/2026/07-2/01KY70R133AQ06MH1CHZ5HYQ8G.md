---
id: 01KY70R133AQ06MH1CHZ5HYQ8G
created: 2026-07-23T08:16:20.067897Z
updated: 2026-07-23T08:16:25.265571Z
type: task
title: New note window
imported_from: linear
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 166
comments:
- id: 01KY70R65HA67ZRQZD6GAMV5H9
  author: Steve Vine
  at: 2026-07-23T08:16:25.265205Z
  text: |-
    Steve Vine · 2026-07-04:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/148

    **What was done:** `TaxonomyEditor.svelte`'s fixed-position popovers now flip upward when their trigger sits in the lower half of the window (`place()` replaces the always-down `below()`). In the capture window the taxonomy section is at the bottom, so its suggestion box — and the strict value list and add-taxonomy picker — all open upward now.

    **Decisions on the fly:** Went with an automatic half-window flip rather than an `up` prop wired from Capture (like MetaTaxonomyPicker's DEV-542 `up` flag): the same clipping could happen for low rows in the Properties panel, and the flip fixes both without callers needing to know. The popovers' 50vh max-height guarantees they fit whichever side they open on.

    **Problems:** None. `npm run check` and `npm test` green. Worth a manual check in the capture window during review (no screenshots from this machine).
---
In the new note window, the taxonomies are at the bottom of the window, but the suggestions box lists downwards meaning it goes off the bottom of the screen, it should go upwards.

## Agreed work

* The suggestion/value/add-taxonomy popovers in `TaxonomyEditor.svelte` are `position: fixed` and always placed *below* their trigger (DEV-543). Replace the `below()` helper with a `place()` helper that opens **upwards when the trigger sits in the lower half of the window**, downwards otherwise.
* This fixes the capture window (taxonomy section at the bottom → all its popovers open up) and also stops low rows in the Properties panel clipping at the window edge; rows in the upper half keep today's downward behaviour.
* Applies to all three popovers in the editor: tag suggestions, the strict value list, and the add-taxonomy picker.
* Checks: `npm run check`, `npm test`.

---

Linear DEV-805 · Left Panel Improvements · created 2026-07-04 · done 2026-07-04