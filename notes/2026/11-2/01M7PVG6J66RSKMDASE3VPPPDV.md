---
id: 01M7PVG6J66RSKMDASE3VPPPDV
created: 2026-11-18T08:13:47.974104Z
updated: 2026-11-18T08:13:47.974104Z
type: task
title: A standalone flowchart's PDF and Word follow its Page setting every time it's changed
label: bug
task_status: todo
assignee: steve
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1929
---
Pre-UAT, 2026-11-18 (COM-1908's Page: Portrait / Landscape setting on a standalone flowchart):
- Changing Page doesn't change the PDF or Word once that draft has been exported.
- Set Landscape and export: landscape. Switch to Portrait and export again: still landscape.
- On another flowchart, exporting first and then setting Landscape left both files portrait, even after a reload, until it was published.
Screenshots and files: ~/compass-uat/s6y6p7g/COM-1907/ (fc1907-draft-*.pdf, landscape-*.pdf/.docx, landscape3-*).

**Done when**
- After any change of Page, on the draft or the published version, the next PDF and Word export comes out in that orientation, without a reload or a publish.
- A test changes Page back and forth between exports and checks the orientation each time.

Independent unless the fix needs an API change.