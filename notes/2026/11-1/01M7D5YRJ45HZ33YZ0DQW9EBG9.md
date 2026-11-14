---
id: 01M7D5YRJ45HZ33YZ0DQW9EBG9
created: 2026-11-14T14:04:06.596224Z
updated: 2026-11-14T15:47:05.068924Z
type: task
title: 'Switching a check back on keeps to its schedule: a quarterly or yearly check that already has this period''s capture waits for the next period instead of collecting at once'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1826
sprint: spsp226
comments:
- id: 01M7D7NDPA0SHCHVMM7CVVA238
  author: Steve Vine
  at: 2026-11-14T14:33:57.706114Z
  text: |-
    Built — PR #1820 (6af2c559), auto-merge on. No migration or API shape change.

    What you now see: switching a collected check back on counts its next capture from its schedule and last capture, the same way changing its schedule does. If the current period already has a capture it waits for the next period — the repro (yearly, captured 6 Nov 2026, switched off and on in November) now reads "next early January 2027 (yearly)", not "next 14 Nov 2026". If the period has no capture, or it has never collected, it collects at the next run (a weekly check last captured three weeks ago collects at once). Same from ⋯ ▸ Switch on, the API, and a batch switch-on on Checks or via Polaris. The confirmation reads "Switch CHK-n on? Compass collects it on its schedule again, counted from its last capture: if this period already has one, it waits for the next."; after switching on the card shows the actual next date.

    Choices: daily/weekly/monthly use the rolling 1/7/30 days since the last capture (as those schedules already run); quarterly/yearly use the calendar quarter/year — so a monthly check captured 20 Oct and switched on 14 Nov waits until 19 Nov. Sending "live" to a check that's already live no longer resets its next capture (before, it jumped to now). The confirmation doesn't name the date (that would need an API field).

    Tests: 18 new unit tests (repro; each schedule with/without a capture in the period; never collected; records checks) + integration (off/on through the API, repeat live, overdue weekly, batch switch-on); unit suite 2397 passed; ruff/mypy/eslint/tsc/prettier clean; drift OK.
- id: 01M7DBVA7CRSD4N2NEB7GAV6M8
  author: Steve Vine
  at: 2026-11-14T15:47:05.068705Z
  text: |-
    Pre-UAT re-check on staging 55b58a1b (E2E Test Company, Admin A): **Passed**.

    CHK-2 Weekly ("next 21 Nov 2026") → Yearly: "next early January 2027 (yearly)". ⋯ Switch off (confirm unchanged) → OFF, ⋯ offers only Switch on, whose confirm now reads "Switch CHK-2 on? Compass collects it on its schedule again, counted from its last capture: if this period already has one, it waits for the next." After switching on: "next early January 2027 (yearly)", same after a reload. Put back to Weekly. Screenshots ~/compass-uat/spsp226/COM-1826/.

    Observation (new small task): back on Weekly the card reads "next 13 Nov 2026" — a past date, meaning "due at the next run", which reads oddly.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What happened

Found in Claude's pre-UAT pass of COM-1815 / COM-1820 on staging 53965a3b (2026-11-14), E2E Test Company. CHK-2 (ACC.13) was Yearly, with captures filed on 6 Nov 2026, so its card read "next early January 2027 (yearly)". It was switched off and back on from the ⋯ menu (COM-1820). Its card then read **"next 14 Nov 2026"**: switching on set the next capture to now, which would give a second capture in the same year, against COM-1815's "captured once per calendar year".

## What people see

- Switching a check back on counts its next capture from its schedule and its last capture, the same way changing the schedule does (COM-1815): if the current period (day / week / month / quarter / year) already has a capture, the next capture is at the start of the next period; if it hasn't, it collects at the next scheduled run.
- So a yearly check captured on 6 Nov, switched off and on in November, reads "next early January 2027 (yearly)"; a weekly check last captured three weeks ago collects at once.
- The switch-on confirmation can say when it will next collect ("Compass collects it again early January 2027").

## Done when

- The repro above reads "next early January 2027 (yearly)" after switching on.
- A check with no capture in the current period collects at the next run after switching on.
- Unit tests cover switching on across daily/weekly/monthly/quarterly/yearly with and without a capture in the current period.

**Independent** unless the switch-on response changes shape. Fix-forward from COM-1815 / COM-1820.