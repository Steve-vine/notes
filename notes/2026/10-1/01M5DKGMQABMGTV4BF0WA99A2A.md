---
id: 01M5DKGMQABMGTV4BF0WA99A2A
created: 2026-10-20T21:29:40.33007Z
updated: 2026-10-21T21:58:31.049937Z
type: memo
title: 'Projection v1: what it says, what it doesn''t, and the challenges'
project: 01M5DGVQF9WDNP89TXCARSYJ97
category:
- career
scope:
- personal
---
Model: `career/models/retirement-projection-v1.xlsx` (built 20 Oct 2026, Lesley's real figures added 21 Oct). Real terms, 2.5% real growth after fees, six scenarios, ages 55–90. Yellow cells are placeholders; v1 shows the shape, not the answer.

**Headline results (21 Oct 2026: Lesley net £16,700 to 60, then NHS 1995 £4,811 + £14,432 cash at 60, 2015 £4,600 and State Pension from 67. Still placeholders: £45k target, mortgage £12k/yr to 64, half of surplus saved. Solver reserve £150k at 90.)**

| Scenario | Pots at 60 | Pots at 65 | Pots at 90 | Max affordable (solver) |
|---|---|---|---|---|
| A: FT to 65, stop | £465k | £615k | £521k | £51k/yr |
| B: FT to 60, consult 60–65 @£40k | £424k | £379k | £98k | £44k/yr |
| C: CISO £140k @57, FT to 62, consult to 66 | £510k | £642k | £570k | £52k/yr |
| D: stop fully at 60 | £385k | £173k | £0 (runs out at 75) | £37k/yr |
| E: as A, 1.0% real | £435k | £541k | £197k | £46k/yr |
| F: as A, 4.0% real | £497k | £698k | £1.08m | £57k/yr |

Earlier placeholder run (Lesley £25k net, £10k pension from 65) showed A £57k, D £44k: her real income and age-60 retirement cost the household £6–7k/yr of affordable spending.

**Affordability solver (sheets "Afford A"–"Afford F")**
Re-runs each scenario for every household income target from £30k to £90k in £1k steps and reports the highest one with no shortfall year and at least `reserve_90` (£150k) left at 90. Cross-checked against the main model. "Max affordable" is household net spending in today's money, excluding mortgage.

**What it says**
1. The hardest stretch is Steve 62 to 69: Lesley has stopped (2033), her 1995 pension is only £4.8k, and nothing else arrives until Steve's State Pension at 67 and hers at 69 (Steve's age). The peak draw from the pots is £40k/yr in those years. Every year either of them keeps earning in that window is worth £15–30k of pot.
2. Stopping dead at 60 (D) no longer works: pots exhausted at 75 on a £45k target; ceiling £37k. Not a plan.
3. Scenario A at £51k is feasible but only ~£6k above the £45k placeholder target. The margin is thin and depends on half the current surplus actually being saved. That is the Sprint 2 decision.
4. Returns still dominate the CISO question: E vs F is £11k/yr; the step-up (C vs A) is £1k/yr.
5. Lesley's partial retirement at 60 (draw the 1995 pension, keep working reduced hours to 65 or 67) would be worth roughly £16k/yr of net income in the worst years plus more 2015 pension. Worth a scenario of its own in v2.

**What it doesn't do (v1 limits)**
- Tax on Steve's drawdown is a flat 15% simplification; no sequencing of ISA vs pension; no tax-free lump sum strategy.
- Consulting income is taxed as PAYE; a limited company changes NI, allows company pension contributions and dividend planning.
- No care costs beyond the £150k reserve, no inheritance intent for James, no downsizing of the house (£500k equity is a real option, not in the model).
- No State Pension age 68 case yet (set Assumptions!spa to 68 to see it).
- James's university costs 2028–2031 are not in the spending line.
- Lesley's 2015 pension at 67 is my estimate (£4,600), not a statement figure.

**Challenges to Steve**
- £35k–£50k: is that *after* mortgage, and does it include running two cars, holidays, helping James? Pensions UK "Moderate" for a couple is £45,400 and "Comfortable" £62,700 (2025, after tax, home owned outright). Do a real 12-month spend before anchoring on £45k.
- Clearing the £100k mortgage before 60 removes the biggest fixed cost from the gap years. Overpayment vs pension contribution needs the mortgage rate to settle.
- 12% total pension contribution at 55 with £194k in pensions is low for a £110k earner who wants to stop at 60–65. Carry-forward of unused annual allowance from the last three tax years may allow a large one-off top-up.
- Lesley stopping entirely at 60 is the single most expensive assumption in the plan. Partial retirement is the NHS's own mechanism for exactly this situation.

Next: Sprint 1 replaces the remaining placeholders; v2 of the model follows.