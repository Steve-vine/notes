---
id: 01M6296Y0E4WDNAZ1ERAMTEJE6
created: 2026-10-28T22:13:39.470587Z
updated: 2026-10-30T08:01:20.145471Z
type: task
title: Posture ▸ Checks — every check for the company in one list with its state, trend and failing items; Settings ▸ Checks to switch each one off and set its thresholds; a Dashboard tile for checks failing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1420
sprint: s6j9773
blocked_by:
- 01M6296JQY05DTMZTVYTZ6C3NS
comments:
- id: 01M63G0VWN2GC07J1JZRYR89ZV
  author: Steve Vine
  at: 2026-10-29T09:31:55.157706Z
  text: |-
    Done — PR #1437 (stacked; goes to main after #1434–#1436).

    What you'll see:
    - Posture ▸ Checks in the menu, after Continuity. At the top, "9 of 11 checks passing", then Failing / Passing / Can't tell cards that filter the list, and a "Reads" filter (Directory, Cloud, Vulnerabilities). The table shows each check's state, since when, "164 of 1,210" failing, its controls (linked to the assessment), the gap it raised, and when it last ran. Every column sorts.
    - A check's own page: what it tests and its threshold, its controls and gap, a "How much passed" line over time, every item (50 a page) with Export CSV, the list of changes, and Run now.
    - Settings tab (for people who record assessments): an On switch and the threshold for each check (dormant after 90 days, at most 4 top admins), and "A check's gap: due after 30 days". Switching off a check with an open gap asks first ("Its open gap G-123 will be closed") and closes it straight away.
    - Dashboard: a Checks tile with "2 failing" and passing / can't tell badges, linking to the page. It's hidden when every check is off.

    My calls:
    - Settings ▸ Checks is a tab on the Checks page, not a separate Settings screen, and needs Record assessments (Posture has no "Manage company settings" permission — ADR 0132 call 9). Changes are in the activity log.
    - Export CSV appears only for someone who can see the items by name. The file escapes names that start with = + - @, so a spreadsheet won't run them as formulas.
    - On "Conditional Access requires MFA", the page lists who is left out of the policy even while the check passes.
    - The "How much passed" line starts once the check has run on more than one day.

    Tests: an API integration test (page, CSV, thresholds refused out of range, switch-off closes the gap, audit) and 3 page tests.
assignee: steve
label:
- feature
priority: high
task_status: done
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