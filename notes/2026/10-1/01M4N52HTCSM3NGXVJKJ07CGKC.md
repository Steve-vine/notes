---
id: 01M4N52HTCSM3NGXVJKJ07CGKC
created: 2026-10-11T09:35:32.172525Z
updated: 2026-10-11T09:36:38.674452Z
type: task
title: Timeline is renamed Compliance — in the menu, on the page, in the address, and old links still arrive
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 905
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Part of sprint 68, Compliance (ADR in COM-904). The rename on its own, so the later tasks build on a page already called Compliance.

## What people see

- **The menu entry reads Compliance,** in the place Timeline had.
- **The page title and the trail read Compliance.**
- **The address is `/compliance`.** A bookmark or link to the old address lands on the same page with its period kept.
- **The Dashboard's link to the trend** goes to Compliance.
- **The first chart is titled "Compliance over time",** so the page and the panel do not share a name.
- **The empty and no-company messages** say "compliance" where they said "timeline".
- Nothing else on the page changes in this task.

## Notes (technical)

- `components/nav.ts` (label and path), `App.tsx` (route, a redirect from `/timeline` that keeps the query string, and the path list near line 451), `DashboardPage.tsx` (the link).
- Rename `TimelinePage` to `CompliancePage` and the `timeline/` folder with it, so later tasks do not carry two names. The API path `/posture-timeline` and its types stay: it is the trend's read and renaming it would churn `schema.d.ts` for nothing.
- Breadcrumb labels and the menu-starts-a-trail rules (sprint 64) key on the path; check the trail test.
- `brief/information-architecture.md`: rename the entry, unless COM-904's PR already did.
- Tests: the page test's titles, the redirect, the nav test.

**Done when:** on staging the menu says Compliance, `/timeline?period=3m` lands on Compliance at three months, and the Dashboard's link goes there.