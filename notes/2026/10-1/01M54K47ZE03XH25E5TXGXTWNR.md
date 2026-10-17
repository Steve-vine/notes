---
id: 01M54K47ZE03XH25E5TXGXTWNR
created: 2026-10-17T09:29:44.174276Z
updated: 2026-10-17T09:29:46.996352Z
type: task
title: Evidence can be uploaded to an SAP entry — reports, screenshots, training exports — and added to a done entry but never removed from one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1044
sprint: sxflvhs
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041). Built on COM-1042.

## What people see

- An **Evidence** section on an entry's page: each file's name, who added it, when, and its size. There's a **Download** for each file.
- **Upload** accepts the same files as assessment evidence (PDF, images, Office documents, CSV and so on) up to the same size limit. You can upload several files at once.
- **Who can upload:** people with `sap.manage_plan`, and the entry's owner (from the portal in COM-1053).
- **Removing a file:**
  - before the entry is done: allowed for whoever uploaded it, or anyone with `sap.manage_plan`;
  - once it's done: nobody can remove evidence. The entry is audit evidence (Steve, B). More can still be added, and the reason goes in a comment.
- The Schedule list shows a paperclip with the number of files.

## Rules

- Training evidence is a file, such as the completion export from the training system (Steve, A). Compass doesn't track attendance.
- Uploading and removing are in Activity.

## Notes (technical)

- Reuse the polymorphic `Attachment` with a new `AttachmentOwnerType.sap_entry`. The enum needs explicit create/alter handling (memories: alembic new enum, enum reuse). Reuse the store, allowlist and size rules (`core/uploads.py`, `core/storage.py`), the forced-download serving and the `store_ref` handling, all as `assessment_attachments.py` does.
- The "never removed once done" rule is enforced in the API, not just hidden in the UI. Done arrives in COM-1045, so this task enforces it on the status COM-1045 will add, or COM-1045 adds the check. Note in the PR which.
- The company purge (`core/company_purge.py`) must remove SAP attachments and their stored bytes.

**Done when:** files can be uploaded, listed, downloaded and (before done) removed on an entry, under the rules above.