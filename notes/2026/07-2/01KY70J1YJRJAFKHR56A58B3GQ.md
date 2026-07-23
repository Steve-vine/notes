---
id: 01KY70J1YJRJAFKHR56A58B3GQ
created: 2026-07-23T08:13:04.338413Z
updated: 2026-07-23T12:24:57.319195Z
type: task
title: Resizable left and right side panels
assignee: steve
task_status: done
comments:
- id: 01KY70J8HY0FPFDVVW1KW84A4R
  author: Steve Vine
  at: 2026-07-23T08:13:11.101837Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/135

    **What was done**
    - The app grid gains two zero-width divider tracks at the sidebar/main and main/properties boundaries, each hosting a drag handle whose hit zone straddles the boundary (the existing 1px panel border is the visual affordance).
    - Drag resizes with pointer capture, clamped 180–480px; double-click resets to 248px; ←/→ nudges 16px when the separator is focused. Same interaction language as the pane dividers — nothing on hover, faint accent while dragging/focused.
    - Widths persist as `notuvia:leftWidth`/`notuvia:rightWidth`, global across workspace tabs (the ADR 0021 split, same as the collapse flags). Collapse-to-rail unchanged; a collapsed side's handle is inert.

    **Decisions made on the fly**
    - Zero-width grid tracks rather than visible gutters — the layout stays exactly as designed (panels meeting main on a 1px border), with the grab zone extending ±3px over it.
    - The right panel's drag delta flips (grows as the pointer moves left) so both handles feel natural.
    - Clamp ceiling 480px (roughly double the default) — enough for long taxonomy trees without letting a panel eat the note view.

    **Problems encountered**
    - None. svelte-check 0/0, vitest 109/109, gate green. Manual pass: drag both sides to the clamps, double-click reset, keyboard nudge, restart persistence, collapse/expand keeping the width. No overlap with PR #134 — merge in either order.
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 153
---
The sidebar and Properties panel are fixed at 248px (Main's grid). Make both drag-resizable:

* Drag the boundary between a panel and the main area (same interaction language as the pane dividers: gap/boundary is the drag zone, no hover highlight, faint accent while dragging; double-click resets to the 248px default; arrow keys nudge when focused).
* Widths clamped (~180–480px) and persisted per-machine (`notuvia:leftWidth` / `notuvia:rightWidth`), global across workspace tabs like the collapse flags (ADR 0021).
* Collapse-to-rail behaviour unchanged; the collapsed rail isn't resizable.

---

Linear DEV-777 · created 2026-07-02 · done 2026-07-02