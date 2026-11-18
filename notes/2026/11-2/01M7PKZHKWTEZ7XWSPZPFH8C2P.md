---
id: 01M7PKZHKWTEZ7XWSPZPFH8C2P
created: 2026-11-18T06:02:22.204677Z
updated: 2026-11-18T08:14:28.037441Z
type: task
title: A flowchart in a document's reading view looks right without opening the canvas first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1927
sprint: s6y6p7g
comments:
- id: 01M7PMVWMM6NE6GC5YFK2Z2XK1
  author: Steve Vine
  at: 2026-11-18T06:17:50.996534Z
  text: |-
    Done — PR #1911, merged 1412a636.
    A flowchart in a document's Read tab is now styled straight away, in a fresh session, without anyone opening the canvas: lane names over the picture, zoom in/out with panning inside the frame, and Full screen.
    This holds for a document's own flowchart and for a standalone flowchart the document shows. At phone width the frame stays within the column and pans inside itself.
    A test renders the reading view for both kinds and fails if anything loads the canvas. It checks the styles are there, the lanes are placed, zoom works and full screen opens.
    To check on staging: in a fresh private window, open a published document with a laned flowchart (and one showing a standalone flowchart) without editing anything. Lanes, zoom and full screen should look and work as they do after opening the canvas, including on a phone.
- id: 01M7PVHDP5DJS3MVWW864K9M13
  author: Steve Vine
  at: 2026-11-18T08:14:28.03719Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed
    Fresh browser sessions (a new, empty profile each time), signed in as E2E Viewer, who has no Edit tab, so the canvas was never opened.
    - A published document with a laned flowchart, in a fresh session: Passed. I went straight to /content/e2e-pre-uat-com-1904-flowchart-document. The lane names were placed and styled at once: Customer, Service Desk, E2E Starter and the deleted-role lane, sticky over the picture with the lane background (01-fresh-read.png). Zoom in widened the frame from 627 to 1255px, and it panned inside its frame by 250px while the lane names stayed put (02-zoomed-panned.png). Full screen opened (03-fullscreen.png).
    - The same for a document showing a standalone flowchart, and at phone width: Passed. None of tester B's standalone flowcharts had lanes, so as Admin A I made "E2E pre-UAT COM-1927 laned standalone flowchart" (lanes User and IT support), published it, and showed it in a new document, "E2E pre-UAT COM-1927 document showing a standalone flowchart". In a new fresh Viewer session that document showed the lanes styled, zoom worked, and full screen opened (06-, 07-*.png). At 390px wide neither document scrolled sideways, zoomed or not (08-, 09-, 10-*.png).
    - A test covers the reading view without the canvas: not checked in the browser. The builder's note says one is in place.
    - Seen while testing (logged under COM-1905): as a Viewer, a role lane reads "No business role called E2E Starter in E2E Test Company", and the business-roles request gets 403.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1927/
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found while building COM-1908 (lane D's report, 2026-11-18): the flowchart's zoom/pan controls and lane styles are loaded only with the canvas. So a document's reading view shows a flowchart without them until the person has opened a canvas somewhere in that session. A standalone flowchart's page loads them itself.

**Fix:** a reader opening a document with a flowchart (its own, or a standalone one it shows) sees the zoom/pan controls, full screen and lane styling straight away, in a fresh browser session, without ever opening the editor.

**Done when**
- In a fresh session, a published document with a flowchart that has lanes shows the lanes styled and the zoom/pan and full-screen controls work, the same as after opening the canvas.
- The same holds for a document showing a standalone flowchart, and at phone width.
- A test covers the reading view without the canvas having been loaded.

Independent: frontend only, no migration or API change. Fix-forward in sprint 118.