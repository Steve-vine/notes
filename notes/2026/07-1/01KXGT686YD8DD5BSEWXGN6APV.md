---
id: 01KXGT686YD8DD5BSEWXGN6APV
created: 2026-07-14T17:18:28.574647972Z
updated: 2026-07-19T21:30:29.385540166Z
type: task
title: 'Candidate: S3 object storage backend (prod)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 74
order: 0.0
assignee: steve
task_status: backlog
priority: medium
---
**Candidate — to be scoped/decided in M17.** Likely a duplicate/umbrella of existing <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue> — link/dedupe rather than re-create if that issue already covers it.

Production-durable evidence storage: implement the S3 `STORAGE_BACKEND` (the attachment layer is already abstracted; today it's `local` on a PVC). Considerations: bucket config + IAM/credentials via secrets, presigned up/download, migration of existing local objects, and the reporting evidence-pack artifacts (M15) landing in the same store. Plumbing, not a feature gap, but needed before a real prod deployment.

---
*Migrated from Linear [DEV-503](https://linear.app/stevevine/issue/DEV-503/candidate-s3-object-storage-backend-prod) · created 2026-06-19*  
*Related to (Linear): DEV-423*