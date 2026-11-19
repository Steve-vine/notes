---
id: 01M7V3VY1EWTJVY0AKT3SX9CXZ
created: 2026-11-19T23:56:58.798959Z
updated: 2026-11-19T23:58:09.386516Z
type: task
title: A connection fixed to certain points no longer crashes the flowchart for good
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2012
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: urgent
task_status: active
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