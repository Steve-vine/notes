---
id: 01M7YJ3TFDCH6W2P2VJHFFN5PD
created: 2026-11-21T08:03:40.653929Z
updated: 2026-11-21T10:57:21.987653Z
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
- id: 01M7YW1VJ357X499HT4VZNYW4Z
  author: Steve Vine
  at: 2026-11-21T10:57:21.987391Z
  text: |-
    Failed, minor (pre-UAT recheck, staging d4a5f0b5a, 21 Nov, as E2E Admin A). The layout is right everywhere; one done-when gap.

    Steps: opened the E2E-made draft flowchart "E2E pre-UAT COM-2016 new standalone" ▸ Edit ▸ Edit flowchart. Selected the step "Check request", then a connection, then added a lane and opened "Colours and text of Lane 1". Then Cancel ▸ Leave without keeping, so nothing was saved.

    What passed (all seven palettes: Fill, Border, Line, Text colour, lane Header, Background and Name colour):
    - No words naming the chosen colour above any palette.
    - Default (Automatic for Text colour and Name colour) sits on the palette's title line, right-aligned, greyed while the colour already is the default.
    - The house-style row and the custom row sit directly one above the other.
    - The panel stays 320px wide at a 1440px and a 1024px window. Nothing overflows: the scrolling area's content is exactly its width.
    - Fill and Border on Default have their swatch ticked, and hovering the ticked Fill swatch reads "Light shade (Default)". Line on Default has Primary ticked.

    Gap: on Default or Automatic, some palettes tick no swatch at all
    - Steps: select a step and look at Text colour (Automatic); add a lane and open its colours (Header, Background, Name colour all on Default/Automatic). I tried both the dark and the light canvas background.
    - Expected (done when): "The selected swatch is still clearly marked, so the colour in use can still be seen without the label."
    - Seen: no swatch is ticked in Text colour, lane Header, lane Background or lane Name colour. Nothing on screen now says which colour is in use, only that the greyed Default/Automatic button means "it's the default". The lane header looks like Light shade on the light canvas but isn't ticked.
    - Probably because these defaults aren't one of the swatches (Automatic is worked out from the fill). Steve may be happy with that; if not, a hover on the greyed Default button, or a tick on the nearest house colour, would cover it.

    Screenshots: ~/compass-uat/s9hexqn/COM-2050/ (step-selected-panel.png, step-panel-text-colour.png, ticked-swatch-hover.png, line-palette.png, lane-palettes.png, lane-palettes-light-bg.png, lane-palettes-1024.png)
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