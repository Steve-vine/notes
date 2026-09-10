---
id: 01M25AQ58J5128F6AZMKGWV4NC
created: 2026-09-10T09:34:55.762017Z
updated: 2026-09-10T10:06:49.66129Z
type: task
title: 'Create a release: the images tested on staging are copied to GHCR under a version, once'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 651
sprint: stek6vx
blocked_by:
- 01M25APS9FMAYS2D71S0G430SB
comments:
- id: 01M25BQFBZ6HK0YM2Z95PT228V
  author: Steve Vine
  at: 2026-09-10T09:52:34.687257Z
  text: 'PR #655 open: https://github.com/Steve-vine/compass/pull/655 — `.github/workflows/release.yml` (guards: tag == staging head; staging release digest == commit build digest; version unpublished; crane copy zot → GHCR with retries; GitHub Release via github-script), crane baked into the runner image with a download fallback, README "Cut a release", ci.yml header. Guard 2 verified by hand against zot (staging-20260910-0846 vs 6492247: digests identical for both images). GHCR login/copy/Release only exercised by the first real tag.'
- id: 01M25CHJ9XNS4S43WV7XBCTHGP
  author: Steve Vine
  at: 2026-09-10T10:06:49.660946Z
  text: 'Merged: PR #655 → main d52aa81. Not yet exercised end to end: the first real tag (0.1.0) waits on COM-652 so the release carries the chart too. Runner image roll to bake crane in is pending; the workflow''s download fallback covers it until then.'
assignee: steve
label:
- feature
priority: high
task_status: done
---
Steve pushes a version tag (`v0.1.0`) and Compass's two images appear on GHCR, public, under that version — byte-identical to what ran on staging. Nothing is built.

**Tag format, decided 2026-09-10**: git tag `vX.Y.Z`; image tag and chart version are the bare `X.Y.Z` (Helm needs bare semver; one number everywhere). Each image also gets its short-SHA tag. `latest` never. First release: `0.1.0`.

**What happens**

1. A `release.yml` workflow runs on `push: tags: v*` (runner: `compass-runners`, so zot is reachable).
2. **Guard**: the tagged commit must equal `origin/staging`'s head — "tested in staging" is enforced, not remembered. Otherwise fail with a message saying to move `staging` first.
3. **Guard**: `ghcr.io/steve-vine/compass/backend:<X.Y.Z>` must not already exist — a version is published once; a mistake becomes the next patch.
4. **Copy** `zot.citops.net/compass/{backend,frontend}:<short-sha>` → `ghcr.io/steve-vine/compass/{backend,frontend}:<X.Y.Z>` (also tag `:<short-sha>`). Cross-registry copy, not a rebuild: `crane copy` / `regctl image copy` / `skopeo` (pick one that is in, or easily added to, the runner image — `scripts/infra/ci-runner-image/Dockerfile`; a `docker buildx imagetools create` cross-registry copy is the fallback). Login to GHCR with `GITHUB_TOKEN` (`permissions: packages: write`). Same retry loop as the trunk build — the g5 uplink to ghcr.io is the one that flakes.
5. **GitHub Release** created from the tag: version, commit, the staging tag it was tested as, and the package references. `gh release create` with `contents: write`.
6. Step summary lists the three package refs.

**Rules carried over**: immutable tags only, never `latest` (ADR 0008); the chart publish (next task) runs in this same workflow.

**Docs**: `chart/README.md` gains a "Cut a release" section — the three commands (check staging, tag, push tag) and the one-off "make the packages public" step after the first release. Update the `ci.yml` header comment to point at `release.yml`.

**Acceptance**: `git tag v0.1.0 <staging head> && git push origin v0.1.0` produces `backend:0.1.0` and `frontend:0.1.0` on GHCR and a GitHub Release; a second push of the same version fails at the guard; tagging a non-staging commit fails at the guard; after Steve flips visibility, `docker pull ghcr.io/steve-vine/compass/backend:0.1.0` works anonymously from a machine off the LAN.