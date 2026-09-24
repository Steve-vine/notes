---
id: 01M2WG1WQSB486A8Q055AAC9VE
created: 2026-09-19T09:30:42.297437Z
updated: 2026-09-24T20:29:39.356563Z
type: task
title: Roll the CI runner image — kubeconform is in the Dockerfile but not yet on the runners
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 725
sprint: stek6vx
comments:
- id: 01M2WZ68RDV60TP0YGKKY5AZ9X
  author: Steve Vine
  at: 2026-09-19T13:55:14.317827Z
  text: |-
    2026-09-19: image `zot.citops.net/compass/ci-runner:2.336.0-20260919-1350` built on g5, verified inside the image (kubeconform v0.8.0, helm v4.2.4, kubectl v1.36.2, regctl v0.11.6, uv 0.11.26, node v22.23.2, python 3.12.3, openapi-typescript 7.13.0), pushed to zot. Tag bump merged as bf2a81c (PR #735). The chart job already skips its kubeconform fetch when the tool is present — no workflow change needed.

    Remaining: Steve runs the `helm upgrade --install compass-runners …` (no `--wait`, no CI in flight); then verify the runner pods report the new image and `command -v kubeconform` inside a live runner; confirm on the next chart job that "Fetch kubeconform" is skipped.
- id: 01M2WZAGSAHM6YPFRR2HNH5EEN
  author: Steve Vine
  at: 2026-09-19T13:57:33.610203Z
  text: Rolled 2026-09-19 13:56 UTC (helm revision 9, run by Steve). Both warm runner pods report `ci-runner:2.336.0-20260919-1350`; the chart job's own detection, exec'd in a live runner, prints `kubeconform=present` (v0.8.0, helm v4.2.4). The "Fetch kubeconform" step will show as skipped on the next PR that touches the chart — COM-729 will be one.
assignee: steve
label:
- chore
priority: low
task_status: done
tech: null
---
**Steve's** — the `helm upgrade` of the runner scale set is classifier-blocked for Claude (see the runner-image-roll notes).

COM-655 added `kubeconform v0.8.0` to `scripts/infra/ci-runner-image/Dockerfile`. Until the image is rebuilt and rolled, every `chart` job falls back to downloading it from GitHub over the g5 uplink — the exact class of fetch the baked image exists to remove, and a likely first thing to flake on a bad-uplink day.

**Do**, on g5: build and push the runner image with a new dated tag (`docker build … scripts/infra/ci-runner-image`, push to `zot.citops.net/compass/ci-runner:<runner-version>-yyyymmdd-hhmm`), set that tag in `scripts/infra/arc-compass-runners-values.yaml`, `helm upgrade` the scale set. Nothing else changed in the image since the last roll (2026-08-29) apart from kubeconform.

**Acceptance**: a `chart` job's "Fetch kubeconform" step is skipped (`kubeconform=present`).