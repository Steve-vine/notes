---
id: 01M6296Y0E4WDNAZ1ERAMTEJE6
created: 2026-10-28T22:13:39.470587Z
updated: 2026-10-28T22:13:39.470587Z
type: task
title: Posture ▸ Checks — every check for the company in one list with its state, trend and failing items; Settings ▸ Checks to switch each one off and set its thresholds; a Dashboard tile for checks failing
assignee: steve
label: feature
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1420
---
Sprint 96, Continuous Control Checks (ADR 0132, COM-1415).

## What people see

**Posture ▸ Checks** (new tab, company-scoped):
- A header gauge: "9 of 11 checks passing", plus failing and can't-tell counts.
- A table with these columns: check, state pill, since, failing count, controls (ref chips, linked to each assessment), the gap raised, last run.
- The table is sortable and filters by state and by integration (Directory, cloud, Vulnerabilities).
- **A check's page** shows:
  - what it tests, in a sentence, and its threshold;
  - **every failing item**, paged and exportable to CSV;
  - a **pass-rate line** over time from the kept results (the same chart kit as Compliance);
  - a list of state changes;
  - Run now.

**Settings ▸ Checks** (per company):
- each check with an **On/Off** switch, its threshold (dormant days 90, top admins 4) and its controls;
- the **target date for a check's gap** (30 days).
- Switching a check off asks first: "Its open gap G-123 will be closed."

**Dashboard:** a **Checks** tile, "2 failing", linking to the Checks page. It's shown only when the company has any check on.

## Who can do what

- Anyone who can see the Dashboard sees the Checks page. Failing items follow the module permissions as on the control card.
- Settings ▸ Checks needs the permission that edits company settings for Posture (*Manage company settings*); it's audited in the activity log.

## Notes (technical)

- Endpoints: list, detail with paged items, history, settings GET/PUT. Settings writes are audited and revisioned like other company settings.
- Use the menu and breadcrumb conventions (ADR 0084) and `brief/information-architecture.md` → Screen conventions. Every Switch needs `w="fit-content"`; tables use SortableTh.
- CSV export goes through the existing report export helper.

**Chain:** on the chain (API).

**Done when:** on staging, Steve opens Posture ▸ Checks, drills into a failing check, exports its list, switches a check off in Settings and sees its gap close.