---
id: 01M7WZJGMFCT7HJTMMCZW7ZDKC
created: 2026-11-20T17:20:24.719888Z
updated: 2026-11-20T18:40:22.335825Z
type: task
title: A document's own flowchart picture takes the new house style when the document's type changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2034
sprint: s6y6p7g
comments:
- id: 01M7X44VJHVDEKYPQS17Y4QKCS
  author: Steve Vine
  at: 2026-11-20T18:40:20.049108Z
  text: |-
    Done — PR #2030, merged 514c4649.
    When a document's type changes to one with another house style, or the house style mapped to its type is changed in Admin, its own flowcharts show in the new colours at once. This covers the Edit and Read tabs, full screen and print, and the PDF and Word. Nobody has to open a flowchart and press Done. Nothing is saved to do it, so no unpublished change appears beyond the type change itself.
    How it works, in short: a flowchart's picture now notes which house colours it was drawn in, and wherever it's shown or printed those are swapped for the colours of the house style in force there. A colour chosen for one shape (including the custom colours) stays as chosen. A standalone flowchart follows its own type's house style in the same way, in every document, on screen and in the PDF and Word.
    Assumption: a picture kept before this change doesn't note its colours. On screen it is drawn afresh in the new colours. The PDF and Word work out which house style it was drawn in from its colours and swap them, and print it as it was if none fits. This affects only the existing test documents on staging; flowcharts aren't released yet.
    Checked in a real browser on staging data, without saving anything: "E2E pre-UAT COM-2023 same own flowchart (Procedure)", shown as if it were a Runbook, draws its flowchart in the red Runbooks colours on the Read and Edit tabs.
    Tests: a picture kept in one house style and recoloured into another matches the same chart drawn in it; a document's flowchart changes colour when its type changes, with nothing written; the PDF and Word print a document's own flowchart in its current house style and a standalone one in its own.
    Note: cached PDFs and Word files are made afresh after deploy (house-style renderer version 18).
    To check on staging: change "same own flowchart (Procedure)" to Runbook, look at the Edit and Read tabs and the PDF and Word, then set it back.
assignee: steve
label:
- bug
priority: high
task_status: review
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