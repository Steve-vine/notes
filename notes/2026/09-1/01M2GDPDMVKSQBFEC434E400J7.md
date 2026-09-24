---
id: 01M2GDPDMVKSQBFEC434E400J7
created: 2026-09-14T16:58:36.059723Z
updated: 2026-09-24T21:00:32.966451Z
type: task
title: A release publishes linux/arm64 images alongside amd64
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 713
sprint: stek6vx
comments:
- id: 01M2GSPJCTXVE08W5SPPFSMSE9
  author: Steve Vine
  at: 2026-09-14T20:28:23.834257Z
  text: |-
    Merged to main 2026-09-14 20:17 as d8e6b7b (PR #717). Decision taken: arm64 is built on every trunk build (not at release) so the release copies the same index staging ran (ADR 0071 §3); release.yml gains a guard refusing any index that is not exactly linux/amd64 + linux/arm64. QEMU is registered per job by docker/setup-qemu-action from zot (`compass/tools/binfmt:qemu-v10.2.3`, copied in once — dind has no mirror and zot's sync allow-list excludes tonistiigi/*). Frontend build stage pinned to $BUILDPLATFORM (bundle is arch-independent); backend deliberately emulated.

    First multi-arch trunk build (run 34892103502): frontend 1 m 35 s, backend 8 m 39 s cold — the uv and LibreOffice layers are now in the zot cache, so routine merges should be back near previous times. Verified in zot: `compass/backend:d8e6b7b` and `compass/frontend:d8e6b7b` each list linux/amd64 + linux/arm64. chart/README and ADR 0073 §1 drop the amd64-only line; §10 has a landed note.

    Still open (needs the 0.2.0 release): `docker manifest inspect ghcr.io/steve-vine/compass/backend:0.2.0` listing both, and a run on an Apple Silicon minikube — Steve's to try once 0.2.0 is out.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
ADR 0073 §10. Both published images are `linux/amd64` only — checked against GHCR for 0.1.0, single-architecture manifests. That excludes Docker Desktop, minikube, kind and Rancher Desktop on Apple Silicon, which is most of the laptops belonging to the people who would try Compass. Until this lands, "anyone with a Kubernetes cluster" means "anyone with an amd64 cluster", and the prerequisites say so.

**Not a chart change** — this is the build and release workflow, and it is the only ADR 0073 item the chart cannot fix. Separable from the rest of the sprint.

**Things to work out**

- Where the arm64 build happens. The trunk build runs on the `compass-runners` scale set on g5 (amd64), so arm64 means QEMU emulation — slow, especially for the frontend's npm build — or an arm64 runner. Worth measuring before choosing.
- ADR 0071 §3 is the constraint that shapes this: a release **copies** the staging-tested images and never rebuilds. So arm64 has to exist in zot at trunk-build time and be copied as part of the same multi-arch index; a release that built arm64 itself would ship a variant staging never ran, which is exactly what §3 exists to prevent.
- Whether arm64 is worth building on every trunk build or only for a release. Building only at release time contradicts §3; building every trunk build costs time on every merge. This is the real decision in the task.

**Acceptance**: `docker manifest inspect ghcr.io/steve-vine/compass/backend:<version>` lists `linux/amd64` and `linux/arm64` for both images; Compass installs and runs on a minikube cluster on Apple Silicon; the prerequisites in ADR 0073 §1 and `chart/README.md` drop the amd64 line.