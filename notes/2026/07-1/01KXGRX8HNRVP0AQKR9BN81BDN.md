---
id: 01KXGRX8HNRVP0AQKR9BN81BDN
created: 2026-07-14T16:56:05.429045223Z
updated: 2026-07-14T16:56:05.429045223Z
type: task
title: Bump release.yml actions off deprecated Node 20
task_status: done
label: tech_debt
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 26
---
Surfaced during <issue id="750519e8-c2c4-4b5b-b112-e161fa0574f1" href="https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library">DEV-420</issue>. The multi-arch Release run logs a deprecation warning: `docker/setup-qemu-action@v3` runs on Node 20, which GitHub forces to Node 24 from 2026-09-16. Non-blocking today.

Bump the release.yml actions to Node-24-capable versions (check `setup-qemu-action`, and revalidate `setup-buildx-action@v4` / `build-push-action@v7` / `login-action@v4` while at it) before the cutoff. Mirrors the earlier <issue id="0f372c13-4157-40c0-85c4-3739841d0cd6" href="https://linear.app/stevevine/issue/DEV-415/bump-ci-actions-to-node-24-capable-versions">DEV-415</issue> CI bump. Parent: <issue id="750519e8-c2c4-4b5b-b112-e161fa0574f1" href="https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library">DEV-420</issue>.

---
*Migrated from Linear [DEV-422](https://linear.app/stevevine/issue/DEV-422/bump-releaseyml-actions-off-deprecated-node-20) · created 2026-06-14 · completed 2026-06-16*  
*Related to (Linear): DEV-415*