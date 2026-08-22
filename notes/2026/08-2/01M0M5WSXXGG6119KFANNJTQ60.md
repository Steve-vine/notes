---
id: 01M0M5WSXXGG6119KFANNJTQ60
created: 2026-08-22T07:27:50.717366Z
updated: 2026-08-22T09:10:13.880572Z
type: task
title: Move Reports menu item into the Overview section below Dashboards
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 337
sprint: s7jknet
comments:
- id: 01M0M8D5N1PSZRPX018ST6ZQQ4
  author: Steve Vine
  at: 2026-08-22T08:11:44.161107Z
  text: |-
    Done — PR #339, merged to main as 6f27c0a.

    Reports now sits in Overview directly below Dashboard, and is gone from the bottom of Company.

    Where a nav item is *filed* and what it *reads* are now separate things: NavItem gained an optional `gate`, defaulting to its section's (SECTION_GATE in nav.ts). Reports takes the Overview section but keeps the Company gate — Overview being universal (ADR 0026) must not become a way in for a library-only account. Routing is untouched: /reports stays behind RequireSection section="Company".

    Tests: an analyst-only account sees no Reports item; Overview lists exactly Dashboard then Reports.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Move the **Reports** menu item up into the **Overview** section of the navigation menu, positioned directly below **Dashboards**.