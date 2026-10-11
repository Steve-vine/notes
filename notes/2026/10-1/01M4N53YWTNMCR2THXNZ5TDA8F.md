---
id: 01M4N53YWTNMCR2THXNZ5TDA8F
created: 2026-10-11T09:36:18.330415Z
updated: 2026-10-11T09:36:37.037645Z
type: task
title: Compliance can measure one or more frameworks — a gauge each, a trend line each, and chips that open the framework's requirements
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 909
sprint: s4gilxe
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
Part of sprint 68, Compliance (ADR in COM-904). Builds on the Core controls gauge. Each framework is measured at the level the company is working towards; choosing a different level is the next task.

## What people see

- **Measure offers Core controls and every framework in the library.** Frameworks the company holds come first. Several frameworks can be chosen at once. Core controls and frameworks are either/or.
- **Each chosen framework gets its own gauge,** side by side, wrapping on a narrow screen:
  - the percentage met, with "met · N requirements" and the level if the framework has one, for example "at i1".
  - the bar: Met, Not met, Out of scope.
  - the same three as chips with counts.
- **The figure is the framework's own:** the same number as the Dashboard and the framework's page.
- **A chip opens that framework's page** on its requirements, narrowed to that status. The trail leads back to Compliance.
- **"Compliance over time" draws one line per chosen framework.**
- **The separate Frameworks chart goes.** Choosing frameworks in the filter draws the same lines on the main chart.
- **The Tier filter is hidden** while frameworks are chosen.
- **Open gaps, Maturity and Risks stay whole-company,** with the same note.

## Notes (technical)

- **Filter.** The kit's `FilterButton` already has a `multiple` form. Options from `useFrameworks`, held first; a superseded version only if the company holds it.
- **Current figures.** The coverage tallies have total, excluded, above-level and met; the gauge needs them per framework in one read. Extend the read added in the Core gauge task rather than calling the coverage endpoint once per framework.
- **Trend.** Per-framework points are in every snapshot already (`frameworks[].compliance_percent`), so no backfill. Reuse `FRAMEWORK_COLORS`; a framework keeps its colour between gauge and line.
- **Chip links.** The framework page reads only `domain` from the address today. Its requirements view needs a status filter in the address (met, not met, out of scope) for the chip to land on.
- **Removing `FrameworksCard`** removes its "Show all" switch and tests.
- Tests: two frameworks give two gauges and two lines; the figure equals the framework page's in an integration test; the chip's address.

**Done when:** on staging, choosing ISO 27001 and HITRUST shows two gauges whose figures match each framework's page, two lines on the chart, and "Not met" on HITRUST opens HITRUST's unmet requirements.