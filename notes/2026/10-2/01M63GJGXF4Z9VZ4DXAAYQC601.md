---
id: 01M63GJGXF4Z9VZ4DXAAYQC601
created: 2026-10-29T09:41:33.743329Z
updated: 2026-10-29T09:41:33.743329Z
type: task
title: Deep smoke after every staging deploy — the scripted journeys run once the deploy's health checks pass; a failure turns the deploy red with screenshots attached, and nothing is rolled back
priority: medium
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1450
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
- Update the CI summary in `CLAUDE.md` and ADR 0041's description of push → staging: "promotes, deploys, smoke-checks, then runs the browser smoke".

**Chain:** independent (CI only).

**Done when:**
- a real staging deploy runs the step green, with its report attached;
- the step has been seen to turn red, with screenshots, when a journey is made to fail (via a manual run of the step).