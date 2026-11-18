---
id: 01M7PKZHKWTEZ7XWSPZPFH8C2P
created: 2026-11-18T06:02:22.204677Z
updated: 2026-11-18T06:17:51.70076Z
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