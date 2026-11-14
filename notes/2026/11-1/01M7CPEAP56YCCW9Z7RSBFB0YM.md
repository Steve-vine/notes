---
id: 01M7CPEAP56YCCW9Z7RSBFB0YM
created: 2026-11-14T09:32:59.461253Z
updated: 2026-11-14T14:03:12.04477Z
type: task
title: A check can be collected Quarterly or Yearly as well as daily, weekly and monthly
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1815
sprint: spsp226
comments:
- id: 01M7CX58G5PG2Q717EXTBATTPV
  author: Steve Vine
  at: 2026-11-14T11:30:22.341399Z
  text: |-
    Built — PR #1811 (1781ce48). API change, no migration (the stored schedule is free text); ADR 0142 and 0153 amended (2026-11-14). Merges after COM-1817 on the chain.

    What you now see:
    - The picker reads Daily · Weekly · Monthly · Quarterly · Yearly on the Review card and in a live check's settings (one shared list, so it follows the picker wherever COM-1820 puts it).
    - A quarterly check is captured once per calendar quarter, on the first scheduled run after the quarter starts; yearly once per calendar year. Collect now works any time and counts for the quarter/year it falls in. A failed run is retried hourly until the period has a capture. Records checks collect the whole quarter/year once it has ended.
    - The check's card reads "next early April 2026 (quarterly)".
    - Not out of date in between: a collected capture stays current until its next capture is due, plus a week — in the Evidence register, the control's Evidence tab and audit packs. (Coverage and Checks Overview never flagged staleness.)
    - Polaris can propose Quarterly/Yearly when designing, and change a live check's schedule in chat (changes at once, no Review, recorded in history); it now says when the next capture is.

    Choices: hourly retry within the period; a week's grace after the next capture is due (a longer evidence-type validity still applies, a hand-set valid-until is left alone); currency of an unchanged snapshot counts from "still true on" (this also applies to daily/weekly/monthly — it can only make evidence current longer); changing a live check's schedule recounts from its last capture (captured 2 Nov, made quarterly → next due 1 Jan). The batch preview has no schedule default today, so nothing to add there.

    Tests: new unit tests for next-due across quarter/year boundaries, retry within period, rescheduling and staleness; new integration tests (6) + neighbouring files (34) pass; unit suite 2348 passed; ruff/mypy/eslint/tsc/prettier clean; schema.d.ts regenerated.

    For Steve on staging: set a check to Quarterly → card reads "next early … (quarterly)"; ask Polaris to make a check yearly → changes without going to Review.
- id: 01M7D5X39C5JZYZKHB552DK56N
  author: Steve Vine
  at: 2026-11-14T14:03:12.044205Z
  text: |-
    Pre-UAT on staging 53965a3b (E2E Test Company): **Passed** for the pickers, next date and Polaris; one defect (switching on) → fixed forward in a new task; staleness/Collect now **Couldn't check**.

    Passed: both pickers (CHK-3 Review card, CHK-2 Details "Collected: … · Change") read Daily · Weekly · Monthly · Quarterly · Yearly. CHK-2 set to Quarterly on screen: card "last collected 6 Nov 2026, 12:21 · next early January 2027 (quarterly)" (captured in Q4 → next Q1); didn't go to Review; Activity "Schedule: Weekly → Quarterly". Polaris (schedule=yearly) changed it at once and said "next capture early January 2027 (yearly)… a schedule doesn't wait for review"; Activity "Quarterly → Yearly" via Polaris.

    Defect: switching a yearly check off and on set its next capture to now ("next 14 Nov 2026"), although it already has captures from 6 Nov this year — a second capture in the same year, against "once per calendar year". Expected "next early January 2027 (yearly)".

    Couldn't check: Collect now counting for its period (CHK-2 is broken), staleness over weeks/months (time-based; unit tests cover it). Restored: CHK-2 back to Weekly (its next due recounted from the 6 Nov capture to 13 Nov, already past). Screenshots ~/compass-uat/spsp226/COM-1815/.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## What happened

On 2026-11-14, while testing Checks, Steve asked for **Quarterly** and **Yearly** to be added to a check's collection period. Today the choice is Daily, Weekly or Monthly. Some evidence only needs to be shown once a quarter or once a year (an access review, an annual policy sign-off, a yearly DR test record), and collecting it monthly just adds noise.

## What people see

1. **Two more choices.** Wherever a check's collection period is chosen (the review page, a live check's settings, the batch preview's default, and Polaris proposing or changing a check), the list reads Daily · Weekly · Monthly · **Quarterly** · **Yearly**.
2. **When it runs (my call; Steve can overrule).** A quarterly check is captured once in each calendar quarter (Jan–Mar, Apr–Jun, Jul–Sep, Oct–Dec), on the first scheduled run after the quarter starts. A yearly one is captured once per calendar year, the same way. The check's page says "Next capture: early April 2026 (quarterly)". **Collect now** still works any time, and a manual capture counts for the period it falls in. If a run fails, it's retried within the same period, as today, so a quarter isn't left empty just because one day failed.
3. **Not "out of date" in between.** A quarterly check's last capture counts as current until that quarter's capture is due, and a yearly one until next year's. Coverage, the Checks Overview, the control's Evidence tab and audit packs mustn't flag it as stale after a month, as they would for a monthly check.
4. **Polaris** can propose Quarterly or Yearly when that suits the evidence, and can change a check to either in chat.

## Rules

- Changing the period of a live check doesn't send it back to Review. It's recorded in the check's history, as a period change is today.
- An audit pack for a period uses the captures that were current in it, as now. A quarterly check gives one capture per quarter.

## Done when

- Quarterly and Yearly can be chosen on screen and through Polaris, and the next capture date reads correctly for both.
- A quarterly check runs once per calendar quarter, and a yearly one once per calendar year. Collect now works and counts for its period.
- A quarterly check captured in January isn't shown as out of date in February or March, and a yearly one isn't shown as out of date mid-year.
- There are tests for the next-due dates across quarter and year boundaries, retry within the period, and staleness for both.

**On the chain** (the API's list of periods changes; a migration only if the stored value is constrained).