---
id: 01M7Q28G2TE9H70YAXC1JRA2RD
created: 2026-11-18T10:11:55.610115Z
updated: 2026-11-18T10:38:12.537406Z
type: task
title: Flowchart connections never share a line or an arrowhead, so each one plainly leads to its own step
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1935
sprint: s6y6p7g
comments:
- id: 01M7Q3RKA4M8DB3MA28ST8MXHY
  author: Steve Vine
  at: 2026-11-18T10:38:11.780787Z
  text: |-
    Done — PR #1926, merged 3fa639c6.
    No two connections share a line or an arrowhead any more. Each one meets its step at its own point on the side, so arrowheads are separate. Lines that run side by side are kept visibly apart, and a line goes round rather than along another, turning where another turns, or through another's end. This holds on the canvas, in the reading view, and in the PDF, Word and downloads.
    Both examples now read correctly:
    - in the converted "Known fix?" diagram, Yes goes round the Approve diamond to Apply the fix, and the No loop back to Investigate has its own line;
    - in the request flow, the Hand-off goes down to End on its own line, and only Write up leads into Email the confirmation.
    A large flowchart (over 60 shapes) shows plain lines while a shape is being dragged and routes them properly when it's dropped, so dragging doesn't lag.
    To check on staging: open the converted "Known fix?" diagram and the COM-1904 request flow on the canvas and in the PDF.
    The first CI run failed on an unrelated collection test. It passed locally and on the re-run.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Re-check on staging 27151cd9, 2026-11-18 (tester A, after COM-1931): lines no longer go through steps, but two connections can run along the same line, so the picture shows the wrong flow.
- In a converted text diagram ("Known fix?" plus a long "Approve an emergency change…?" decision and a No loop back to Investigate):
  - the Yes line to "Apply the fix" runs down the same line as the No line into the Approve diamond, so Yes appears to go to Approve;
  - it also shares a line with "Approve → No → Investigate".
- In the COM-1904 request flow, Hand-off → End and Write up → Email share the arrowhead into "Email the confirmation", so the Hand-off appears to lead to Email.
- It shows on the canvas and in the PDF.
Screenshots: ~/compass-uat/s6y6p7g/COM-1931/re-05-converted-zoom.png, re-04-converted-canvas.png, re-convert-v2-p3.png, re-v4-p4-hi.png

**Done when**
- No two connections share a segment or an arrowhead. Where connections must run side by side, they're visibly apart, and each arrives at its own target.
- Both examples above read correctly on the canvas, in the reading view and in the PDF.
- A test asserts that no two routed connections overlap, on charts shaped like the two examples.

Independent: frontend layout.