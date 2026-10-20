---
id: 01M5DKGMQABMGTV4BF0WA99A2A
created: 2026-10-20T21:29:40.33007Z
updated: 2026-10-20T21:58:30.124922Z
type: memo
title: 'Projection v1: what it says, what it doesn''t, and the challenges'
project: 01M5DGVQF9WDNP89TXCARSYJ97
category:
- career
scope:
- personal
---
Model: `career/models/retirement-projection-v1.xlsx` (built 20 Oct 2026). Real terms, 2.5% real growth after fees, six scenarios, ages 55–90. Yellow cells are placeholders; v1 shows the shape, not the answer.

**Headline results (placeholders included: £45k target, wife £25k net while working then £10k pension from 65, mortgage £12k/yr to 64, half of surplus saved)**

| Scenario | Pots at 60 | Pots at 65 | Pots at 90 | Max affordable (solver) |
|---|---|---|---|---|
| A: FT to 65, stop | £500k | £712k | £842k | £60k/yr |
| B: FT to 60, consult 60–65 @£40k | £463k | £513k | £473k | £53k/yr |
| C: CISO £140k @57, FT to 62, consult to 66 | £546k | £739k | £893k | £61k/yr |
| D: stop fully at 60 | £425k | £312k | £112k | £47k/yr |
| E: as A, 1.0% real | £470k | £633k | £426k | £55k/yr |
| F: as A, 4.0% real | £533k | £800k | £1.54m | £66k/yr |

**Affordability solver (added 20 Oct 2026, sheets "Afford A"–"Afford F")**
Re-runs each scenario for every household income target from £30k to £90k in £1k steps and reports the highest one with no shortfall year and at least `reserve_90` (default £0) left at 90. Cross-checked: setting the fixed target to the solver answer leaves a few £k at 90; one step higher produces a shortfall. "Max affordable" is household net spending in today's money, excluding mortgage, with the pots run down to nothing by 90. It is a ceiling, not a recommendation: a plan that spends to zero at 90 has no buffer for a bad decade, care costs or living past 90. Set reserve_90 to £150k and re-read the line for a more defensible number.

**What it says**
1. The plan is feasible at the £45k level *provided* the surplus is actually saved. The single biggest lever is not the job title, it is the savings rate between now and 60. At £110k + wife's pay, the household has roughly £35k/yr net above a £45k spend + £12k mortgage. Where is that going today? If it is being spent, the retirement target is really higher than £45k and the whole model shifts.
2. The crunch is 60 to 67: the gap years before State Pension (and before the wife's pension) have to be funded entirely from the pots. Every year of part-time income in that window is worth roughly £25–30k of pot.
3. Stopping dead at 60 (D) caps the household at ~£47k with nothing left at 90. Treat as a floor, not a plan.
4. Returns matter more than a CISO step-up: E vs F is an £11k/yr spread in affordable income. The step-up (C vs A) adds ~£1k/yr. The job move is worth doing for other reasons (consulting credibility, pay base, enjoyment), not as the retirement plan.
5. The £45k target vs the £60k ceiling in A is the room to trade: retire earlier, spend more, or keep a buffer. That is the decision Sprint 2 has to make, with real inputs.

**What it doesn't do (v1 limits)**
- Wife's NHS pension is a placeholder. DB, inflation-linked, possibly with a 1995/2008 section lump sum. It could be the most valuable asset in the household and it is modelled as £10k.
- Tax on drawdown is a flat 15% simplification; no sequencing of ISA vs pension; no tax-free lump sum strategy.
- Consulting income is taxed as PAYE; a limited company changes NI, allows company pension contributions and dividend planning.
- No care costs, no inheritance intent for the son, no downsizing of the house (£500k equity is a real option, not in the model).
- No State Pension age 68 case yet (set Assumptions!spa to 68 to see it).
- Son's university costs 2028–2031 are not in the spending line.

**Challenges to Steve**
- £35k–£50k: is that *after* mortgage, and does it include running two cars, holidays, helping your son? Pensions UK "Moderate" for a couple is £45,400 and "Comfortable" £62,700 (2025, after tax, home owned outright). Someone on £110k rarely drops to Moderate happily. Do a real 12-month spend before anchoring on £45k.
- Clearing the £100k mortgage before 60 removes the biggest fixed cost from the gap years. Overpayment vs pension contribution is a genuine trade-off (40% relief vs ~4% guaranteed) that needs the mortgage rate to settle.
- 12% total pension contribution at 55 with £194k in pensions is low for a £110k earner who wants to stop at 60–65. Carry-forward of unused annual allowance from the last three tax years may allow a large one-off top-up.

Next: Sprint 1 replaces the placeholders; v2 of the model follows.