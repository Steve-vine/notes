---
id: 01M7CPEAP56YCCW9Z7RSBFB0YM
created: 2026-11-14T09:32:59.461253Z
updated: 2026-11-14T09:33:02.58602Z
type: task
title: A check can be collected Quarterly or Yearly as well as daily, weekly and monthly
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1815
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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