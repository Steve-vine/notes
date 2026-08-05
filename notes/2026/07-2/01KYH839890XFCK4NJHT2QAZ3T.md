---
id: 01KYH839890XFCK4NJHT2QAZ3T
created: 2026-07-27T07:37:13.225678Z
updated: 2026-08-05T12:31:46.285464Z
type: task
title: Stale alert banner
project: 01KX671DATY39VW6GWK3M2T3DN
number: 324
sprint: sak4nk6
comments:
- id: 01KYHX6FKWCSGPTK5X0SMBTEAR
  author: Steve Vine
  at: 2026-07-27T13:45:58.140713Z
  text: |-
    Done — PR #301 (feature/ise-324-stale-2min), stacked on ISE-323.

    STALE_AFTER_MS raised 90s → 120s so the stale banner trips at 2 minutes. The evaluator beat is ~30s, so 2 min = four missed ticks (a real stall) without a jittery evaluator flashing the banner. Test boundaries moved to the 2-min line (1 min still fresh, 3 min stale).

    Local gates green: build/lint/prettier + FE tests. Moving to Review.
assignee: steve
priority: medium
task_status: done
---
Currently the stale alert banner seems to display around 1 minute, change this to stale at 2 minutes.