---
id: 01M7BPMK8J05RCK1VKSPP0MBJM
created: 2026-11-14T00:17:10.418706Z
updated: 2026-11-14T00:29:06.565646Z
type: task
title: 'CI: the S3 storage test''s MinIO image is gone from Docker Hub — use Chainguard''s MinIO so backend-test can run'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1810
sprint: spsp226
comments:
- id: 01M7BQAC40BTHD4VSH7B3TB3D3
  author: Steve Vine
  at: 2026-11-14T00:29:03.999955Z
  text: 'Done — PR #1804 merged (b34a042f). The test-image pre-pull in CI and test_s3_storage.py now use chainguard/minio:latest. It''s the same MinIO server and the same `server /data` command, and it''s on Docker Hub, so the mirror fallback still applies. Locally the S3 storage tests pass against it (2 passed), and backend-test passed on its PR.'
assignee: steve
label:
- chore
priority: high
task_status: review
---
Found 2026-11-14 ~00:20 GMT while landing sprint 116 round 7. Every PR's backend-test now fails at "Pull test images": `minio/minio` no longer exists on Docker Hub ("pull access denied, repository does not exist") or on its Google mirror, and `quay.io/minio/minio` is gone too. So nothing can merge.

Fix: the pre-pull list in ci.yml and test_s3_storage.py use `chainguard/minio:latest` (on Docker Hub, so the mirror.gcr.io fallback still works). It's the same MinIO server and the same `server /data` command.

**Independent.** Done when backend-test passes on its PR, including test_s3_storage.py.