---
id: 01M6R4497MB7DWJ30A8SKSRRMF
created: 2026-11-06T09:48:07.284024Z
updated: 2026-11-06T11:57:32.494628Z
type: task
title: 'ci-runner image: pin Playwright to app/e2e''s version (the Browser smoke broke on the 2.338.2 roll)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1616
comments:
- id: 01M6RBH6N1HA2M37Q99HTGZWW3
  author: Steve Vine
  at: 2026-11-06T11:57:30.657548Z
  text: |-
    Done: PR #1631 merged. The image is `zot.citops.net/compass/ci-runner:2.338.2-20261106-0948`, with Chromium build 1248.
    - Steve ran the helm upgrade at 10:40 GMT.
    - The Browser smoke re-run on staging (run 42204580336) passed: 26 passed in 6.2 minutes.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
`scripts/infra/ci-runner-image/Dockerfile` never defined `PLAYWRIGHT_VERSION`, so `npx playwright@` installed whatever was newest. The COM-1615 rebuild baked chromium_headless_shell-1254, but app/e2e (1.64.1) wants 1248, so every Browser smoke test failed at launch on the staging deploy at 09:46 GMT on 2026-11-06.

Fix: `ARG PLAYWRIGHT_VERSION=1.64.1`, then rebuild, push, bump the values and run `helm upgrade`.