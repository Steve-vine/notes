---
id: 01M7MJ5MTZ3HM6CVMTD2X9DX2T
created: 2026-11-17T10:52:16.095228Z
updated: 2026-11-17T10:52:19.269977Z
type: task
title: 'Round 3 leftovers: Polaris''s tool descriptions use the new IDs, and small wording on check screens'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1894
sprint: s7nqsy0
assignee: steve
priority: low
task_status: active
---
From the pre-UAT pass of round 3 (staging 44d15b9a). These are small leftovers from COM-1886, COM-1888, COM-1890 and COM-1877/1879.

**Done when**
- Polaris's tool descriptions and examples use the new IDs. Its answers already do. Places found so far:
  - "Record a decision" still says "next number (D-n)": assistant/tools/decisions.py, around line 304.
  - The risk-assessment tools still say "RA-n": assistant/tools/risk_assessments.py lines 5, 104, 441, 527 and 550, and risk_assessments_ai.py lines 233, 262 and 264.
  - assistant/tools/posture_collection.py around line 471 still gives "CHK-14" as an example.
  - Do a full sweep for any other old prefix (R-, G-, D-, CR-, RA-, WF-, CHK-) in Polaris's tool text and MCP instructions, and a test that fails if one comes back.
- A gap raised by a built-in check names it by ID in the gap's description too, e.g. "Raised by Compass check CHB-12: Secrets are rotated on time." The heading already does.
- The custom-check fields editor shows "Fields it keeps" once, not twice (CHC-2).
- A Viewer's only card-menu item doesn't say "edit". It reads "Open the check".