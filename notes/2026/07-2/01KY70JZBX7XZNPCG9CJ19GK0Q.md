---
id: 01KY70JZBX7XZNPCG9CJ19GK0Q
created: 2026-07-23T08:13:34.461115Z
updated: 2026-07-23T08:13:39.123389Z
type: task
title: Kanban note close button on the view-tabs row
assignee: steve
task_status: done
imported_from: linear
label: brief
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 155
comments:
- id: 01KY70K3XKTDFM9AGE8C0MHNT2
  author: Steve Vine
  at: 2026-07-23T08:13:39.122904Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/137

    **What was done**
    - `ViewTabs.svelte`: optional `actions` snippet at the strip's right end — a reusable slot for contextual controls on that row.
    - Main: the overlay's X renders there while a card is open over the board (kanban mode only); the overlay's own slim top bar is gone so the note starts flush at the top; Esc behaviour unchanged. The button restyles as a ghost icon button to match the strip.

    **Decisions made on the fly**
    - Kept the X mode-scoped (kanban + overlay open) so Browse/Dashboard never show a stray close button; switching view tabs while overlaid still closes the overlay via the existing clearing effect.

    **Problems encountered**
    - None; svelte-check 0/0, vitest 109/109, gate green. No overlap with PR #136 — merge in either order.
---
The X that closes a kanban card opened over the board (DEV-770) currently sits in its own slim bar above the note. Move it onto the same level as the Dashboard/Browse/Kanban tab bar, at the far right:

* `ViewTabs.svelte` gains an optional `actions` snippet rendered at the right end of the strip.
* Main passes the X there while the overlay is open; the overlay's own top bar goes away (the note starts at the top of the layer).
* Esc behaviour unchanged.

---

Linear DEV-780 · created 2026-07-02 · done 2026-07-02