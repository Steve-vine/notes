---
id: 01M5G0TW81FF2JDY5YM6G4DAA1
created: 2026-10-21T20:00:56.065975Z
updated: 2026-10-21T20:04:07.501079Z
type: task
title: Nothing gets lost — every export downloads for its full seven days, the plan's evidence zip keeps same-named files, plan exports open only for those who can see that company, an archived company's assessment and risk files are frozen, and Activity names each file and its company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1204
sprint: sno3i7m
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1200, which gives every file its company. The fixes the review found.

**Chain:** on the chain — migration + API

## What people see

- **Exports last their seven days.**
  - Plan, incident, attestation and data privacy exports download for the full seven days the screen promises. Today they very likely stop after about a day with "The export isn't ready yet".
  - After seven days the file is removed, as data privacy already does. The record of who exported what stays.
  - The audit pack (COM-1214) reuses this.
- **The plan's evidence zip** keeps both of two same-named files on one activity; the second becomes "name (2).pdf". Today one overwrites the other.
- **Plan exports** download only for someone who can see that company's plan, like the other modules' exports. Today anyone who can view the plan can fetch any export by its address.
- **Archived companies:** assessment and risk files can be opened and downloaded but not added or removed, like everything else on an archived company. Today both are still allowed.
- **Activity**:
  - Shows "Added evidence 'firewall-review-2026.pdf' to ACC.8" rather than "created attachment 6f3c…".
  - File changes appear when Activity is filtered to a company.

## Notes (technical)

- **Export download expiry.** Exports find their output through the Celery result (`AsyncResult(task_id).result`, e.g. `api/v1/sap.py`). The backend is Valkey and `result_expires` isn't set, so Celery's default of one day applies.
  - Check a `celery-task-meta-*` TTL on staging first; the classifier refused that read during planning.
  - Record key, store ref, media type and filename on the export row when the task finishes. Existing rows whose result has gone are marked expired.
- **Export sweep.** Reuse the data privacy export sweep for every export kind, fixed to delete from the file's own store. Today it deletes from the current store (`stores(None)` in `core/dsr_retention.py`).
- `core/sap_export.py`: de-duplicate entry names inside the zip.
- `api/v1/sap.py` export routes: check the company (and match `incident_exports`' requester rule).
- `require_writable_company` on the write routes in `api/v1/assessment_attachments.py` and `risk_attachments.py`.
- `Attachment.activity_label` (filename plus owner); audit rows carry the attachment's `company_id`.

**Done when:**
- a three-day-old export downloads and an eight-day-old one says it has expired, with its file gone;
- a zip with two same-named files holds both;
- an archived company refuses assessment file changes;
- Activity filtered to a company shows a file being added, by its name.