---
id: 01M54K92R1EN3AEVA0F2YSF56F
created: 2026-10-17T09:32:22.657156Z
updated: 2026-10-17T09:32:28.001046Z
type: task
title: 'SAP opens on an Overview — how this year''s plan is going: done, on track, overdue and cancelled, what''s due in the next 30 days, by type, and coverage per framework'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1053
sprint: sxflvhs
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 9). Built on COM-1052.

## What people see

SAP's first tab, **Overview**, for the company in the top bar and a **year** picker (calendar year by default):

- **Four stat cards:**
  - **Done** (and how many of those were finished late);
  - **On track** (planned or in progress, not overdue);
  - **Overdue**;
  - **Cancelled**.
  Each one opens the Schedule filtered to that set.
- **Due in the next 30 days:** title, type, owner and end date, soonest first.
- **Overdue:** title, owner and days overdue, worst first.
- **By type:** for Training, Testing, Review, Audit and Other, how many are done out of how many planned this year, as a simple bar per type.
- **Coverage:** one line per adopted framework ("ISO 27001: 23 requirements with planned activity, 91 without"), linking to the Coverage tab.
- A place at the top for the year's **sign-off** status, filled in by COM-1056.

## Rules

- Counts are this company's plan entries only. The other Compass reviews from COM-1048 aren't counted.
- An entry belongs to the year its **end date** falls in.

## Notes (technical)

- One summary endpoint (`GET /sap/summary?year=`) so the tab makes one call. The assistant tool (COM-1059) reads the same one.
- Charts: `@mantine/charts` at the pinned version (memory: Mantine charts version pin); it may simply be progress bars. Load the dataviz skill before drawing.

**Done when:** the Overview shows the year's counts, the next 30 days, overdue, by-type progress and per-framework coverage counts, each linking to the filtered detail.