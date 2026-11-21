---
id: 01M7YJ3TFDCH6W2P2VJHFFN5PD
created: 2026-11-21T08:03:40.653929Z
updated: 2026-11-21T09:10:38.089171Z
type: task
title: 'Flowchart colour palettes: the Default/Automatic button replaces the selected-colour label, so the two swatch rows sit together'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2050
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve (testing round 4): in the flowchart editor's right-hand panel, each colour palette has a label above it naming the selected colour (e.g. "Primary"). Remove that label completely from every palette, and put the "Default"/"Automatic" button there instead. That button currently sits between the two rows of swatches. Moving it lets the two rows sit directly one above the other.

**Done when**
- No palette in the flowchart editor's right-hand panel shows a selected-colour label (e.g. "Primary") above it. This covers Fill, Border, Text, connection line, lane colours and any other palette there.
- Each palette's "Default" or "Automatic" button sits where the label was, above the swatches, with the same behaviour as now.
- The house-style row and the custom row (COM-2026) sit directly one above the other, with nothing between them.
- The selected swatch is still clearly marked, so the colour in use can still be seen without the label. Each swatch still names its colour on hover/focus for screen readers.
- The panel doesn't get wider, and nothing overflows at the narrowest panel width.
- Tests updated for the new layout.