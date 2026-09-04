---
id: 01M1FEX10PXK5GGQ8DZN3H3Z5D
created: 2026-09-01T21:44:44.822023Z
updated: 2026-09-04T16:51:34.030801Z
type: task
title: Priority reaches the incident surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 766
sprint: s7nj09w
comments:
- id: 01M1MHTFBBKGQVYCNWEVZPSGH8
  author: Steve Vine
  at: 2026-09-03T21:11:59.083512Z
  text: |-
    Built and MERGED to main — PR #709. No migration.

    TWO AXES, TOLD APART BY SHAPE
    Priority is OUTLINED where severity is FILLED, and sits first — in the queue's columns, its filters, and the detail page's state block. Two similar-coloured filled pills side by side read as one thing said twice, and the outline is what stops an operator merging them by eye. The filters are separate for the same reason: one control would force them to pick which question they were asking.

    "WHY P1" IS A CLAIM SOMEBODY CAN ARGUE WITH
    The reason sentence sits directly under the state block — "P1 — chinwag.prod (critical criticality): database is down, and rds-primary is impaired" — with a line saying both inputs are editable and where to change them.

    ABSENT IS NOT P4
    An unpriced incident reads as an em-dash with the explanation on hover, and `priority=none` is a NAMED, selectable filter value. Hiding an absence behind an unnamed one is how a queue quietly loses rows.

    THE COVERAGE FIGURE — the point of the sprint made visible
    After the Correlator the queue gets shorter for two very different reasons: ISE judged the rest unimportant, or ISE could not judge them at all. Only this tells them apart. The line states the gap in the two halves that need different fixes, links to the Business Applications screen, and says plainly that those signals open nothing.

    **It will start out terrible on staging.** That is the honest starting position and it is the number to watch rather than the incident count.

    ONE TRAP
    Sorting by priority runs the ordinal BACKWARDS against the tuple, because P1 is the worst. Sorting by spelling looks right until somebody adds a P5.

    Also fixed a test-shape trap: `IssueFilters.test.tsx` takes the LAST recorded fetch as "the list request", and the new coverage poll became the last one. The stub already excluded `queue-stats` for exactly this reason; coverage now sits beside it.
assignee: steve
label:
- feature
priority: medium
task_status: done
tech: null
---
Put the Correlator's judgement in front of an operator, in the vocabulary the prioritisation spec defines.

An incident should say what it is, how important it is, **and why** — which business service it affects, what breaks for the business, and what the priority rests on. "P1 because call routing falls back to round robin" is a claim an operator can act on or argue with; a bare severity is not.

Covers the incident list and detail, and the filters that let someone see only what would wake them up.

**Also the noise fix's visible half:** once the Differ passes change rather than state and the Correlator escalates on business importance, the incident queue should measurably shrink. Worth measuring before and after — today 119 incidents are open, of which the flaking-synthetic class is a large share.

**Blocked by** the prioritisation vocabulary spec and the Correlator.