---
id: 01M7PVG6J66RSKMDASE3VPPPDV
created: 2026-11-18T08:13:47.974104Z
updated: 2026-11-19T18:45:28.671243Z
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
- id: 01M7Q1W06WY4KJY15NNZXD6G7J
  author: Steve Vine
  at: 2026-11-18T10:05:06.1401Z
  text: |-
    Pre-UAT on staging 27151cd9 — Passed
    All as E2E Admin A, in E2E Test Company.
    - The next PDF and Word export follows every change of Page, with no reload or publish. On the draft of "E2E pre-UAT COM-1907 Service request handling" I went Portrait → Landscape → Portrait → Landscape → Portrait and exported a PDF and a Word file after each change. All ten came out the right way: the flowchart page of each PDF (P, L, P, L, P), and section 2 of each Word file. The title page stays portrait. This is the same draft that gave landscape for a Portrait setting before. Passed.
    - On the published version: "…Document C (own flowchart) flowchart" (published, Landscape) exported landscape. Switching to Portrait made a draft, and its next export was portrait. Switching back to Landscape gave landscape. Passed.
    - The test that flips Page between exports is the builder's (PR #1916). I checked the behaviour on staging, not the test itself.
    Files: ~/compass-uat/s6y6p7g/COM-1929/re-1..5-*.pdf/.docx and re-docC-*.pdf
assignee: steve
label:
- bug
priority: high
task_status: done
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