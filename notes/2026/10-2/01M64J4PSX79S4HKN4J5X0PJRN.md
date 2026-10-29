---
id: 01M64J4PSX79S4HKN4J5X0PJRN
created: 2026-10-29T19:28:12.605047Z
updated: 2026-10-29T19:28:12.605047Z
type: task
title: CI checks run on Blacksmith — every PR check, the trunk backstop and the weekly scan move off g5 to Blacksmith's cloud runners; g5 keeps only building images, deploying to staging and the release
label: improvement
assignee: steve
priority: high
task_status: active
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1453
---
Before sprint 98. ADR 0136 (amends ADR 0037 and its COM-1124 amendment). Steve, 2026-10-29: Blacksmith account set up, app installed on RootCause-IT; option 1 — checks on Blacksmith, build/deploy/release stay on g5.

## What Steve sees

- A PR's checks start at once and don't slow down when another PR is running. Two PRs at once used to take 23–26 minutes each on g5; each now takes about what one took alone, or less.
- Nothing changes about merging, deploying to staging or releasing. The check names on a PR are the same.
- g5 stops being pinned at 90%+ CPU by CI, so local work and the staging site stay responsive while PRs run.
- Cost: Blacksmith bills per minute (about $200–300 a month expected at current volume; measure the first week).

## Why only the checks

Blacksmith's machines are in a data centre and can't reach g5's network: the image registry (zot) and staging both resolve to 192.168.1.5. Building images, deploying staging and the release step all need that network, so they stay on g5. Moving them is a separate decision (images to GHCR, deploy over Twingate) and not part of this task.

## Notes (technical)

- Jobs to Blacksmith (`runs-on: blacksmith-*-ubuntu-2404`): changes, backend-static, backend-unit, backend-test (16 vCPU), frontend (8 vCPU), secret-scan, deps-scan, sast, migrations, chart, backstop, warm-caches; auto-rerun.yml; sast-full.yml. Stay on `compass-runners`: build-tag, build-images, deploy-staging, release.yml `prepare`.
- The custom runner image isn't available there (it's in zot). A composite action `.github/actions/toolchain` sets up uv (pinned to the runner image's version), Node from .nvmrc, and apt-installs the Kerberos headers (gssapi) and Pango/HarfBuzz (WeasyPrint). Blacksmith VMs allow sudo. kubeconform, openapi-typescript and semgrep already have fallbacks.
- Test images come from Docker Hub (Blacksmith caches pulled images for free) instead of zot. The Samba AD test image is built in the job from `scripts/infra/test-images/samba-ad-dc` with Blacksmith's Docker layer cache and tagged with the name the tests expect.
- Blacksmith serves `actions/cache` from its own store, which GitHub's cache-list API can't see. So the "already passed" lookup (COM-1105) changes from an API listing to `actions/cache/restore` lookups in the `changes` job; `scripts/ci/already-passed.py` keeps the output shape and the summary table.
- The frontend spill to GitHub-hosted runners (COM-1124) is removed: `scripts/ci/frontend-runner.py`, the `frontend_runner` output, the BILLING_READ_TOKEN use and the FRONTEND_SPILL variable.
- Blacksmith org region is US West (free trial; can't change yet). Ask support for eu-west once on a paid plan.
- After it has run green for a few days: shrink the ARC scale set (maxRunners 4 → 2) — Steve runs the helm upgrade.

**Chain:** independent (CI only — no migration, no API change).

**Done when:**
- the PR's own run is green with every check on Blacksmith (it touches .github/workflows, so every job runs);
- the first push to main after merge runs the backstop and warm-caches on Blacksmith and the image build on g5, both green;
- a restacked PR skips the jobs it already passed (COM-1105 still works);
- ADR 0136 is in `decisions/` and CLAUDE.md lists it.