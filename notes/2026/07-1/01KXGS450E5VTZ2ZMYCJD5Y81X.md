---
id: 01KXGS450E5VTZ2ZMYCJD5Y81X
created: 2026-07-14T16:59:51.182439616Z
updated: 2026-07-19T21:30:29.026587213Z
type: task
title: 'Evidence attachments: real files on assessments'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 35
sprint: s9wnr7r
comments:
- id: 01KXGS4FQ2VAS4A8NDFTGFJAPK
  author: Steve Vine
  at: 2026-07-14T17:00:02.145898614Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 09:41 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/32

    **Delivered** (all three checklist items)
    - **Attachment API** `POST/GET/DELETE /api/v1/assessments/{id}/attachments` + streamed download, on the polymorphic `Attachment` model + storage backend. No enum migration needed (`owner_type=assessment` already existed). Delete is a soft-delete.
    - **Guards** (the agreed policy): content-type allowlist (PDF, images, txt/csv, Office) → 415; 25 MB cap → 413. Downloads are forced attachments so uploaded bytes never render in-origin. Writes admin/editor; reads any authed user. Added `python-multipart`.
    - **Assessment panel** Evidence files section: editor upload + per-file download + remove; "save first" hint until the assessment exists; viewers read-only.

    **Verification**: backend ruff/mypy + 4 attachment tests (round-trip, 415/413 guards, role gates, 404/auth); frontend lint/typecheck/36 tests (3 new)/format/build — all green. Ships on the next image roll.

    This is the last Milestone 3 brief — M3 is complete once this merges.
assignee: steve
task_status: done
priority: medium
---
Upgrade assessment evidence from links to real file uploads (ADR 0013 — Phase 3 promotes attachments from links to object storage; the storage backend is S3-capable since <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue>).

- [ ] Assessment file attachments via the polymorphic `Attachment` (`owner_type=assessment`) + the storage backend: upload, list, download, delete (admin/editor).
- [ ] API: multipart upload + streamed download; size/content-type guards.
- [ ] Assessment panel: upload/list/remove evidence files alongside the existing evidence links.

Refs: ADR 0011, 0013. Relates to: <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue> (S3 storage backend).

---
*Migrated from Linear [DEV-436](https://linear.app/stevevine/issue/DEV-436/evidence-attachments-real-files-on-assessments) · created 2026-06-16 · completed 2026-06-17*  
*Related to (Linear): DEV-423, DEV-452, DEV-453*