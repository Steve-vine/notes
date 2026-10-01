---
id: 01M3ST4SMC524ZT8F5T5NAPRZF
created: 2026-09-30T18:45:01.708585Z
updated: 2026-10-01T20:05:54.433797Z
type: task
title: The overview screens in the new layout — Dashboard, Actions, Reports, Search results and Notifications
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 810
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3TDRSE6866V65RCSV0766ZN
  author: Steve Vine
  at: 2026-10-01T00:27:59.813868Z
  text: |-
    Done: PR #820, merged to main (2039aac).

    What you'll see:
    - **Dashboard:**
      - The violet banner is gone, and the page has the new header with **View timeline**.
      - A row of cards: Compliance, Assessed, Avg maturity, Open gaps, **Risks above appetite** (new), Vendors needing attention and My actions. Each keeps its "vs about a month ago" change and opens the list it counts.
      - Compliance by tier is shown as coloured bars. Compliance by domain is the same list as before, with a bar per domain.
      - The Vendors, Inventory and Recent activity tiles are cards.
    - **Actions:** chips for All, Gaps, Treatments, Reviews, Approvals, Vendors and Access, each with its count. Owned by me, Overdue only and This company only are in the filter bar.
    - **Reports:** the reports as cards in two groups, Frameworks and Registers. The downloads are the same.
    - **Search results:** titled with what you searched for, with results grouped by type and counts.
    - **Notifications:** unread ones have a violet dot, and Mark all read is at the top.

    Small things decided while building:
    - **Compliance and maturity colours** use the four status colours (red, orange, amber, green) everywhere, including a framework's page. The thresholds are the same.
    - **Fixed:** an average maturity like 2.3 used to show in the top band's green; it now takes its own level's colour.

    All checks passed (1,652 frontend tests).
assignee: steve
label:
- improvement
priority: medium
task_status: done
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