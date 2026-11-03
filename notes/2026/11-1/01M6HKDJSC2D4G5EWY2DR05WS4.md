---
id: 01M6HKDJSC2D4G5EWY2DR05WS4
created: 2026-11-03T21:00:39.596761Z
updated: 2026-11-03T22:58:51.634431Z
type: task
title: Percentage complete — the share of an initiative's actions that are finished (gaps remediated, risks given a plan, treatment plans completed, requested reviews done), shown on the list and the page with what's left
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1560
sprint: snyzymp
blocked_by:
- 01M6HKD3VC63AJ25EGMEQ45380
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1556, COM-1557 and COM-1559. Steve's rule (2026-11-03): work from a list of actions.

## What counts

| Item | Counts as | Done when |
|---|---|---|
| Gap | Remediate | complete. Cancelled drops out of the count |
| Risk with no treatment plan | Create a treatment plan | a plan exists, or the risk is accepted or closed |
| Each treatment plan | Complete | done. Cancelled drops out |
| Control marked Requires review | Review | reviewed after being marked |
| Content marked Requires review | Review | reviewed after being marked |

**Not counted:**
- decisions;
- controls or content not marked;
- routine repeating reviews;
- left-out items;
- anything already finished before it joined the initiative, such as a gap closed before its control was added or a plan done before its risk joined.

**A reopened gap** counts as open again.

## What people see

- **The page header** shows **62% complete**, with "**13 of 21** done". Under it, a bar split by kind: Gaps 6/10, Treatment 4/6, Reviews 3/5.
- **Done when nothing counts.** An initiative with nothing that counts shows "Nothing to complete yet: add controls with Requires review, or controls with open gaps" rather than 0% or 100%.
- **The Initiatives list** shows the percentage, sortable.
- **Rows on each tab** show done or still to do, as the percentage sees them.
- **The figure goes down when work arrives,** such as a new gap or a new plan. That's intended. A short note by the figure says so.

## Notes (technical)

- One function, `core/initiatives/progress.py`, returns the counted units with done flags, from the COM-1555/1556 resolver plus the COM-1557 requests. The list, the page, the Actions tab's "counts" marker and the Polaris tool all read it.
- "Joined" = the earliest moment the item entered the initiative by any route (its control added, or added directly). Anything created after that counts whatever its state.
- Set-based queries for the list: compute per initiative in bulk, never N+1 across the list.
- Unit-test the edge cases:
  - a cancelled gap;
  - a gap closed before it joined;
  - a gap reopened after closing;
  - a risk accepted with no plan;
  - a review done before the mark (doesn't count);
  - a left-out item put back.

**Chain:** on the chain (API).

**Done when:** on staging, as admin in E2E Test Company, an initiative with:
- 2 open gaps;
- 1 risk with no plan;
- 1 control marked Requires review

shows **0 of 4**. Then:
- closing one gap and assessing the control shows **2 of 4 (50%)**;
- raising a third gap shows **2 of 5 (40%)**.