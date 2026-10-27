---
id: 01M5ZS0X29JCE1BDWFRAY19R7M
created: 2026-10-27T22:52:15.817949Z
updated: 2026-10-27T22:52:15.817949Z
type: memo
title: 'Retirement tracker: how it works and what it says today'
category: career
scope: personal
project: 01M5DGVQF9WDNP89TXCARSYJ97
---
Built 27 Oct 2026 at Steve's request: `career/models/retirement-tracker.xlsx` (script `models/scripts/build_tracker.py`). Simpler companion to the scenario model: one target, one required line, one actual line.

**Inputs (yellow):** Steve's monthly pension contribution (gross, salary sacrifice), employer contribution, monthly ISA saving, Steve's retirement age, Lesley's retirement age, target joint net income in retirement (excl. mortgage), pot to leave at 90. Secondary inputs (growth, State Pensions, Lesley's NHS pensions and pay, mortgage, tax) are below and rarely change.

**Line 1, pot needed at the end of each year.** Built backwards from age 90: the pot must end at the reserve, and each earlier year must hold enough that after that year's growth, planned savings and withdrawals, the next year's requirement is met. Before retirement the line rises as savings accumulate; it peaks the year before Steve retires, then falls as the pot is drawn down.

**Line 2, actual pot.** Enter pension + ISA totals each October. The chart plots both with a straight-line trend through the actuals. "Ahead / (behind)" and "extra saving per year needed" turn the gap into an action: the shortfall at the latest entry, spread over the remaining working years at the growth rate.

**What it says today (£50k target, Steve 65, Lesley 60, £150k at 90, 2.5% real, current contributions £13.2k/yr, no ISA saving):**
- Pot needed at 65: £523k. Pot needed today to be on track: £333k. Actual: £223k. Behind by £109k.
- Extra saving needed: ~£12.5k/yr, ~£1,040/month, for the next ten years.
- That is almost exactly the £1,000/month extra salary sacrifice proposed in "Where the £1,000 a month should go" (gross into the pension, ~£560/month net cost). The two analyses agree.
- Cross-check against the scenario model: scenario A's £612k at 65 supports £54k; the tracker's £523k supports £50k; the difference is the cost of £4k/yr for 25 years. Consistent.

**Limits.** Flat target for life; no part-time income after Steve's retirement age (use the scenario model for that, or lower the target for those years); withdrawals grossed up at 15% as if all from pension; James's university costs and a State Pension age of 68 not included.