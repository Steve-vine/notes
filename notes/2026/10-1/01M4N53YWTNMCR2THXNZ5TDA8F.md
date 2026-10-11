---
id: 01M4N53YWTNMCR2THXNZ5TDA8F
created: 2026-10-11T09:36:18.330415Z
updated: 2026-10-11T12:16:20.578087Z
type: task
title: Compliance can measure one or more frameworks — a gauge each, a trend line each, and chips that open the framework's requirements
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 909
sprint: s4gilxe
blocked_by:
- 01M4N53MF1P5T1TRQPQ9F6G7Y2
comments:
- id: 01M4NE8Z6N0ES04WVZ95BZ77G7
  author: Steve Vine
  at: 2026-10-11T12:16:19.669162Z
  text: |-
    Merged to main as PR #912 (2026-10-11). Goes to staging with the rest of the sprint.

    What is there
    - The filter bar has a Measure filter. "Core controls" is its starting choice; under it is every framework the Dashboard lists, with the ones the company holds first.
    - Several frameworks can be chosen at once. Choosing "Core controls" clears them. Core controls and frameworks are either/or, and the Tier filter is hidden while frameworks are measured. The tier is remembered for when you go back.
    - Each chosen framework has its own gauge, side by side, up to three across. It shows the percentage of its requirements that are met, "met · N requirements", and the level where the framework has one, for example "at i1".
    - The figure is the framework's own: the same number as the Dashboard and the framework's page.
    - The bar and chips are Met, Not met and Out of scope, plus "All".
    - A chip opens that framework's page on its Coverage tab, narrowed to that state. The page says "Showing requirements that are not met only" with a button to show every requirement again.
    - "Compliance over time" draws one line per chosen framework. Each framework has a colour of its own that does not change when another is added, and a mark of that colour beside its gauge's title.
    - The separate Frameworks chart is gone. The note about the other charts now reads "Open gaps, Maturity and Risks show the whole company".

    Decisions I took
    - "Not met" means everything in scope that is not met: partly met, not met and not assessed together. That is the other half of the headline figure, so Met plus Not met is the number of requirements that apply.
    - A superseded version of a framework is offered only if the company still holds it, which is the Dashboard's rule.
    - A framework in the address that the library no longer offers is ignored, and the page shows Core controls.
    - Narrowed to "out of scope", the framework's page shows only its Out of scope section. Otherwise it would open on a column of empty headings.

    Not done
    - With nothing chosen in Measure, no framework's line is on the page any more. To see a framework's trend you choose it. That is the cost of removing the Frameworks chart, as agreed.

    Technical
    - GET /posture-compliance returns the frameworks from the same posture measure, with their figures at every level.
    - The framework page reads `status=met|not_met|out_of_scope` from the address.
    - One CI round needed a rerun: a dependency-scan job timed out reaching PyPI while the build host's network was saturated. Not a code fault.
assignee: steve
label:
- feature
priority: high
task_status: review
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