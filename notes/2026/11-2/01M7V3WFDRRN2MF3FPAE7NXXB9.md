---
id: 01M7V3WFDRRN2MF3FPAE7NXXB9
created: 2026-11-19T23:57:16.600963Z
updated: 2026-11-20T02:24:55.24855Z
type: task
title: A shape added from the left bar always lands in view
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2015
sprint: s6y6p7g
comments:
- id: 01M7V5W6WW99S0WDCHBF9AGCQ3
  author: Steve Vine
  at: 2026-11-20T00:32:05.020082Z
  text: |-
    Done — PR #2006, merged 282ab8fec.
    A shape you click in from the left bar, or a step you add with Tab, now always ends up on screen. If it would land off the edge, the canvas pans just enough to show it, a little way in from the edge and at the same zoom. It is selected and ready for you to type its label.
    A shape that already lands in view leaves the view where it was. Dragging a shape in from the bar works as before.
    Assumption: the pan is instant, not animated, so you can start typing straight away.
    To check on staging: select a shape near the bottom of the canvas and click Step on the left bar, then press Tab. Each time, the new shape should come into view, selected, ready to type.
- id: 01M7VCATEG9JNS8MM3TP4J2VAJ
  author: Steve Vine
  at: 2026-11-20T02:24:55.248311Z
  text: |-
    Pre-UAT on staging d8749c62 — Passed
    - A shape added by clicking the bar, or by Tab, always ends up in view, panning just enough, selected and ready to type: Passed.
      - As E2E Admin A, on "E2E pre-UAT COM-2016 new standalone", I dragged Start to the bottom edge of the view (its bottom at 857 of 900px), selected it and clicked Step on the left bar. The view panned up 119px at the same zoom. The new Step landed at 808–868px, selected, and joined to Start (r3re-01, r3re-02).
      - Typing straight away named it "Check request" (r3re-03).
      - Tab from it, twice: each time the view panned 120px, and the new step was in view, selected and named by typing ("Approve", "Notify") (r3re-04, r3re-05).
    - A shape that already lands in view leaves the view alone: Passed. With Start selected near the top, clicking Decision put it between Start and Check request, and the view didn't move (r3re-06).
    - Dragging from the bar is unchanged: Passed. Data dragged from the bar landed where I let go, selected, and the view didn't move (r3re-07).
    - Tests: Passed. addInView.test.tsx covers a click-add and a Tab after a shape at the bottom edge, and a shape that lands in view.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2015/r3re-*
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in pre-UAT of round 3, by Tester A on staging 7ea67f64, after COM-1993. Round 2's COM-1946 promised that a clicked shape lands in view.

**Steps:** select a shape near the bottom of the view, then click a shape on the left bar.

**Seen:** the new shape is added below the selected one, and the view doesn't follow when it lands off screen.

**Done when**
- A shape added by clicking the bar, or by Tab ("add a step after"), always ends up in view. If it lands off screen, the view pans just enough to show it, and it is selected, ready to type its label.
- Dragging from the bar is unchanged.
- Tests cover a click-add after a shape at the bottom edge of the view, ending in view.

Independent: frontend only.