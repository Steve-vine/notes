---
id: 01M7Q28G2TE9H70YAXC1JRA2RD
created: 2026-11-18T10:11:55.610115Z
updated: 2026-11-18T10:12:25.926488Z
type: task
title: Flowchart connections never share a line or an arrowhead, so each one plainly leads to its own step
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1935
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
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