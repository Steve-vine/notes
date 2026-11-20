---
id: 01M7WMCNVWZG168Q8PHGFJ9454
created: 2026-11-20T14:04:59.132767Z
updated: 2026-11-20T17:19:38.799221Z
type: task
title: On the Edit tab a flowchart scrolls under the section's toolbar, not over it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2022
sprint: s6y6p7g
comments:
- id: 01M7WSE4J1PMXS7Y05A6N8HGNK
  author: Steve Vine
  at: 2026-11-20T15:33:09.825669Z
  text: |-
    Done — PR #2021, merged 0b2f5497.
    On the Edit tab, scrolling now takes a flowchart under the section's toolbar, the same as pictures, diagrams and tables. That applies to a document's own flowchart and to a standalone one added to the document.
    It holds with "Show as on paper" on or off, and while the flowchart is selected: its frame, corner handle and buttons go under the toolbar too.
    The right-hand settings panel and full screen still show above everything.
    Cause: the editor's built-in styles put the flowchart's frame one level above the toolbar. Pictures are built differently, so the rule never touched them. The toolbar now sits above everything in the document.
    Checked in a real browser before and after. Before, the flowchart covered the toolbar; after, the toolbar stays on top for a picture, a document's own flowchart and a standalone one.
    To check on staging: a long document with a flowchart. On the Edit tab, scroll so the flowchart passes the section toolbar, with "Show as on paper" on and off, and once with the flowchart selected.
- id: 01M7WZH3SF23JTKJY1GECAPCC2
  author: Steve Vine
  at: 2026-11-20T17:19:38.799037Z
  text: |-
    Pre-UAT on staging b65d7ed8 — Passed

    Document: "E2E pre-UAT COM-2023 Procedure document (A4-Policy-External style)". It's a long single section with its own flowchart, a standalone flowchart (the COM-2024 one) and a text diagram as the control. I tested as E2E Admin A in headless Chromium. In each case I scrolled the flowchart so it overlapped the section toolbar, then checked what is on top at that point.

    - A flowchart passes under the section toolbar, like pictures and diagrams: Passed. The document's own flowchart and the standalone flowchart were both under the toolbar where they overlapped it, the same as the text diagram. The toolbar stays stuck at the top of the window.
    - "Show as on paper" on and off, and while selected: Passed. The same held with paper on and with paper off. With each flowchart selected (blue frame and corner handle showing), the frame went under the toolbar. I also scrolled the corner handle itself into the toolbar band, and the toolbar was on top there too.
    - Full screen and the right-hand settings panel still show above everything: Passed. The Flowchart settings panel (own: Edit flowchart / alignment / caption / alt text; standalone: Edit flowchart / Version / alignment) floats over the right end of the toolbar and is on top. Full screen (own and standalone) covers the whole window, toolbar included.
    - Tests: Passed. toolbarOnTop.test.ts checks that the toolbar stays above the content's divs and below the settings panel.
    - Observation: on the Edit tab the flowchart's own Zoom / Full screen / Download buttons sit under the picture, so you can neither see nor click them. I opened full screen by script for the last check. It looks like it was this way before this task (the Read tab is fine).
    Screenshots: ~/compass-uat/s6y6p7g/COM-2022/ (r4-paper-on/off-*, r4-full-screen-*)
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve (testing round 3): on the Content Edit tab, each section's toolbar stays fixed at the top so it's always visible while scrolling. When the page scrolls down, flowcharts pass over the top of the toolbar. Nothing else does this, only flowcharts.

**Done when**
- Scrolling the Edit tab, a flowchart passes under the section's toolbar, the same as pictures, diagrams and tables. This applies to a document's own flowchart and to a standalone flowchart added to the document.
- The same holds with "Show as on paper" on and off, and while the flowchart is selected (its frame, resize corner and buttons go under the toolbar too).
- Full screen and the right-hand settings panel still show above everything, as they do now.
- Tests check that the toolbar stays on top of a flowchart.