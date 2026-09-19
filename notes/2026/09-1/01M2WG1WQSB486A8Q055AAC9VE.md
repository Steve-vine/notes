---
id: 01M2WG1WQSB486A8Q055AAC9VE
created: 2026-09-19T09:30:42.297437Z
updated: 2026-09-19T09:30:53.069234Z
type: task
title: Roll the CI runner image — kubeconform is in the Dockerfile but not yet on the runners
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 725
sprint: stek6vx
assignee: steve
label:
- chore
priority: low
task_status: todo
---
**Steve's** — the `helm upgrade` of the runner scale set is classifier-blocked for Claude (see the runner-image-roll notes).

COM-655 added `kubeconform v0.8.0` to `scripts/infra/ci-runner-image/Dockerfile`. Until the image is rebuilt and rolled, every `chart` job falls back to downloading it from GitHub over the g5 uplink — the exact class of fetch the baked image exists to remove, and a likely first thing to flake on a bad-uplink day.

**Do**, on g5: build and push the runner image with a new dated tag (`docker build … scripts/infra/ci-runner-image`, push to `zot.citops.net/compass/ci-runner:<runner-version>-yyyymmdd-hhmm`), set that tag in `scripts/infra/arc-compass-runners-values.yaml`, `helm upgrade` the scale set. Nothing else changed in the image since the last roll (2026-08-29) apart from kubeconform.

**Acceptance**: a `chart` job's "Fetch kubeconform" step is skipped (`kubeconform=present`).