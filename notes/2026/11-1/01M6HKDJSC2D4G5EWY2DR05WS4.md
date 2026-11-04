---
id: 01M6HKDJSC2D4G5EWY2DR05WS4
created: 2026-11-03T21:00:39.596761Z
updated: 2026-11-04T07:45:43.18196Z
type: task
title: Percentage complete — the share of an initiative's actions that are finished (gaps remediated, risks given a plan, treatment plans completed, requested reviews done), shown on the list and the page with what's left
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1560
sprint: snyzymp
blocked_by:
- 01M6HKD3VC63AJ25EGMEQ45380
comments:
- id: 01M6HVZE7P4GCS954CWWQRX7FT
  author: Steve Vine
  at: 2026-11-03T23:30:13.366594Z
  text: |-
    Done: PR #1574 merged (eb3e93fb).

    What's there:
    - **The initiative page** shows "62% complete · 13 of 21 done":
      - a bar split into Gaps, Treatment and Reviews, each with a tooltip;
      - "Can go down", with why.

      With nothing counted it says "Nothing to complete yet: add controls with Requires review, or controls with open gaps" rather than 0%.
    - **The Initiatives list's** Complete column now fills, and sorts.
    - **Rows** on the Gaps, Risks and Content tabs say Done or To do, as the percentage sees them.
    - **What counts, each the same:**
      - each gap, done when complete;
      - each risk's "Create a treatment plan", done when a plan exists or the risk is accepted or closed;
      - each treatment plan, done when done;
      - each control or content item marked Requires review, done when the next review answers it.
    - **What doesn't count:**
      - decisions, and unmarked controls and content;
      - routine reviews;
      - left-out items;
      - cancelled gaps and plans;
      - anything finished before it joined.

      A reopened gap counts as open again.

    My calls:
    - **A risk accepted before it joined still counts as done.** Compass doesn't record when a risk was accepted, so if it has no plan it's counted as done rather than left out.
    - **A plan "done before its risk joined"** is judged by when the plan was last changed.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. Make an initiative with 2 open gaps, 1 risk with no plan and 1 control marked Requires review: it shows 0 of 4.
    2. Close one gap and assess the control: 2 of 4 (50%).
    3. Raise a third gap: 2 of 5 (40%).
- id: 01M6HYZBG2R68BJ7551K41TR25
  author: Steve Vine
  at: 2026-11-04T00:22:36.289927Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API; the Playwright browser wasn't connected this session).

    The figures moved as the rules say on INI-1, as E2E Admin A:

    | Step | Done of counted | Breakdown |
    |---|---|---|
    | Start | 1 of 29 (3%) | Gaps 0/26 · Treatment 0/2 · Reviews 1/1 |
    | Closed G-60 | 2 of 29 (7%) | |
    | Raised G-62 | 2 of 30 (7%) | went up by one counted action |

    The "0 of 4" example in Done-when couldn't be reproduced exactly: INS.10 already carries 24 gaps from earlier test runs. The same example passes in the automated tests.

    For you to look at: the progress bar and "Can go down" note on the page, and the Complete column on the list.
assignee: steve
label:
- feature
priority: high
task_status: done
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