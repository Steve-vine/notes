---
id: 01M4N53MF1P5T1TRQPQ9F6G7Y2
created: 2026-10-11T09:36:07.649449Z
updated: 2026-10-11T10:21:13.164237Z
type: task
title: Compliance opens with a gauge for Core controls — the percentage, the bar by status and the chips — and a tier filter the trend follows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 908
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
- 01M4N52HTCSM3NGXVJKJ07CGKC
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 68, Compliance (ADR in COM-904). Builds on the rename. This is the current picture for Core controls; frameworks join the filter in the next task.

## What people see

- **A gauge card at the top,** in the Assessment page's layout:
  - the compliance percentage, large, with "compliant · N controls" beside it. It is the Dashboard's figure, not the Assessment page's "assessed" figure.
  - the bar, split by status: Implemented, Partial, Not implemented, Not applicable, Not assessed.
  - the status chips, each with its count.
- **A chip opens the Assessments queue** narrowed to that status and the chosen tier. The trail leads back to Compliance.
- **The filter bar holds three things:** the period, as today; **Measure**, which for now offers Core controls only; and **Tier**: Any, Essential, Expected, Specialised.
- **Choosing a tier changes the gauge and the "Compliance over time" chart.**
  - Any: the headline line with the three tier lines, as today.
  - One tier: that tier's line alone.
- **Open gaps, Maturity and Risks do not follow the filter.** When a tier is chosen, a line under the filter bar says they show the whole company.
- **The choices are in the address,** so the page comes back as it was left.
- **No text search, Maturity, Domain or "Owned by me".**

## Notes (technical)

- **The gauge must agree with the Dashboard and with the last point of the trend.** Do not recount in the browser from controls and assessments as the Assessments page does: add the status counts to what the posture measure already returns per tier (and overall), and read them from the API. Decide the route in the PR; a small "compliance now" read beside the Dashboard's is the likely shape. Gated as the Dashboard is.
- **Lift the card out of `AssessmentsQueuePage`** into the kit (the percentage row, `ProgressBar`, `QuickChips`) so both pages use one component. The Assessments page keeps its own figure and its chips keep filtering its list.
- **History.** Tier lines are already in every snapshot; nothing to backfill.
- **Chips as links.** The Assessments queue already reads `tier` and `status` from the address.
- **State.** `useQueryState`; mind the `flushSync` and `e.currentTarget` notes from COM-792.
- **Screen conventions test:** any Switch/Checkbox needs `w="fit-content"`; run the full vitest file list for the page, not just the new test.
- Tests: the gauge's figure equals the Dashboard's in an integration test; a page test for the tier filter, the chip links and the address.

**Done when:** on staging the gauge shows the Dashboard's compliance figure, choosing Essential changes the gauge and leaves one line on the chart, and clicking "Not implemented" opens the Assessments queue on Essential, Not implemented.