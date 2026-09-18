---
id: 01M2SXVF8V2V7DDN2SV7AYKGP1
created: 2026-09-18T09:34:08.667888Z
updated: 2026-09-18T12:32:54.742809Z
type: task
title: Gantt and Timeline "Unscheduled" toggles still draw a text caret
project: 01KY6W9951TW0904DT0GGJVGE7
number: 426
sprint: segj1dz
comments:
- id: 01M2T7Y1P8FW78RZCZCPTJB0J7
  author: Steve Vine
  at: 2026-09-18T12:30:18.823575Z
  text: |-
    Built on brief-426-unscheduled-chevron, PR #428.

    What was done — two files, GanttChart.svelte:621 and TimelineChart.svelte:554:
    - The .caret span now holds <Icon name="chevron" size={13} /> and takes class:collapsed={!unschedOpen}. Icon was already imported in both files.
    - .caret CSS becomes display: inline-flex / align-items: center, plus .caret.collapsed :global(svg) { transform: rotate(90deg) }, replacing the font-size: 0.65rem that only existed to shrink the glyph.

    Decisions made on the fly:
    1. Rotation direction. TimelineChart's own tree-row caret-btn rotates -90deg (pointing right when collapsed), but that control expands a tree. The Unscheduled toggle is the section-header idiom, and its "◂" glyph pointed left, so it uses +90deg like CollapsibleSection and the Browse tree. Preserving the direction the glyph had rather than copying the nearest rotate() in the file.
    2. No opacity added to .caret. The .unsched-head button already carries opacity: 0.75; stacking CollapsibleSection's 0.6 on top would have made the chevron noticeably fainter here than the text glyph it replaces.

    Problems encountered: none.

    Checks: npm run check (373 files, 0 errors), npm test (341 passing). No Rust touched. A grep for ▾/◂/▸ across src/ now returns nothing, so the DEV-771 icon pass is finished app-wide.

    Review step: needs eyes on the Planner tab's Gantt and Timeline views with at least one dateless task / undated project, so the Unscheduled section renders.
assignee: steve
label:
- follow_up
priority: low
task_status: review
tech: null
---
Follow-up from NOT-424, which gave the Browse tree's folder rows the shared
`Icon name="chevron"` and finished DEV-771's icon pass for them.

The same raw-glyph outlier survives in two more places:

- `GanttChart.svelte:621` — `{unschedOpen ? "▾" : "◂"}`
- `TimelineChart.svelte:554` — the same

`TimelineChart.svelte:425` (`caret-btn`) already uses the `Icon` chevron a few
lines away in the same file, so this is inconsistency within one component, not
just across them.

Fix the same way NOT-424 did: `<Icon name="chevron" size={13} />` inside a
`<span class="caret" class:collapsed>`, with the `CollapsibleSection.svelte:75-85`
CSS (inline-flex, `width: 1rem`, `opacity: 0.6`, `rotate(90deg)` when
collapsed).