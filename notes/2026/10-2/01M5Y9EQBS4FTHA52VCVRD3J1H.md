---
id: 01M5Y9EQBS4FTHA52VCVRD3J1H
created: 2026-10-27T09:00:57.081177Z
updated: 2026-10-27T14:46:34.709327Z
type: task
title: Where Compass keeps uploaded files becomes the S3-compatible storage tile — on this server's own disk until it's set up
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1357
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5YX7JQHHD2SFJKZ04J8DCVS
  author: Steve Vine
  at: 2026-10-27T14:46:34.480906Z
  text: |-
    Done — PR #1373, merged to main (migration 0711_attachment_store_health).

    - S3-compatible storage ▸ Configure: endpoint, bucket, region, a key or "use the server's identity", and Test, moved from Admin ▸ Attachments. Saving the bucket here makes it where new files go.
    - Features ▸ Keep Compass's files is the store's own backend, with no second store:
      - off sends new files to the server's own disk, and is refused where no disk is mounted;
      - on sends them back to the bucket;
      - files already stored stay where they are and stay readable;
      - the bucket's settings are kept while it's off, so switching back needs nothing re-entered.
    - Status: a HEAD on the bucket every 15 minutes, plus each Test of the saved bucket, records whether it answers and when. A revoked key turns the tile to Needs attention ("The bucket can't be reached: AccessDenied: …") before an upload fails.
    - Admin ▸ Files stays where it is. Admin ▸ Attachments goes in COM-1360.

    My call: choosing the disk on the old form no longer wipes the bucket's settings, so the switch can always bring them back.
assignee: steve
label:
- feature
priority: medium
task_status: review
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