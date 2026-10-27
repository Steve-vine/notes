---
id: 01M5Y9EQBS4FTHA52VCVRD3J1H
created: 2026-10-27T09:00:57.081177Z
updated: 2026-10-27T12:38:13.233387Z
type: task
title: Where Compass keeps uploaded files becomes the S3-compatible storage tile — on this server's own disk until it's set up
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1357
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

## What people see

- **One tile in the Storage category: S3-compatible storage** (AWS S3, MinIO and others).
- **Overview:**
  - every uploaded file (evidence, attachments, trust centre documents, DDQ files) is kept here once it's set up;
  - until then, files are kept on the server's own disk;
  - the pod's own identity (IRSA) works without a key (ADR 0074).
- **Configure:** endpoint, bucket, region, key or "use the server's identity", Test. Moved from Admin ▸ Attachments.
- **Features:** **Keep Compass's files**. Switching it on or off changes where *new* files go. Files already stored stay where they are and stay readable, as switching store does today.
- **Status:** the result of the last Test, plus a background check, so a revoked key turns the tile to Needs attention before an upload fails.
- **Admin ▸ Files**, the file browser, stays where it is.

## Who can do what

Whoever can change the attachment store today (manage configuration).

## Notes (technical)

- Move `admin/AttachmentStoreSection.tsx`.
- Add a health column and a Beat check to `attachment_store_settings`: a HEAD on the bucket every 15 minutes.

**Chain:** on the chain (migration: health columns; API).

**Done when:**
- storage is set up and tested from the tile;
- a broken key shows on the tile within 15 minutes;
- Admin ▸ Attachments is gone.