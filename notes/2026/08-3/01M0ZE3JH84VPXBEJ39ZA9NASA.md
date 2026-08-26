---
id: 01M0ZE3JH84VPXBEJ39ZA9NASA
created: 2026-08-26T16:22:59.880068Z
updated: 2026-08-26T16:23:03.332392Z
type: task
title: Actions sits above Reports in the sidebar
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 434
sprint: sbph5q5
assignee: steve
company:
- moneypenny
label:
- improvement
priority: low
task_status: todo
---
Overview currently reads Dashboard, Reports, Actions. It should read **Dashboard, Actions, Reports**.

Actions is where you go to find out what you have to do, and Reports is where you go to export something for somebody else. The first is a daily destination and the second is occasional, so the daily one should not be the third thing down.

It also puts the two universal entries together at the top, with the one gated entry below them — Reports keeps `gate: 'Company'` because every one of its rows is company data, so a library-only account sees Dashboard and Actions with nothing between them rather than a gap where Reports used to be.

## Implementation

`components/nav.ts` — move the Actions entry above Reports in `NAV_ITEMS`. Section order is unchanged; only the order within Overview.

`AppLayout.test.tsx` asserts the Overview labels as an ordered list in at least two places (the Reports test and the vendor_admin test added by COM-408), so both move with it. That the order is asserted rather than assumed is the point — it should stay that way.

Labels only. No routes, no gates, no pages.