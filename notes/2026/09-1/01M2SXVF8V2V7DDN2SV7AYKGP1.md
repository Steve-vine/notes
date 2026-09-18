---
id: 01M2SXVF8V2V7DDN2SV7AYKGP1
created: 2026-09-18T09:34:08.667888Z
updated: 2026-09-18T12:28:47.362164Z
type: task
title: Gantt and Timeline "Unscheduled" toggles still draw a text caret
project: 01KY6W9951TW0904DT0GGJVGE7
number: 426
sprint: segj1dz
assignee: steve
label:
- follow_up
priority: low
task_status: active
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