---
id: 01M1YNMT455M6J3VY949WVSFK2
created: 2026-09-07T19:31:12.133737Z
updated: 2026-09-07T21:02:13.678056Z
type: task
title: Three tier rings on the Dashboard
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 607
sprint: sqc2gdq
blocked_by:
- 01M1YNME010YPQCCD5V8GD2CF1
comments:
- id: 01M1YTVFMFG3EHW1WTZWX9GXB4
  author: Steve Vine
  at: 2026-09-07T21:02:13.647868Z
  text: |-
    Done — merged to main in PR #616.

    The Dashboard has a "Compliance by tier" card under the headline row: three small rings, Essential / Expected / Specialised, each labelled under itself with "n / m implemented". Same ring and same colour scale as the compliance ring above, so they read as the same instrument split three ways. Implemented over applicable within each tier; a control ruled out of scope leaves its tier's ring, and a tier with nothing applicable reads n/a rather than 0%. The three rings partition the headline exactly — same numerator, same denominator — and that is asserted in the tests.

    One card rather than three more tiles in the top row, so the split does not compete with the headline.

    One fix-forward during CI: a portal routing test stubs the dashboard payload and did not carry the new field; the stub now does.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The Dashboard shows one compliance ring today — implemented over applicable, for the whole company. Add three more, one per tier, so "where do we stand" can be answered as "the Essentials are done, the rest isn't" rather than a single blended number that hides it.

Each tier ring is the **same score, narrowed** — implemented / applicable within that tier. Applicability still governs the denominator, exactly as the overall ring does. A control ruled not applicable is out of its tier's ring too. The tier changes nothing about how the score is computed (ADR 0018 rubrics untouched); it only changes what's counted in.

**Backend** — the posture summary (`api/v1/dashboard.py`) gains a per-tier breakdown beside the existing totals: implemented, applicable and percent for each of the three. Same null handling as today, where a tier with nothing applicable reads "n/a" rather than 0%.

**Frontend** — `DashboardPage.tsx` already renders the overall ring with `RingProgress` and `complianceColor`. Reuse both, so a tier ring and the overall ring are visibly the same instrument.

**Layout.** The top row is a `SimpleGrid` of four cards — compliance, avg maturity, and two others. Three more peer cards makes seven and puts the tier rings in competition with the headline. One card holding three small rings side by side is the better read: it says "the same score, split three ways", which is what it is. Check it against the screen conventions in `brief/information-architecture.md` before building.

Worth watching: the Essential ring is the one people will actually steer by, so it should be legible at a glance — the tier label under each ring, not a legend somewhere else.

**Blocked by** COM-606: nothing to group by until the tier is on the control.