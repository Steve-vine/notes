---
id: 01M4N53MF1P5T1TRQPQ9F6G7Y2
created: 2026-10-11T09:36:07.649449Z
updated: 2026-10-12T19:48:10.6159Z
type: task
title: Compliance opens with a gauge for Core controls — the percentage, the bar by status and the chips — and a tier filter the trend follows
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 908
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
- 01M4N52HTCSM3NGXVJKJ07CGKC
comments:
- id: 01M4NC489GD3S1MJDFRQV6ZP3K
  author: Steve Vine
  at: 2026-10-11T11:38:47.984652Z
  text: |-
    Merged to main as PR #911 (2026-10-11). Goes to staging with the rest of the sprint.

    What is there
    - Compliance opens with a gauge in the Assessment page's layout: a large percentage, what it counts, a bar split by status, and a chip per status with its count.
    - The percentage is the Dashboard's compliance figure: controls implemented, out of the controls in scope. It is not the Assessment page's "assessed" figure. The text beside it reads, for example, "implemented · 370 controls in scope".
    - The statuses are Implemented, Partial, Not implemented, Not applicable and Not assessed, plus an "All" chip.
    - A chip is a link. It opens the Assessments queue narrowed to that status, and to the tier if one is chosen.
    - A Tier filter (Any, Essential, Expected, Specialised) narrows the gauge and "Compliance over time". With a tier chosen the chart draws that tier's line alone; with none it draws the headline and the three tiers, as before.
    - Open gaps, Maturity and Risks stay whole-company. When a tier is chosen a line above them says so.
    - The period choice moved to the right-hand end of the filter bar, because it governs the charts only.
    - The tier is kept in the address. There is no text search, Maturity, Domain or "Owned by me".
    - Where nothing is in scope the gauge shows a dash, not 0%.

    Changed from the task as written
    - The Measure filter is not in this task. On its own it would have been a control with one option, so it arrives with frameworks in COM-909.
    - The caption says "implemented · N controls in scope", not "compliant · N controls", because that is exactly what the percentage is.

    Decisions I took
    - A control is counted by whether it applies first, then by its status. A control marked as not applying to the company counts as Not applicable whatever its status says, because that is what takes it out of the percentage.
    - A control still marked as applying, but with the status "Not applicable", counts as Not implemented here. The Dashboard already treats it as a shortfall, and the gauge has to add up to the Dashboard's figure.
    - Because of those two rules, a chip's count can differ slightly from the list it opens: the Assessments queue filters on status alone. It only differs where a control's status and its "applies to this company" switch disagree. I have not changed the queue.

    Technical
    - GET /posture-compliance, gated as the trend is. It reads the same posture measure as the Dashboard and the nightly record; the measure now counts each tier's controls by state.
    - The gauge and its bar are kit components (Gauge, GaugeBar) and the Assessment page uses them. ChipLinks is the same chip as a link.
    - compliance/series.ts works out which lines the chart draws, so that can be tested without a chart.
assignee: steve
label:
- feature
priority: high
task_status: done
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