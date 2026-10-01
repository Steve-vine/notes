---
id: 01M3ST4F849BPNWBT5P4YE3XPP
created: 2026-09-30T18:44:51.07678Z
updated: 2026-10-01T00:49:57.97828Z
type: task
title: Gaps, Risks and the Timeline in the new layout — registers with quick filters, and a gap's and a risk's page with side cards
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 809
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3TF0WDSXFP5RZ3H9E2VBZKH
  author: Steve Vine
  at: 2026-10-01T00:49:53.593053Z
  text: |-
    Done: PR #819, merged to main (81deea1).

    What you'll see:
    - **Gaps:**
      - **Raise gap** at the top. You pick the control first; only controls assessed as falling short are offered.
      - Three cards you can click to filter: Open (with how many have no owner), Overdue, and Closed this month.
      - Status chips with counts.
      - Search, plus Domain, Tier, Owner and Status filters (each can take several values), and Owned by me.
      - Gaps grouped by domain. You can still change owner, target date and status on the row.
    - **A gap's page:** a header with the gap's number, status and the control it was raised against. Description, notes and comments are on the left; progress and linked risks are on the right.
    - **Risks:**
      - New risk.
      - Cards by residual rating that filter, and status chips.
      - The heat map unchanged, under the Overview tab.
    - **A risk's page:** cause, event and consequence on the left; scoring, owner, treatment plans and links on the right. Save is at the top.
    - **Timeline:** the new header, with the charts in the new colours.

    Two things decided while building:
    - **"Closed this month" counts gaps completed or cancelled whose last change was this month.** Compass doesn't record when a gap was closed, so editing an old closed gap moves it into this month. A proper "closed on" date would be a small separate task.
    - **Gaps keeps its Tier filter** and gains a Domain one. "All open" is now a chip.

    All checks passed.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Part of sprint 65, UI Upgrade (ADR in COM-794). These are the Posture screens other than Assessments (their own task) and Decisions (with the Playbook). They follow the prototype's patterns. Nothing they do changes, apart from quick-filter chips where a register today has a status filter.

## What people see

- **Gaps:**
  - page header with **Raise gap**;
  - summary cards (Open, Overdue, Closed this month) that filter;
  - chips by status with counts;
  - the filter bar (search, and the multi-value Domain, Owner and Status pickers as today);
  - a list grouped by domain with ref, title, control, owner, target date and status.
- **A gap's page:**
  - detail layout, with its control as a link and its status in the header;
  - Notes and comments in the main column;
  - **Progress** (owner, status, target date) and linked risks in the side column.
- **Risks:**
  - page header with **New risk**;
  - summary cards by rating band that filter;
  - the heat map kept as today, in the new colours;
  - the register as a list with rating pills.
- **A risk's page:**
  - detail layout, with the risk written as cause, event and consequence in the main column;
  - scoring, owner, treatment plan and linked records in the side column.
- **Timeline** (posture over time): its charts in the new palette, with a page header and the filter bar.

## Notes (technical)

- **Pages:** `pages/GapsPage`, `GapDetailPage`, `RisksPage`, `RiskDetailPage`, `TimelinePage`.
- **Charts.** They use `@mantine/charts` (pinned to core's version, [[mantine-charts-version-pin]]). Set the series colours from the status tokens.
- **Summary counts** come from the payloads the pages already fetch. Add a count to the API only where the list is paged and the figure would otherwise be wrong.
- **Keep** every filter in the URL (COM-792) and every trail label.
- **Ratchet.** Empty these pages' entries from the page-header ratchet.

**Done when:** on staging, Gaps, a gap, Risks, a risk and the Timeline are all in the new layout, and their chips' counts match the lists they give.