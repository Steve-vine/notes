---
id: 01M6R4497MB7DWJ30A8SKSRRMF
created: 2026-11-06T09:48:07.284024Z
updated: 2026-11-06T11:23:23.300591Z
type: task
title: 'ci-runner image: pin Playwright to app/e2e''s version (the Browser smoke broke on the 2.338.2 roll)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1616
assignee: steve
label: null
priority: medium
task_status: backlog
---
`scripts/infra/ci-runner-image/Dockerfile` never defined `PLAYWRIGHT_VERSION`, so `npx playwright@` installed whatever was newest. The COM-1615 rebuild baked chromium_headless_shell-1254, but app/e2e (1.64.1) wants 1248, so every Browser smoke test failed at launch on the staging deploy at 09:46 GMT on 2026-11-06.

Fix: `ARG PLAYWRIGHT_VERSION=1.64.1`, then rebuild, push, bump the values and run `helm upgrade`.