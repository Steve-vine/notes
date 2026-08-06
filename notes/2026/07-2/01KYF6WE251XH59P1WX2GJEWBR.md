---
id: 01KYF6WE251XH59P1WX2GJEWBR
created: 2026-07-26T12:37:31.333374Z
updated: 2026-08-06T08:15:08.888789Z
type: task
title: Widen pytest parallelism (-n 4 → -n 8)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 317
sprint: sr2f21y
comments:
- id: 01KYFCZWRCH1XNF8DB5KQPCJE4
  author: Steve Vine
  at: 2026-07-26T14:24:16.140198Z
  text: |-
    Done — PR #275 (feature/ise-317-pytest-n8), green.

    Bumped backend pytest -n 4 → -n 8 (kept --dist loadscope). Unblocked by ISE-314's guaranteed runner CPU.

    Measured on this PR's backend job: 1254 passed in 209s (0:03:29), 21 warnings, 0 failures — down from the ~293s -n 4 baseline. That's ~29% faster, not a full halving: loadscope pins each integration module to one worker, so the longest single module + setup overhead cap linear scaling, and per-worker Postgres startup is fixed cost. No new flakes (same 1254-test count passes clean).

    Didn't push to -n 12+: with the runner requesting 2 cpu and bursting, more workers risk CPU contention on the shared node and more concurrent Postgres containers for diminishing return. -n 8 is the sweet spot given ISE-314's sizing. The bigger real-world win is under *concurrency* — ISE-314 stops the 6m→41m degradation, and -n 8 shortens each run on top of that.
assignee: steve
priority: medium
task_status: done
---
1254 backend tests run at `pytest -n 4` in **~293s** on a 16-core node. Bump to `-n 8` (keep `--dist loadscope` — several integration modules share DB state and assume in-module ordering). Verify the per-worker session-scoped Postgres containers scale on memory. **Blocked by [[set CPU/memory requests on ise-runners pods]]** — only widen once runner CPU requests guarantee the cores, or it worsens thrash.

Acceptance: pytest step roughly halves with no new flakes.