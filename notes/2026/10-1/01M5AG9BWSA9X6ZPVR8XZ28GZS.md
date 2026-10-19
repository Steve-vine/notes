---
id: 01M5AG9BWSA9X6ZPVR8XZ28GZS
created: 2026-10-19T16:35:32.889753Z
updated: 2026-10-19T16:49:44.546716Z
type: task
title: When g5 is busy, the frontend tests run on GitHub's free minutes instead, and never past the monthly allowance
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1124
sprint: sjlj05e
comments:
- id: 01M5AH2VFNY79MAABXNDVVB6NX
  author: Steve Vine
  at: 2026-10-19T16:49:28.053506Z
  text: |-
    Steve's part done 2026-10-19.
    - **Budget:** the Actions budget is $1 with "stop usage", not $0, because October already had $0.15 of storage spend. Storage counts against the same budget, so the job summary should report spend against $1 as well as minutes against 3,000.
    - **Token:** `BILLING_READ_TOKEN` was saved as a repo secret at 16:48 UTC. It is a fine-grained token with org Administration: read and public-repositories access, and it expires in about a year. That it can actually read the usage summary is not yet proven; check that first in the trial run.
assignee: steve
label:
- improvement
- follow_up
priority: medium
task_status: active
---
Sprint 77 follow-up, raised 2026-10-19. **Chain:** independent (CI only, no database or API change).

## Why

The GitHub Team plan includes 3,000 Linux minutes a month on GitHub's standard 2-core runners. October so far: 9 used, all by the release publish job. g5's CPU is the CI ceiling (COM-1089): one PR alone holds it at 88–97%. Sprint 67 round 2 (#1108–#1112, 2026-10-19) measured the effect of the frontend job:
- #1108 had no frontend change: integration took 12.9 min and the whole run 13.5.
- #1109 ran the frontend job: integration took 18.4.
- Three PRs at once: 24–31 min per run, with integration at 19.5–28.

Volume is ~15 PRs a day (~460 a month) at ~40 runner-minutes each, so the allowance cannot carry the suite. A heavy job spilled only at busy times can fit it.

Small jobs (secret-scan, deps-scan, sast, lint) are a poor fit. They use little CPU, and each hosted job is billed rounded up to a whole minute, so 7 jobs × 460 PRs would exceed the allowance.

## What changes

1. **Trial.** One PR runs the `frontend` job on `ubuntu-latest`, with `VITEST_MAX_WORKERS` sized for 2 cores. Record its time and its steps: install from the `npm-*` cache, typecheck, lint, build, Vitest.
   - It must finish no later than integration does on g5 (~13–19 min); otherwise it becomes the new long pole.
   - If it doesn't, stop here and record the numbers.
2. **Busy-time switch.** The `changes` job decides where `frontend` runs and outputs a runner label used by `runs-on`. It picks `ubuntu-latest` when ≥2 other `ci.yml` runs are in progress (Actions API, `actions: read`) **and** the allowance has room; otherwise it picks `compass-runners`.
   - Required check names stay the same; the runner changes, the job doesn't.
   - Check what the job needs from the g5 runner image that `ubuntu-latest` lacks.
3. **Never past the allowance.** The Actions budget goes to $0 with "stop usage" (Steve's part; it is $40 today). At $0 GitHub refuses hosted jobs once the minutes are spent, which would block PRs, so the switch must fall back to g5 first.
   - `changes` reads this month's `actions_linux` minutes from the billing usage summary API: `/organizations/RootCause-IT/settings/billing/usage/summary?product=actions`.
   - It stops spilling at a reserve, e.g. 2,700 of 3,000. That leaves room for releases (`release.yml` publishes from `ubuntu-latest`) and the weekly `sast-full`.
   - Unreadable usage, or a missing token, means g5. Fail safe, never fail the job.
4. **Visibility.** The `changes` job summary says where `frontend` ran and why, with minutes used out of 3,000.

## Steve's part

- **Budget to $0:** Org settings ▸ Billing and licensing ▸ Budgets and alerts ▸ the Actions budget ($40, "stop usage" on) ▸ Edit ▸ $0. Claude's API attempt on 2026-10-19 was refused by the permission check (account settings change), so this one is manual.
- **Billing token:** create a fine-grained token that can read the org's billing usage (organization permission *Administration: read*, to verify against GitHub's docs at the time) and store it as repo secret `BILLING_READ_TOKEN`.

**Done when:**
- The trial numbers are recorded here.
- If the trial passes, the switch spills `frontend` only when g5 is busy and stops at the reserve.
- A run with the token removed falls back to g5 and stays green.
- Measured: busy-period run times before and after, and minutes used in the first full month.