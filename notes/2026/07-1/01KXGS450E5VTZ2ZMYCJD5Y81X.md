---
id: 01KXGS450E5VTZ2ZMYCJD5Y81X
created: 2026-07-14T16:59:51.182439616Z
updated: 2026-07-14T16:59:51.182439616Z
type: task
title: 'Evidence attachments: real files on assessments'
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 35
---
Upgrade assessment evidence from links to real file uploads (ADR 0013 — Phase 3 promotes attachments from links to object storage; the storage backend is S3-capable since <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue>).

- [ ] Assessment file attachments via the polymorphic `Attachment` (`owner_type=assessment`) + the storage backend: upload, list, download, delete (admin/editor).
- [ ] API: multipart upload + streamed download; size/content-type guards.
- [ ] Assessment panel: upload/list/remove evidence files alongside the existing evidence links.

Refs: ADR 0011, 0013. Relates to: <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue> (S3 storage backend).

---
*Migrated from Linear [DEV-436](https://linear.app/stevevine/issue/DEV-436/evidence-attachments-real-files-on-assessments) · created 2026-06-16 · completed 2026-06-17*  
*Related to (Linear): DEV-423, DEV-452, DEV-453*