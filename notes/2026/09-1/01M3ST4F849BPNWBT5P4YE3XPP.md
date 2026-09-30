---
id: 01M3ST4F849BPNWBT5P4YE3XPP
created: 2026-09-30T18:44:51.07678Z
updated: 2026-09-30T18:44:51.07678Z
type: task
title: Gaps, Risks and the Timeline in the new layout — registers with quick filters, and a gap's and a risk's page with side cards
priority: medium
label: improvement
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 809
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