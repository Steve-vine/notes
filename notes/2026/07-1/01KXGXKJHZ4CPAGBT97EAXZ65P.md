---
id: 01KXGXKJHZ4CPAGBT97EAXZ65P
created: 2026-07-14T18:18:10.879539244Z
updated: 2026-07-14T18:18:24.128682769Z
type: task
title: Configure zot as a docker.io pull-through mirror for CI image pulls
label:
- chore
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 162
sprint: sc5mwga
comments:
- id: 01KXGXKZG0ACGDDE6EH70H8PYJ
  author: Steve Vine
  at: 2026-07-14T18:18:24.128581414Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-05 22:27 UTC]
    **Released** (PR #153 → main 29e966a; main CI green, no deploy as designed).

    Delivered:
    - zot `extensions.sync` on-demand mirror of docker.io, allow-listed to `library/**`, `testcontainers/**`, `nginxinc/**`, `minio/**` (zot Helm values, rev 5; new upstream repos need their prefix added there — documented in docs/ci.md).
    - CI pre-pulls test images via `zot.citops.net/library/...` + retag (also added `minio/minio`, previously pulled mid-test from Docker Hub); BuildKit resolves docker.io base images through the mirror via `buildkitd-config-inline`.
    - Mirror pre-warmed; measured: cold postgres:16 pull 2m38s (one-time sync), warm 0.6s on the host.

    Honest outcome vs expectations: the pre-pull step stayed ~50s (was ~45–49s) because **image extraction on the SATA disk dominates that step, not the download** — and the list gained minio. The issue's real wins hold: routine CI pulls never leave the LAN, and Docker Hub rate limits + upstream DNS flakes are out of the failure surface. The remaining extraction cost is the same I/O story as DEV-855/NVMe.
---
Every CI run pulls `postgres:16` + `testcontainers/ryuk` from Docker Hub cold (~49s/run — ephemeral dind pods have no image cache), and base images (`ghcr.io/astral-sh/uv`, `node:22`, `nginxinc/nginx-unprivileged`) come over the uplink on every uncached build. The uplink also produced one DNS SERVFAIL flake during <issue id="3de7fec8-9bd5-4ed2-a1c6-d4304c5e370a" href="https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server">DEV-845</issue>.

zot supports sync/pull-through mirroring (`extensions.sync` with `registries` config + `content` filters). Configure the g5 zot to mirror [docker.io](<http://docker.io>) (and optionally [ghcr.io](<http://ghcr.io>)), then point the dind daemon's `registry-mirrors` at it (ARC values change) or pull via explicit `zot.citops.net/...` refs in CI. Wins: LAN-speed pulls (~2s vs ~49s), removes Docker Hub rate-limit and DNS-flake exposure. Touches Steve's zot Helm values (infra) + possibly the ARC runner values — coordinate before applying.

---
*Migrated from Linear [DEV-854](https://linear.app/stevevine/issue/DEV-854/configure-zot-as-a-dockerio-pull-through-mirror-for-ci-image-pulls) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-855, DEV-845*