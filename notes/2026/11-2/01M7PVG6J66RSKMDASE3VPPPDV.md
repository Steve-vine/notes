---
id: 01M7PVG6J66RSKMDASE3VPPPDV
created: 2026-11-18T08:13:47.974104Z
updated: 2026-11-18T08:36:26.161941Z
type: task
title: A standalone flowchart's PDF and Word follow its Page setting every time it's changed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1929
sprint: s6y6p7g
comments:
- id: 01M7PWSM09AKDH7N6NKGW0GV7A
  author: Steve Vine
  at: 2026-11-18T08:36:25.225243Z
  text: |-
    Done — PR #1916, merged f086760f.
    A standalone flowchart's PDF and Word now follow its Page setting every time it changes. Switch Portrait ↔ Landscape and the next export comes out that way, with no reload or publish.
    A published version exports as it was published, and the draft exports as the draft now stands.
    Cause: exports were remembered by when the flowchart last changed. Page changes only the flowchart itself, not that time, so an earlier export kept being handed back. Exports are now remembered by exactly what they show.
    A test flips Page back and forth between exports (Word every time, and the PDF where it can be rendered), and checks a published version against a newer draft.
    To check on staging: on a standalone flowchart, export the PDF and Word, change Page, export again, and repeat.
assignee: steve
label:
- bug
priority: high
task_status: review
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