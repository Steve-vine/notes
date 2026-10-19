---
id: 01M5AG9BWSA9X6ZPVR8XZ28GZS
created: 2026-10-19T16:35:32.889753Z
updated: 2026-10-19T18:09:32.167052Z
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
- id: 01M5AJCH9D04DNJ7M0SBRB9NA0
  author: Steve Vine
  at: 2026-10-19T17:12:13.869204Z
  text: |-
    Trial on PR #1113, run 39289295067 (2026-10-19, 16:52 UTC). The mode was forced to `always`; g5 was otherwise quiet.

    - **Billing token:** works in CI. It read 9 hosted minutes and $0.15 of spend.
    - **No-token probe:** answered g5, as it should.
    - **frontend on `ubuntu-latest` (ubuntu-24.04, 2 cores):** 17.4 min, green, 2,469 tests. By step, hosted vs a busy g5 (#1111, three PRs at once):

    | Step | Hosted | Busy g5 |
    |---|---|---|
    | Install | 19 s | 49 s |
    | ESLint | 63 s | 123 s |
    | Type-check | 36 s | 80 s |
    | Prettier | 20 s | 33 s |
    | Vitest | 844 s on 2 workers | 573 s on 4 |
    | Build | 44 s | 93 s |

      - Per unit of work, the hosted core is about 25% faster. Vitest's summed phases were 1,632 s against 2,195 s, but it has only 2 workers.
      - The npm cache restored in 3 s, so it is shared with g5.
    - **Same run on g5 with the frontend job elsewhere:** backend-test took 10.3 min, against 12.9 with g5 alone in #1108.

    **Verdict:** the trial passes for busy periods. Hosted frontend (17.4) beats integration on a busy g5 (19.5–28), and it takes the second-heaviest job's CPU off g5. It would be the slowest job on a quiet g5, so the `auto` rule (≥2 other runs) stands.

    **Budget:** 18 billed minutes per spill, so about 150 spills a month before the 2,700 reserve.

    The trial lines are removed and the default is now `auto`. Auto-merge is on.
- id: 01M5AK8PSQ5TAWAQ89GR6VKQ33
  author: Steve Vine
  at: 2026-10-19T17:27:37.01513Z
  text: |-
    Merged in PR #1113 at 17:25 UTC on 2026-10-19 (main 1336feb8). Main's backstop and build run is green.

    - **Final run (auto mode):** with no other runs, it chose g5 ("it has room"). frontend took 11.1 min and backend-test 12.4, all green. This is the normal path, and also the fallback path.
    - **Fallbacks checked:**
      - In CI, during the trial: a missing token.
      - Locally: a bad token, an unknown mode, `off`, minutes at the reserve, and spend at the budget threshold. Each answered g5.
    - Every PR's `changes` job summary now has a "Where the frontend job runs" table, with minutes against 3,000 and spend against $1.
    - Kill switch: repo variable `FRONTEND_SPILL=off`.
    - ADR 0037 amended.

    **Still open from "Done when":** busy-period run times before and after the change, and minutes used in the first full month. Measure both at the next sprint with ≥2 PRs in flight, and at the start of November.
assignee: steve
label:
- improvement
- follow_up
priority: medium
task_status: done
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