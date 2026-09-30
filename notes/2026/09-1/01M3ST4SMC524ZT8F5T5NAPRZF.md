---
id: 01M3ST4SMC524ZT8F5T5NAPRZF
created: 2026-09-30T18:45:01.708585Z
updated: 2026-09-30T23:20:04.234168Z
type: task
title: The overview screens in the new layout — Dashboard, Actions, Reports, Search results and Notifications
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 810
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Part of sprint 65, UI Upgrade (ADR in COM-794). These are the menu's Overview section, plus the pages the top bar leads to. They follow the prototype's patterns. Nothing they do changes.

## What people see

- **Dashboard:**
  - summary cards across the top (assessed, compliance, open gaps, risks above appetite, vendors needing attention, as today's tiles carry);
  - compliance by domain and by tier as bars in the status colours;
  - the vendor tile and the others in the kit's card style.
- **Actions:** page header, chips by kind with counts, the filter bar with **Owned by me**, and a list of what needs doing with its source, owner and due date.
- **Reports:**
  - page header, and the reports as cards grouped by what they cover;
  - each report's page keeps its output, with the Statement of Applicability export where it is today.
- **Search results:**
  - the query in the header ("Search: password");
  - results grouped by type (controls, documents, vendors, risks, …) as grouped-list rows with the type's icon.
- **Notifications:** a list with unread rows marked by a violet dot, with **Mark all read** in the header.

## Notes (technical)

- **Pages:** `pages/DashboardPage`, `ActionsPage`, `ReportsPage`, `SearchPage`, `NotificationsPage` (the main-app use; the portal use is in the user portal task).
- **Dashboard charts** use the status tokens ([[mantine-charts-version-pin]]).
- **Keep:**
  - the search results page as the start of a trail (ADR 0084);
  - Actions derived from declared sources (ADR 0055), unchanged.
- **Ratchet.** Empty these pages' entries from the page-header ratchet.

**Done when:** on staging, the Dashboard, Actions, Reports, Search results and Notifications are in the new layout, with the same figures as before.