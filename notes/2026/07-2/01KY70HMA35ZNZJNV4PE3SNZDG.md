---
id: 01KY70HMA35ZNZJNV4PE3SNZDG
created: 2026-07-23T08:12:50.371933Z
updated: 2026-07-23T12:24:57.362741Z
type: task
title: Kanban columns invisible against the background
comments:
- id: 01KY70HRRE94NG82YF977CXV5M
  author: Steve Vine
  at: 2026-07-23T08:12:54.926026Z
  text: |-
    Steve Vine · 2026-07-02:

    Done building — PR: https://github.com/Steve-vine/notuvia/pull/134

    **What was done**
    - `.column` gains `background: var(--pane-bg)` — the soft-panel token the note panes use — so columns sit slightly lighter than the canvas in dark mode (slightly darker in light) and both surfaces stay consistent. Gaps, gap-resize, and the drag-over tint unchanged. One declaration + comment.

    **Problems encountered**
    - None; svelte-check 0/0, gate green. Eyeball both themes when you pull it.
assignee: steve
task_status: done
label: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 152
---
Follow-up from DEV-769 (Revamp UI review): the borderless column change left `.column` fully transparent, so columns can't be distinguished from the app canvas. Give them a subtle fill — `var(--pane-bg)`, the same soft-panel token the note panes use (slightly lighter than the canvas in dark mode, slightly darker in light mode), keeping the two surfaces consistent.

---

Linear DEV-776 · created 2026-07-02 · done 2026-07-02