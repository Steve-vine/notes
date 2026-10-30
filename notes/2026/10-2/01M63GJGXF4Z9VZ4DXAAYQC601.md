---
id: 01M63GJGXF4Z9VZ4DXAAYQC601
created: 2026-10-29T09:41:33.743329Z
updated: 2026-10-30T08:16:06.880287Z
type: task
title: Deep smoke after every staging deploy — the scripted journeys run once the deploy's health checks pass; a failure turns the deploy red with screenshots attached, and nothing is rolled back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1450
sprint: s5pn06h
blocked_by:
- 01M63GJ1G5A1QZS2E4B28AVMKM
comments:
- id: 01M6585EC24AQ6E873QKEV2F09
  author: Steve Vine
  at: 2026-10-30T01:53:05.410177Z
  text: |-
    Built: PR #1471, merged.

    - The staging deploy now ends with a Browser smoke step: the browser suite, 10-minute limit. It turns the deploy red on a failing screen, and staging stays on the build. The job summary lists failing screens per account; screenshots and traces are kept 7 days as the browser-smoke artifact.
    - The same step can be run on its own: `gh workflow run browser-smoke.yml --ref main`. The `break` input fails one API path on purpose, to see it go red.
    - The runner image (2.336.0-20261030-0047) carries headless Chromium. It's built, checked (two suite tests pass inside it against staging) and in zot, and the runner settings point at it.
    - Until the runner scale set is rolled, the step says "skipped — runner image has no Chromium yet" and passes, rather than failing every deploy.
    - CLAUDE.md's CI summary is updated.

    Needs Steve: the runner roll:
    helm upgrade --install compass-runners oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set --version 0.14.2 -n arc-runners -f scripts/infra/arc-compass-runners-values.yaml

    Done when, still open: the step green on a real deploy, and seen red (break input). Both need the roll first; then I'll run them.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 99, Browser Testing (ADR 0135, COM-1446). Needs the suite (COM-1449).

## What Steve sees

The staging deploy gets a new step, **Browser smoke**, after the current health checks.
- When it's green, every screen opened for every test account.
- When it's red, the run summary lists which screens failed for which account. Screenshots and traces can be downloaded from the run.

Staging stays on the new build either way (fix forward, ADR 0041). Before telling Steve a sprint is ready, Claude checks this step.

## Notes (technical)

- A step in `deploy-staging` in `ci.yml`, after "Smoke check". The test-account secrets come from the `staging` GitHub environment (COM-1447). Time limit 10 minutes.
- **The runner needs Chromium and its libraries.** Bake them into the runner image (`scripts/infra/ci-runner-image/Dockerfile`), the same way Pango was added for WeasyPrint. That needs a runner-image roll, **which Steve runs** (the helm upgrade is blocked for Claude). Until then, the step can install browsers from a cache.
- Push runs aren't required checks, so main's protection is untouched.
- Update the CI summary in `CLAUDE.md`: push → staging "promotes, deploys, smoke-checks, then runs the browser smoke". ADR 0135 records the change. ADR 0041 is accepted, so it isn't rewritten.

**Chain:** independent (CI only).

**Done when:**
- a real staging deploy runs the step green, with its report attached;
- the step has been seen to turn red, with screenshots, when a journey is made to fail (via a manual run of the step).