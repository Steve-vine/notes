---
id: 01KY70KCSC13VMDP2FYGYZBR4R
created: 2026-07-23T08:13:48.204982Z
updated: 2026-07-23T09:08:57.977248Z
type: task
title: 'Consistent panel gaps: kanban columns + overlay match the browse view'
label: brief
task_status: done
assignee: steve
comments:
- id: 01KY70KJA70ZMEDQB590SFHGH6
  author: Steve Vine
  at: 2026-07-23T08:13:53.863467Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/138

    **What was done**
    - New `--panel-gap: 0.5rem` token in theme.css — the single source for the canvas showing around/between the grey panels.
    - Board: column gap + outer padding drop from 0.85rem to the token (column spacing = split-pane spacing; border margin = Browse's); the in-gap resize handle is token-sized so the whole gap stays grabbable.
    - Kanban note overlay: same canvas border around the grey panel as a Browse note (was flush to the edges).
    - Browse pane padding + split dividers switch from hardcoded 0.5rem/8px to the token — same rendered size, but the four surfaces can't drift again.

    **Problems encountered**
    - None; svelte-check 0/0, vitest 109/109, gate green. Eyeball: an overlaid Kanban note should now be indistinguishable in framing from a Browse note, and the column gaps should read the same as split-pane gaps. The resize gap is a touch narrower (8px, was 13.6px) — if it feels tight to grab, we can widen the invisible hit area without touching the visuals.
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 156
---
The Browse view's look is the reference: grey panels on the dark canvas with a 0.5rem margin to the outer border and 0.5rem gaps between split panes. Align the Kanban view to it:

* Board columns: the gap between columns and the padding to the outside border both become 0.5rem (currently 0.85rem); the gap-resize handle resizes with it.
* The kanban note overlay gains the same 0.5rem canvas border around the grey note panel (currently flush to the edges).
* Introduce a shared `--panel-gap` token in theme.css used by the browse pane padding, the split dividers, the board gap/padding, and the overlay, so the values can't drift apart again.

---

Linear DEV-781 · created 2026-07-02 · done 2026-07-02