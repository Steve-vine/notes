---
id: 01M2GDPDMVKSQBFEC434E400J7
created: 2026-09-14T16:58:36.059723Z
updated: 2026-09-14T16:58:47.099837Z
type: task
title: A release publishes linux/arm64 images alongside amd64
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 713
sprint: stek6vx
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
ADR 0073 §10. Both published images are `linux/amd64` only — checked against GHCR for 0.1.0, single-architecture manifests. That excludes Docker Desktop, minikube, kind and Rancher Desktop on Apple Silicon, which is most of the laptops belonging to the people who would try Compass. Until this lands, "anyone with a Kubernetes cluster" means "anyone with an amd64 cluster", and the prerequisites say so.

**Not a chart change** — this is the build and release workflow, and it is the only ADR 0073 item the chart cannot fix. Separable from the rest of the sprint.

**Things to work out**

- Where the arm64 build happens. The trunk build runs on the `compass-runners` scale set on g5 (amd64), so arm64 means QEMU emulation — slow, especially for the frontend's npm build — or an arm64 runner. Worth measuring before choosing.
- ADR 0071 §3 is the constraint that shapes this: a release **copies** the staging-tested images and never rebuilds. So arm64 has to exist in zot at trunk-build time and be copied as part of the same multi-arch index; a release that built arm64 itself would ship a variant staging never ran, which is exactly what §3 exists to prevent.
- Whether arm64 is worth building on every trunk build or only for a release. Building only at release time contradicts §3; building every trunk build costs time on every merge. This is the real decision in the task.

**Acceptance**: `docker manifest inspect ghcr.io/steve-vine/compass/backend:<version>` lists `linux/amd64` and `linux/arm64` for both images; Compass installs and runs on a minikube cluster on Apple Silicon; the prerequisites in ADR 0073 §1 and `chart/README.md` drop the amd64 line.