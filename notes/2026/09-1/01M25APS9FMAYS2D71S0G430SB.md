---
id: 01M25APS9FMAYS2D71S0G430SB
created: 2026-09-10T09:34:43.503522Z
updated: 2026-09-10T09:44:13.460341Z
type: task
title: 'ADR: production artefacts live on GHCR, public, and are written only by a release'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 650
sprint: stek6vx
comments:
- id: 01M25B85WM45A70K5QK84FQ6H4
  author: Steve Vine
  at: 2026-09-10T09:44:13.460129Z
  text: 'PR #654 open: https://github.com/Steve-vine/compass/pull/654 — ADR 0071 `decisions/0071-a-release-publishes-to-ghcr.md`, 0037/0020 supersession headers, CLAUDE.md key-ADR list.'
assignee: steve
label:
- chore
priority: high
task_status: review
---
Decided 2026-09-10 with Steve; write it down before the workflow lands.

**The decision**

- The production cluster (`env-production-uk-pri`, EKS) pulls from **GHCR, public packages** under Steve's account: `compass/backend`, `compass/frontend` and `compass/chart`. Packages are public; the source repo stays private (package visibility is independent of repo visibility).
- **GHCR is written only by a release.** Trunk builds and staging deploys keep going to zot on g5 (ADR 0037) and change nothing public. A release copies the staging-tested images from zot to GHCR and publishes the chart at the same version — it never rebuilds.
- **A release is a version tag** (`vMAJOR.MINOR.PATCH`) on the commit `staging` points at. A version is published once; a repeat fails. Chart version = app version from here on.
- **No separate repo** for the chart or images: the chart changes in lock-step with the app and is gated by the same PR suite (ADR 0008 monorepo). Helm ≥3.8 OCI charts remove the need for a Pages-hosted index.

**Supersedes** the registry clause of ADR 0037 *for production only* (zot stays the CI/staging registry), and the "GHCR, private" choice of ADR 0020 (now public, and only at release time).

**Consequences to record**: production never depends on g5 being up; anything in the images is publicly readable (built frontend, Python source, dependency list) — accepted; the three packages must be flipped to public by hand once after the first release, because a package created from a private repo is born private.

Deliverable: `decisions/NNNN-*.md`, appended, with 0037 and 0020 marked partly superseded.