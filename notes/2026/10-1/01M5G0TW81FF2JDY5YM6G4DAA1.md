---
id: 01M5G0TW81FF2JDY5YM6G4DAA1
created: 2026-10-21T20:00:56.065975Z
updated: 2026-10-22T18:24:39.890251Z
type: task
title: Nothing gets lost — every export downloads for its full seven days, the plan's evidence zip keeps same-named files, plan exports open only for those who can see that company, an archived company's assessment and risk files are frozen, and Activity names each file and its company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1204
sprint: sno3i7m
blocked_by:
- 01M5G0TBP83NV2WMHFJXGQGMRV
comments:
- id: 01M5GAB0Y3Y1BTCEM3D2RR94RP
  author: Steve Vine
  at: 2026-10-21T22:47:02.339657Z
  text: |-
    Done — merged in PR #1218.

    - **Exports download for their full seven days.** This covers plan, incident register, attestation and data privacy exports. Before, they stopped after about a day with "isn't ready yet": the job that built them forgot its result after 24 hours. I confirmed that in the code.
    - A build that fails keeps saying "failed" for the whole seven days.
    - After seven days an export's file is removed overnight, from the storage location it was written to. The record of who exported what stays.
    - **Same-named files:** two files with the same name on one plan activity both go into the evidence zip. The second is "pentest (2).pdf", and the index says "(uploaded as pentest.pdf)".
    - **Plan exports** can only be opened or downloaded by the person who asked for them, like every other module's export.
    - **Archived companies:** assessment and risk files can be opened and downloaded but not added or removed. Trying says "<company> is archived — restore it before making changes".
    - **Activity names files:** "created attachment firewall-review-2026.pdf on ACC.8" instead of "created attachment 6f3c…", and those lines appear when Activity is filtered to the company.

    My calls (beyond the task):
    - **Incident and data subject request files are never named in Activity**, restricted or not. They read "evidence file on INC-12" or "file on DSR-3", because a record can be restricted later and a log line can't be taken back.
    - **"Only whoever asked for it":** Compass has no per-company access rule to check beyond the requester, so plan exports follow the same rule as the other modules.
    - **Exports made before this change** keep working while their old job result lasts; after that they count as expired. Their files are still swept.
    - The Activity wording is Activity's usual "created/deleted attachment X on ACC.8", not "Added evidence 'X' to ACC.8".
assignee: steve
label:
- bug
priority: high
task_status: done
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