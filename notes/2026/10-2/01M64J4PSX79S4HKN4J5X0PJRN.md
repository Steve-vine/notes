---
id: 01M64J4PSX79S4HKN4J5X0PJRN
created: 2026-10-29T19:28:12.605047Z
updated: 2026-10-29T19:51:09.828627Z
type: task
title: CI checks run on Blacksmith — every PR check, the trunk backstop and the weekly scan move off g5 to Blacksmith's cloud runners; g5 keeps only building images, deploying to staging and the release
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1453
comments:
- id: 01M64KEQ4HCG3B2AYPXDDFGR3T
  author: Steve Vine
  at: 2026-10-29T19:51:09.201655Z
  text: |-
    Merged 2026-10-29 19:49 GMT — PR #1452, squash a047eee4.

    PR run 40941093038, every job on Blacksmith, all green:
    - backend-test 12.0 min on 16 vCPU (4,357 passed, none skipped; Samba image built in 17 s; test images pulled in 21 s)
    - frontend 9.5 min on 8 vCPU (was ~22 on g5)
    - backend-unit 5.6 min, backend-static 1.8, deps-scan 1.3; changes, secret-scan, chart, migrations, sast 12–22 s each
    - Wall clock about 13 min.

    Already passed (COM-1105): a rerun of the same run skipped all six skippable jobs and finished in about 1.5 min — the cache-lookup path works on Blacksmith.

    First main push (run 40943401852): backstop 103 s and warm-caches 106 s on Blacksmith; build-tag and both build-images legs on compass-runners — all green.

    Left: shrink the g5 scale set (maxRunners 4 → 2) after a few days green — Steve's helm upgrade. Ask Blacksmith for eu-west once off the trial. BILLING_READ_TOKEN secret and FRONTEND_SPILL variable can be deleted from the repo settings.
assignee: steve
label:
- improvement
priority: high
task_status: review
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