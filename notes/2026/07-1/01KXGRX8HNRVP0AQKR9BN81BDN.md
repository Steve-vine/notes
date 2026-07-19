---
id: 01KXGRX8HNRVP0AQKR9BN81BDN
created: 2026-07-14T16:56:05.429045223Z
updated: 2026-07-14T16:56:16.724415729Z
type: task
title: Bump release.yml actions off deprecated Node 20
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 26
sprint: sz3kacg
comments:
- id: 01KXGRXKJMBVVG8YMXP3VTD7DH
  author: Steve Vine
  at: 2026-07-14T16:56:16.724312557Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 19:46 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/25

    One-line bump: `docker/setup-qemu-action@v3` (Node 20) → `@v4` (Node 24). Revalidated the rest of `release.yml` — `setup-buildx-action@v4`, `login-action@v4`, `build-push-action@v7`, `actions/checkout@v6` are all already Node-24-capable (checked each `action.yml`'s `using: node24`). YAML validated. The deprecation warning clears on the next merge-to-main Release run.

    Left at In Review — say the word and I'll merge.
assignee: steve
label:
- tech_debt
priority: medium
task_status: done
---
Surfaced during <issue id="750519e8-c2c4-4b5b-b112-e161fa0574f1" href="https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library">DEV-420</issue>. The multi-arch Release run logs a deprecation warning: `docker/setup-qemu-action@v3` runs on Node 20, which GitHub forces to Node 24 from 2026-09-16. Non-blocking today.

Bump the release.yml actions to Node-24-capable versions (check `setup-qemu-action`, and revalidate `setup-buildx-action@v4` / `build-push-action@v7` / `login-action@v4` while at it) before the cutoff. Mirrors the earlier <issue id="0f372c13-4157-40c0-85c4-3739841d0cd6" href="https://linear.app/stevevine/issue/DEV-415/bump-ci-actions-to-node-24-capable-versions">DEV-415</issue> CI bump. Parent: <issue id="750519e8-c2c4-4b5b-b112-e161fa0574f1" href="https://linear.app/stevevine/issue/DEV-420/deploy-pipeline-roll-ghcr-images-on-k3s-auto-seed-control-library">DEV-420</issue>.

---
*Migrated from Linear [DEV-422](https://linear.app/stevevine/issue/DEV-422/bump-releaseyml-actions-off-deprecated-node-20) · created 2026-06-14 · completed 2026-06-16*  
*Related to (Linear): DEV-415*