---
id: 01KXGXKJHZ4CPAGBT97EAXZ65P
created: 2026-07-14T18:18:10.879539244Z
updated: 2026-07-14T18:18:19.239284495Z
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
---
Every CI run pulls `postgres:16` + `testcontainers/ryuk` from Docker Hub cold (~49s/run — ephemeral dind pods have no image cache), and base images (`ghcr.io/astral-sh/uv`, `node:22`, `nginxinc/nginx-unprivileged`) come over the uplink on every uncached build. The uplink also produced one DNS SERVFAIL flake during <issue id="3de7fec8-9bd5-4ed2-a1c6-d4304c5e370a" href="https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server">DEV-845</issue>.

zot supports sync/pull-through mirroring (`extensions.sync` with `registries` config + `content` filters). Configure the g5 zot to mirror [docker.io](<http://docker.io>) (and optionally [ghcr.io](<http://ghcr.io>)), then point the dind daemon's `registry-mirrors` at it (ARC values change) or pull via explicit `zot.citops.net/...` refs in CI. Wins: LAN-speed pulls (~2s vs ~49s), removes Docker Hub rate-limit and DNS-flake exposure. Touches Steve's zot Helm values (infra) + possibly the ARC runner values — coordinate before applying.

---
*Migrated from Linear [DEV-854](https://linear.app/stevevine/issue/DEV-854/configure-zot-as-a-dockerio-pull-through-mirror-for-ci-image-pulls) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-855, DEV-845*