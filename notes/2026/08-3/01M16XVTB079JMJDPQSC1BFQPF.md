---
id: 01M16XVTB079JMJDPQSC1BFQPF
created: 2026-08-29T14:14:18.652347Z
updated: 2026-08-30T15:50:24.569439Z
type: task
title: Table format issue
project: 01KY6W9951TW0904DT0GGJVGE7
number: 408
sprint: segj1dz
comments:
- id: 01M177M1Q68TXTVGGVJPP8P74S
  author: Steve Vine
  at: 2026-08-29T17:03:35.137683Z
  text: |-
    Two separate causes, one per mode — PR #402.

    Read: .markdown's `word-break: break-word` is the legacy alias for `overflow-wrap: anywhere`, which counts towards intrinsic sizing. Inherited into the table it drops every cell's min-content to one character, so auto layout stacks the headings. Measured in WebKit: all four headings wrap to 4 lines at every pane width from 26rem to 46rem, Mode pinned at 31px — it never recovers however much room there is. Fixed by resetting the prose wrapping for the table subtree (as the Live table already does, ADR 0054), sizing the table to its content with a scroll inside the pane, and capping cells at the same 22rem the Live table uses so both modes agree.

    Live: .cm-tbl-in resets overflow-wrap to `normal`, which keeps `anywhere` out of intrinsic sizing but also lets a token wider than the 22rem cap overflow and paint over its neighbour — measured 29px spill on entra_health.check_entra_connection_health. `break-word` breaks only what can't fit and leaves column widths identical.

    Separate gap found while in there: history, stickies and comments render markdown tables with no table styling at all (no borders or padding) and inherit the same collapse. Not touched here — worth its own task if you want it.
assignee: steve
priority: medium
task_status: done
---
Having some table layout issues. Here is the same table in Read and Live view.
*Read*
![CleanShot 2026-08-29 at 15.11.48@2x.png](attachments/2026/08/01M16XVTB079JMJDPQSC1BFQPF/CleanShot-2026-08-29-at-15.11.48@2x.png)
Col 3 is completely squashed

*Live*
![CleanShot 2026-08-29 at 15.13.59@2x.png](attachments/2026/08/01M16XVTB079JMJDPQSC1BFQPF/CleanShot-2026-08-29-at-15.13.59@2x.png)
Col 5 Row 1, text overlaps into the next column