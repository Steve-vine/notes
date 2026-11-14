---
id: 01M7DANKYY4FGQ2JYPM9Q57YJ8
created: 2026-11-14T15:26:29.854898Z
updated: 2026-11-14T16:03:15.276457Z
type: task
title: 'The staging Browser smoke step gets 15 minutes: it now takes ~10 and timed out after all 32 tests had passed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1827
sprint: spsp226
comments:
- id: 01M7DCRPY810AFBBP6DM1JNSA3
  author: Steve Vine
  at: 2026-11-14T16:03:08.359954Z
  text: 'Done — PR #1822 merged. The staging deploy''s Browser smoke step now has 15 minutes (ci.yml), and the dispatched Browser smoke job 17 (browser-smoke.yml). The next staging deploy will confirm it stays green; I''ll note it on the round''s final deploy.'
assignee: steve
label:
- chore
priority: medium
task_status: review
---
## What happened

On 2026-11-14 the staging deploy run 43607357876 (a406328a) went red: its Browser smoke step reported "32 passed (10.0m)" and then "The action has timed out" — the step's `timeout-minutes: 10` in `.github/workflows/ci.yml` (deploy-staging job) was hit just as the suite finished. The next run (43608752450, 55b58a1b) passed in 9.9 m. screens.spec.ts alone takes ~7.6 m; round 8 added two smoke steps (COM-1813 a review item, COM-1817 a no-rule check), which pushed the suite to the limit.

## Change

Raise the Browser smoke step's timeout to 15 minutes in ci.yml (and in browser-smoke.yml if it sets one), so a passing suite isn't reported red. Splitting screens.spec.ts to run in parallel is a later improvement, not this task.

## Done when

- The step's timeout is 15 minutes; the next staging deploy's smoke is green.

**Independent** (CI only).