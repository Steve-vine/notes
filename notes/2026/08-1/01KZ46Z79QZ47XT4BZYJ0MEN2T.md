---
id: 01KZ46Z79QZ47XT4BZYJ0MEN2T
created: 2026-08-03T16:23:05.783815Z
updated: 2026-08-06T08:34:47.119636Z
type: task
title: Estate graph relationships
project: 01KX671DATY39VW6GWK3M2T3DN
number: 518
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ485NB538DVZH6P5NDE80FQ
  author: Steve Vine
  at: 2026-08-03T16:44:05.349809Z
  text: |-
    Done in PR #441 (feature/ise-518-edge-provenance-pill). The provenance badge is gone; edges now carry just the relationship pill.

    Worth knowing what that gives up, so you can push back if you disagree: the pill was the only place on the canvas distinguishing an `asserted` (human-stated) edge from a `harvested` (discovered) one. What it is NOT giving up is the safety signal — an `ai_proposed` edge is still drawn dashed, which is the distinction ADR 0041 §3 exists to protect ("a graph half-built from AI proposals that reads as certain is dangerous"). Per-edge provenance is also still on the entity's Relationships panel with its badge and explanation, so nothing is unrecoverable, just one hop away.

    This also helps the overlap problem I flagged on ISE-516: two entities joined by two edge kinds drew stacked labels, and halving each label's height makes that noticeably less messy.

    No test on this one, deliberately. jsdom cannot render xyflow edge labels — I probed it rather than assuming, and neither pill is in the DOM even before the change, so a test asserting the badge is absent would pass either way. A green vacuous test would have been worse than none. Full suite (548), build, eslint and prettier all green; the actual verification is your eye on staging.
- id: 01KZ4B9MND18P0M9KFQ1XKTRN5
  author: Steve Vine
  at: 2026-08-03T17:38:41.45362Z
  text: 'RELEASED to main 2026-08-03 (PR #441 merged, main bc456fb, no migration). Smoke tested OK on staging; staging reset to main.'
assignee: steve
label: null
priority: medium
task_status: done
---
On the estate graph lines.

Remove the second pill - E.g. “Discovered” just leave the relationship pill e.g. “part of”

