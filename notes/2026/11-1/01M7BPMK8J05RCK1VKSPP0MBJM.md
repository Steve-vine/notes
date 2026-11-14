---
id: 01M7BPMK8J05RCK1VKSPP0MBJM
created: 2026-11-14T00:17:10.418706Z
updated: 2026-11-14T00:17:15.391055Z
type: task
title: 'CI: the S3 storage test''s MinIO image is gone from Docker Hub — use Chainguard''s MinIO so backend-test can run'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1810
sprint: spsp226
assignee: steve
label:
- chore
priority: high
task_status: active
---
Found 2026-11-14 ~00:20 GMT while landing sprint 116 round 7. Every PR's backend-test now fails at "Pull test images": `minio/minio` no longer exists on Docker Hub ("pull access denied, repository does not exist") or on its Google mirror, and `quay.io/minio/minio` is gone too. So nothing can merge.

Fix: the pre-pull list in ci.yml and test_s3_storage.py use `chainguard/minio:latest` (on Docker Hub, so the mirror.gcr.io fallback still works). It's the same MinIO server and the same `server /data` command.

**Independent.** Done when backend-test passes on its PR, including test_s3_storage.py.