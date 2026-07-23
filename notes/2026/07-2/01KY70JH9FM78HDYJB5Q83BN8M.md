---
id: 01KY70JH9FM78HDYJB5Q83BN8M
created: 2026-07-23T08:13:20.047636Z
updated: 2026-07-23T11:00:29.587817Z
type: task
title: Move panel minimise buttons to the bottom corners
comments:
- id: 01KY70JPE4DNFYWQG1SF03W46Q
  author: Steve Vine
  at: 2026-07-23T08:13:25.316484Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/136

    **What was done**
    - Sidebar footer: collapse chevron first (bottom-left corner), sync indicator beside it, import/folder/export/settings pushed to the right edge.
    - Properties panel: collapse button moved from the header to a pinned bottom-right footer; the title + sections now scroll in a body wrapper so the button stays in the corner on long notes (previously the whole panel scrolled).
    - Collapsed rails: expand buttons anchored to the bottom — the toggle stays in the corner it was clicked in across both states.

    **Decisions made on the fly**
    - Anchoring the rail expand buttons at the bottom wasn't in the ask, but without it the control would jump from bottom corner (expanded) to top corner (collapsed) on every toggle. Trivial to revert if you prefer them at the top.
    - The properties header row is gone entirely — the title renders at the top of the scrolling body only when a note is selected, so no empty header gap.

    **Problems encountered**
    - None; svelte-check 0/0, vitest 109/109, gate green. Eyeball: corner toggles staying under the pointer, footer layout at the 180px sidebar clamp, pinned properties footer with a long note.
task_status: done
assignee: steve
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 154
label: null
---
The two panel collapse ("minimise") buttons move to the window's bottom corners:

* Left: the sidebar collapse chevron goes to the far bottom-left of the sidebar footer; the sync indicator shifts right to make room.
* Right: the Properties panel's collapse button moves from the panel header to the bottom-right corner (panel gains a pinned footer; sections scroll in a body wrapper).
* The collapsed rails' expand buttons anchor to the bottom too, so the toggle stays in the same corner in both states.

---

Linear DEV-779 · created 2026-07-02 · done 2026-07-02