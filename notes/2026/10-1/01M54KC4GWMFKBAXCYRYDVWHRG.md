---
id: 01M54KC4GWMFKBAXCYRYDVWHRG
created: 2026-10-17T09:34:02.780135Z
updated: 2026-10-17T09:37:31.617921Z
type: task
title: Export the plan for an auditor — pick a period, get a PDF of every entry with its status, completion, outcome, controls and evidence list, plus a download of all the evidence files
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1058
sprint: sxflvhs
blocked_by:
- 01M54KAWZJW2C6F31AD09QF06D
- 01M54KA5TAF3NNT5C0DPB06B26
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 8). Built on COM-1056, so the export can include the sign-off.

## What people see

- **Export** on the SAP page (for `sap.view`). It asks for:
  - a **period**: a year, or From–To dates for an audit window ("1 April 2026 – 31 March 2027");
  - optionally a **type** filter;
  - the output: **PDF report**, **Evidence pack (.zip)**, or both.
- **The PDF report**, in the company's house style:
  - a cover with the company, the period, when it was produced and by whom;
  - the period's **sign-off(s)**: who approved, when, and the note;
  - a summary: done, done late, overdue, cancelled and planned, by type;
  - one section per entry, in date order: title, type, owner, dates, status; for done entries the completion date, who completed it and the outcome; for cancelled ones the reason; the linked controls with their framework requirements; the evidence file names; and any gaps or risks raised from it with their current status.
- **The evidence pack:** a .zip with one folder per entry ("2027-03 External penetration test"), holding its evidence files and a short index.
- A large pack is built in the background. You get a "ready to download" notification, and the file stays available for 7 days.

## Rules

- What's in the export is exactly what the person could see on screen for that company.
- Producing an export is in Activity (who exported which period). Auditors sometimes ask who had the evidence.

## Notes (technical)

- PDF through the house-style render pipeline (ADR 0110, `core/render`), as review PDFs are, not a new renderer. Watch the house-style page size (sprint 71 lessons).
- Zip building in a Celery task: idempotent, takes ids, streams from storage to a temporary object rather than holding the files in memory. Watch the worker memory pins on staging.
- Consider registering the PDF in Reports (the report catalogue) too, if it fits without contortion. If not, say so in the PR.

**Done when:** a period's PDF and evidence pack can be produced and downloaded, matching what's on screen, with large packs built in the background.