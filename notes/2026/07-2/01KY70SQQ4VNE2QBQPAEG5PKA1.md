---
id: 01KY70SQQ4VNE2QBQPAEG5PKA1
created: 2026-07-23T08:17:16.00467Z
updated: 2026-07-23T08:22:32.934096Z
type: task
title: Pointer Icons
imported_from: linear
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 169
comments:
- id: 01KY70SVTZFA3QB9TEPJSDV4NX
  author: Steve Vine
  at: 2026-07-23T08:17:20.223229Z
  text: |-
    Steve Vine · 2026-07-04:

    Done as agreed — CSS-only change in `KanbanBoard.svelte`: `.card` cursor is now `default` (arrow at rest), with `cursor: grabbing` on `.card.dragging`.

    **Decision made on the fly:** none of substance. One caveat worth knowing for review: during a native HTML5 drag the OS/WebKit largely controls the cursor, so the "hand while dragging" is best effort — the reliably fixed part is that hovering a card no longer shows a hand.

    **Problems encountered:** none. Full gate green (rust fmt/clippy/tests, frontend check/test/build).

    PR: https://github.com/Steve-vine/notuvia/pull/150
label: null
---
When moving the pointer over a card, it changes from an arrow to a hand.  It should stay as an arrow until dragging starts, then change to a hand.

## Agreed work (planned 2026-07-04)

* `KanbanBoard.svelte` CSS: `.card` cursor changes from `grab` to `default` (arrow at rest); `.card.dragging` gets `cursor: grabbing`.
* Note: during a native HTML5 drag the platform largely controls the cursor, so the "hand while dragging" is best effort; the key ask (no hand until dragging starts) is fully met.

---

Linear DEV-811 · Kanban board Improvements · created 2026-07-04 · done 2026-07-04