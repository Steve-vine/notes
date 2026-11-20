---
id: 01M7VEXVWK902CPNJK5GHA2XRG
created: 2026-11-20T03:10:16.467756Z
updated: 2026-11-20T03:10:20.15257Z
type: task
title: A document's flowchart picture saved in the background uses the house style's colours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2019
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in the final re-check of round 3, on staging 85a42994, against COM-2018 and COM-2017.

**Steps:** add a flowchart to a document through Polaris (or another route that arrives without a picture: import, Turn into a flowchart). Open the document's Edit tab on a normal connection. Publish and export the PDF.

**Seen:**
- The Edit tab saves the missing picture about 0.6 s after the page opens, before the house-style list (0.86 s) and stylesheet (0.93 s) have loaded.
- The pictures come out pale blue (#e7f5ff / #1971c2), the PDF prints them blue, and they are never saved again.
- Opening the chart on the canvas shows grey (#e9e9e9 / #212121), and Done saves grey.
- This happens on every normal load, not only on a slow connection. COM-2018's builder had assumed this background save needn't be redone.

Evidence: ~/compass-uat/s6y6p7g/COM-2017/r3fin-10-polaris-pdf-p2.png, r3fin-11, r3fin-12. Test document "E2E pre-UAT COM-2017 no picture yet".

**Done when**
- A document's own flowchart that arrives without a picture is saved in the house colours, the same as the canvas and Done. Either the background save waits for the house style (with the same limit as the canvas), or a picture saved before the house style arrived is saved again, once, when it does.
- Pictures already saved this way in the wrong colours are corrected the next time the document's Edit tab opens, without anyone pressing Done.
- The PDF, Word and Read tab then show the house colours.
- Tests cover a picture saved in the background with the house style arriving after it, and the picture ending in the house colours.

Independent: frontend only.