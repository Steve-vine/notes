---
id: 01KXGRY19BXBNB74ZHC5MFSHWS
created: 2026-07-14T16:56:30.763203753Z
updated: 2026-07-14T16:56:30.763203753Z
type: task
title: S3 storage backend for attachments
label: follow_up
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 27
---
Surfaced during <issue id="81818b78-136c-4940-a590-2176d5c701de" href="https://linear.app/stevevine/issue/DEV-398/read-only-content-import-policies">DEV-398</issue>. The storage abstraction (core/storage.py) ships a LocalStorage backend; the s3 branch of get_storage() raises NotImplementedError. Implement the S3 backend for production.

* boto3 S3Storage implementing the Storage protocol (put/open/exists).
* s3_* settings (endpoint, bucket, region, access/secret keys) wired via the chart secrets/ExternalSecret + values-prod.
* Disable the storage PVC for the s3 backend (it's already gated on storage.persistentVolume.enabled).
* Tests against a MinIO/S3 testcontainer.

Do this when production lands. Parent: <issue id="81818b78-136c-4940-a590-2176d5c701de" href="https://linear.app/stevevine/issue/DEV-398/read-only-content-import-policies">DEV-398</issue>.

---
*Migrated from Linear [DEV-423](https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments) · created 2026-06-14 · completed 2026-06-16*  
*Related to (Linear): DEV-518, DEV-503, DEV-499, DEV-436*