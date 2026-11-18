---
id: 01M7PKZHKWTEZ7XWSPZPFH8C2P
created: 2026-11-18T06:02:22.204677Z
updated: 2026-11-18T06:02:26.167603Z
type: task
title: A flowchart in a document's reading view looks right without opening the canvas first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1927
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found while building COM-1908 (lane D's report, 2026-11-18): the flowchart's zoom/pan controls and lane styles are loaded only with the canvas. So a document's reading view shows a flowchart without them until the person has opened a canvas somewhere in that session. A standalone flowchart's page loads them itself.

**Fix:** a reader opening a document with a flowchart (its own, or a standalone one it shows) sees the zoom/pan controls, full screen and lane styling straight away, in a fresh browser session, without ever opening the editor.

**Done when**
- In a fresh session, a published document with a flowchart that has lanes shows the lanes styled and the zoom/pan and full-screen controls work, the same as after opening the canvas.
- The same holds for a document showing a standalone flowchart, and at phone width.
- A test covers the reading view without the canvas having been loaded.

Independent: frontend only, no migration or API change. Fix-forward in sprint 118.