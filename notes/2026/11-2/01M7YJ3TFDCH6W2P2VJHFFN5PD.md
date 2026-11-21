---
id: 01M7YJ3TFDCH6W2P2VJHFFN5PD
created: 2026-11-21T08:03:40.653929Z
updated: 2026-11-21T09:26:46.13328Z
type: task
title: 'Flowchart colour palettes: the Default/Automatic button replaces the selected-colour label, so the two swatch rows sit together'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2050
sprint: s9hexqn
comments:
- id: 01M7YPVSH410QNCW4PQVXSZKEP
  author: Steve Vine
  at: 2026-11-21T09:26:40.420592Z
  text: |-
    Done and merged to main (PR #2047). This is a screen change only, with no migration. Built by the Evidence Improvements session at Steve's request; it goes to staging with that sprint's next deploy.

    What changes, across all seven palettes (Fill, Border, Line, Text colour, and a lane's Header, Background and Name colour):
    - The words above each palette naming the chosen colour ("Default (Primary)", "Mixed", "Accent"…) are gone.
    - The Default button (Automatic for text colours) now sits on that line, right-aligned beside the palette's name. It works as before: it puts the colour back to the house style's, and is greyed out while the colour already is the default.
    - The house-style row and the custom-colour row now sit directly one above the other. Each palette is shorter (74px instead of 97px).
    - The chosen swatch keeps its tick. When a colour is on Default, hovering its ticked swatch reads e.g. "Primary (Default)". Every swatch still names its colour for screen readers and on hover.

    Checked in headless Chromium at the panel's 320px width, light and dark: no wider, and nothing overflows.

    Calls for you to overturn:
    - When a selection has mixed colours, nothing says "Mixed" any more. No swatch is ticked and Default can be clicked, which is how you can tell.
    - The ticked swatch's "Primary (Default)" hover text is new. It replaces what the removed words used to tell you.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve (testing round 4): in the flowchart editor's right-hand panel, each colour palette has a label above it naming the selected colour (e.g. "Primary"). Remove that label completely from every palette, and put the "Default"/"Automatic" button there instead. That button currently sits between the two rows of swatches. Moving it lets the two rows sit directly one above the other.

**Done when**
- No palette in the flowchart editor's right-hand panel shows a selected-colour label (e.g. "Primary") above it. This covers Fill, Border, Text, connection line, lane colours and any other palette there.
- Each palette's "Default" or "Automatic" button sits where the label was, above the swatches, with the same behaviour as now.
- The house-style row and the custom row (COM-2026) sit directly one above the other, with nothing between them.
- The selected swatch is still clearly marked, so the colour in use can still be seen without the label. Each swatch still names its colour on hover/focus for screen readers.
- The panel doesn't get wider, and nothing overflows at the narrowest panel width.
- Tests updated for the new layout.