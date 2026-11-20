---
id: 01M7VCCJBVEPQPHKGDWHKTR8VD
created: 2026-11-20T02:25:52.507641Z
updated: 2026-11-20T02:48:02.503589Z
type: task
title: The flowchart canvas takes the house style's colours even when the house style loads late
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2018
sprint: s6y6p7g
comments:
- id: 01M7VDN4GE2H0JFR6Q113XQAAG
  author: Steve Vine
  at: 2026-11-20T02:48:01.806535Z
  text: |-
    Done — PR #2013, merged 85a42994.

    If the house style arrives after a flowchart's canvas has opened (past the 3-second wait), the canvas now switches to the house colours without a reload. So do the Style panel's Default swatches and the picture saved on Done. Until the house style arrives, the canvas and Style both show the same fallback colours. This works the same for standalone flowcharts and a document's own flowchart. A standalone flowchart whose missing picture was saved in the fallback colours is saved again once the house style arrives.

    Assumption: a document's own flowchart that arrives without a picture and is saved in the background (COM-2017) isn't saved again when a late house style arrives. Its canvas, Style and Done are covered by the shared fix.

    To check on staging:
    1. Hold up the house-style requests by 4–5 s, then open a standalone flowchart's canvas. It opens pale blue and turns grey (#e9e9e9 / #212121) when the house style arrives.
    2. Style ticks "Default (Light shade)" and "Default (Primary)" on those colours.
    3. After Done, the Read tab picture is grey.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the round 3 re-check, by Tester A on staging d8749c62, against COM-2016 and COM-2014.

**Steps:** hold up the house-style requests by 4–5 s each, so the stylesheet arrives about 8–11 s after the page loads. Then open a standalone flowchart's canvas with Draw the flowchart, or Edit flowchart on an existing chart.

**Seen:**
- The canvas opens after about 3 s in the fallback colours (#e7f5ff fill, #1971c2 border) and keeps them. 15 s later the stylesheet was on the page, but the shapes were still pale blue.
- Style ticks the grey house swatches (#e9e9e9 / #212121), so COM-2014's mismatch comes back on a slow connection.
- Pressing Done in that state would presumably save the picture in the wrong colours.

Screenshots: ~/compass-uat/s6y6p7g/COM-2016/r3re-08-late-style-15s.png, r3re-09-late-style-panel.png, r3re-11-late-style-existing.png

**Done when**
- When the house style arrives after the canvas has opened, the canvas, the Style panel's default swatches and the picture saved on Done all switch to the house colours without a reload. Before it arrives, the canvas and Style agree on the fallback.
- The picture saved on Done always uses the colours in force when Done is pressed. Done made before the house style arrives saves pictures that the next Done corrects.
- The same applies to a document's own flowchart if its house style can arrive late.
- Tests cover a house style arriving after the 3 s limit, with the canvas, Style and the saved picture all switching.

Independent: frontend only.