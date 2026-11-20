---
id: 01M7V3VY1EWTJVY0AKT3SX9CXZ
created: 2026-11-19T23:56:58.798959Z
updated: 2026-11-20T14:05:05.273491Z
type: task
title: A connection fixed to certain points no longer crashes the flowchart for good
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2012
sprint: s6y6p7g
comments:
- id: 01M7V67PNNQACRGAQD6J09MFXX
  author: Steve Vine
  at: 2026-11-20T00:38:21.62177Z
  text: |-
    Done — PR #2004, merged cc845818.
    A connection fixed on a point that isn't at a whole pixel (Data's bottom a sixth of the way along, or a draw.io line's exit point) no longer sends the line-drawing into an endless loop. Flowcharts that crashed now open and draw on the Read and Edit tabs as saved, with no re-save needed.
    Drawing lines now always finishes. And if a line ever can't be routed, every line is drawn as a plain square-cornered line and the page still shows: one bad line can't take down the Read or Edit tab.
    Tested on the saved chart that crashed (it fails before the fix and draws in under a second after), on a fixed point on every side of every shape in each line style, and on lines saved to a tenth of a pixel as the server keeps them.
    The server doesn't route lines: the PDF and Word copies use the picture the canvas drew, so they follow.
    To check on staging: open "E2E pre-UAT COM-1992 crash isolate e1" and "E2E pre-UAT COM-1996 crash isolate manual input". Both tabs should show the chart. Then set a Manual input's "Arrives at: Top side, Middle" and press Done.
- id: 01M7VCA3BR3QGPMVJ29833JT5M
  author: Steve Vine
  at: 2026-11-20T02:24:31.608267Z
  text: |-
    Pre-UAT on staging d8749c62 — Passed
    - Routing never loops; every stretch is straight; the walk always ends, for every shape, side, point and route style: Passed. As E2E Admin A, on a Process-type standalone flowchart, I fixed a connection's end in turn on every side and every point of Manual input, Preparation, Delay, Decision, Manual task, Hand-off, Connector and Documents. I did both the arriving end and the leaving end: 224 combinations. I also tried every side and point of a Data cylinder's leaving end, and Right-angled, Straight and Curved routes on the original crashing connection. None crashed. Every right-angled line was made only of straight pieces across and down, never a diagonal (r3re-08-*, r3re-14).
    - A saved flowchart that can't be routed still opens, falling back to a plain line: Couldn't check in the browser. I found no line that fails to route, so I couldn't make the fallback happen. The PR adds tests that force a routing failure and check the page still draws ("draws every line plain when routing throws, rather than crash the page").
    - The two crashing drafts open and draw correctly with no re-save: Passed. "E2E pre-UAT COM-1996 crash isolate manual input" and "E2E pre-UAT COM-1992 crash isolate e1" both show the chart on the Read tab, the Edit tab and the canvas, before anything was saved (r3re-01 to r3re-04). The console showed no errors.
    - The steps that caused the crash: Passed. On e1, Data's bottom 17% point already led to the Manual input's "Arrives at: Top side, Middle". I changed it to 17%, set it back to Middle and pressed Done. Then I checked the Read tab, a reload, and the Edit tab and canvas again: no crash (r3re-06, r3re-07, r3re-09).
    - draw.io import of a Step joined to a Manual input's top middle: Passed. I imported r3-step-to-manualinput.drawio into a new flowchart, "E2E pre-UAT COM-2012 drawio manual input". The preview drew it, then Import and Done. The Read tab, a reload and reopening the canvas all work, and the connection keeps "Bottom side, 17%" → "Top side, Middle" (r3re-10 to r3re-13).
    - Server picture, PDF and Word: Passed. The PDF of e1, made fresh after Done, draws the Data → Manual input line from the fixed points (r3re-e1.pdf, r3re-e1-pdf-p2.png).
    - Tests: Passed. routeEnds.test.ts covers the saved crashing chart, every point on every side of each shape, lines kept to a tenth of a pixel, and the plain-line fallback.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2012/r3re-*
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, against COM-1996 and COM-1992.

**Steps:**
- Connect Data's bottom point to a Manual input.
- In the connection's panel, set "Arrives at: Top side, Middle".
- Press Done.
A draw.io import of a Step joined to a Manual input's top middle does the same.

**Seen:**
- "This part of the page couldn't be shown".
- From then on, the Read and Edit tabs crash on every visit. The flowchart can't be opened, fixed or deleted from its own page, only from the Content list.
- Console: `RangeError: Map maximum size exceeded` in route.ts `claim()`. A route stretch that isn't straight makes the walk step diagonally, and it never reaches its end.

Evidence:
- ~/compass-uat/s6y6p7g/COM-1996/r3-25-after-done-manual-input.png
- ~/compass-uat/s6y6p7g/COM-1996/r3-crash-console.log
- the crashing flowchart's saved data: ~/compass-uat/s6y6p7g/COM-1992/r3-crash-chart.json
- crashing drafts on staging: "E2E pre-UAT COM-1992 crash isolate e1" and "E2E pre-UAT COM-1996 crash isolate manual input".

**Done when**
- Routing never loops. Every route stretch is straight or is broken into straight pieces, and the walk always ends, for every shape, including outlines that aren't boxes (Manual input, Preparation, Delay, Data, Decision…), every side and point, and every route style.
- A saved flowchart that can't be routed still opens. If a line can't be routed, it falls back to a simple line and the page shows; one bad line never takes down the Read or Edit tab.
- The two crashing drafts on staging open and draw correctly after the fix, with no need to re-save them.
- The same holds for the server-side picture and the PDF/Word render, if they route too.
- Tests:
  - the saved chart from r3-crash-chart.json;
  - a fixed point on each side of each new shape;
  - a guard that the route walk ends.

Independent: frontend route.ts (and the backend layout, if it shares the logic).