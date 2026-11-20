---
id: 01M7WZJGMFCT7HJTMMCZW7ZDKC
created: 2026-11-20T17:20:24.719888Z
updated: 2026-11-20T17:58:02.73119Z
type: task
title: A document's own flowchart picture takes the new house style when the document's type changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2034
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT of COM-2024 (staging b65d7ed8, tester B).

COM-2024's stated assumption is that a document's own flowchart follows its document's house style, including after the document's type changes.

**Steps:** On the Edit tab of "E2E pre-UAT COM-2023 same own flowchart (Procedure)", change Type from Procedure to Runbook. The Runbook type uses a red house style.

**Seen:** the document's text and the flowchart canvas turn red, but the flowchart picture on the Edit and Read tabs stays grey until the flowchart is opened and Done is pressed. (The tester set the type back afterwards.) Screenshot: ~/compass-uat/s6y6p7g/COM-2024/r4-type-changed-to-runbook-edit.png

**Done when**
- After a document's type changes to one with a different house style, its own flowcharts show in the new house style straight away on the Edit and Read tabs, in print, PDF and Word. Nobody has to open the flowchart and press Done.
- The same applies when the house style mapped to the document's type is changed in Admin.
- No unpublished change is created just by redrawing a picture in new colours, beyond the type change itself.
- A test covers changing a document's type with an own flowchart in it.