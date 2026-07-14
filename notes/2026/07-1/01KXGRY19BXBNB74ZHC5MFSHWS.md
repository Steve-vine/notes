---
id: 01KXGRY19BXBNB74ZHC5MFSHWS
created: 2026-07-14T16:56:30.763203753Z
updated: 2026-07-14T16:56:43.576520162Z
type: task
title: S3 storage backend for attachments
label:
- follow_up
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 27
sprint: sz3kacg
comments:
- id: 01KXGRYDSR15TDJ46D6BQVQ16M
  author: Steve Vine
  at: 2026-07-14T16:56:43.576412889Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 20:16 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/26

    All checklist items delivered:
    - **boto3 `S3Storage`** implementing the `Storage` protocol (put/open/exists); `get_storage()`'s `s3` branch now returns it (requires `S3_BUCKET`). `open()` returns a seekable `BytesIO` (StreamingResponse-friendly) and maps `NoSuchKey`/`404` → `FileNotFoundError`.
    - **`s3_*` settings** wired through the chart: `configmap` (endpoint/bucket/region/path-style) + **optional** `S3_ACCESS_KEY_ID`/`S3_SECRET_ACCESS_KEY` in `secrets.yaml` + `externalsecret.yaml` (render only when set, so local/k3s is unaffected). `values-prod.yaml` is now a real S3 overlay.
    - **PVC disabled for s3** — `values-prod` sets `storage.persistentVolume.enabled=false` (already gated), so no volume is mounted.
    - **MinIO testcontainer** — `test_s3_storage.py` round-trips against a real MinIO (generic container + boto3, no extra dep).

    Verification: backend ruff/mypy(src) clean, 27 unit + 55 integration pass (incl. MinIO); helm lint clean — k3s renders `local`/no-S3-secret, prod renders `s3`/ESO-keys/no-PVC.

    No live deploy — k3s has no S3, stays on local. This just makes S3 available for a future prod cluster. Left at In Review — say the word and I'll merge.
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