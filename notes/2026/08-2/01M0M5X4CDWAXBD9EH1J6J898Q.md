---
id: 01M0M5X4CDWAXBD9EH1J6J898Q
created: 2026-08-22T07:28:01.421618Z
updated: 2026-08-22T08:25:58.878781Z
type: task
title: Consolidate the Access section into a tabbed Access Control screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 342
sprint: s7jknet
comments:
- id: 01M0M9752NYP27E5P52WVYMYVM
  author: Steve Vine
  at: 2026-08-22T08:25:55.541299Z
  text: |-
    Done — PR #345, merged to main as f100767.

    The seven Access entries are now tabs on one Access Control screen, filed under Modules beside Vendor Management; the Access section header is gone.

    Tabs: Role matrix · Requests · Validation · Recertification · Access Graph · View Groups · View Users.

    URLs are unchanged — each tab keeps the path its sidebar entry had (/access/roles, /access/requests, …), so bookmarks, notification links and the pages' own cross-links all still land where they did. /access itself lands on Role matrix. The tab bar sits above a routed <Outlet/>, the same idiom PortalLayout uses.

    The three detail pages stay outside the tab shell (/access/roles/:id, /access/requests/:id, /access/recert/:id) — reading one role, one request or one campaign isn't browsing a tab. The gate is unchanged: RequireSection section="Access" still wraps the lot.

    The tab panes themselves are untouched, so each keeps its own heading and description; the shell adds no title of its own rather than stacking a third level of naming. Say if you'd rather see an "Access Control" heading above the tabs.

    Tests: new AccessControlPage.test.tsx (tab list, /access lands on Role matrix, the URL picks the tab rather than the first one, clicking navigates, a detail URL keeps its tab selected) plus a sidebar test that Modules holds Access Control and no Access section survives.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Create a new menu item/screen called **Access Control**. Re-work each of the separate menu items under the **Access** section to be tabs within the new Access Control screen instead of separate screens, then delete the now-unused **Access** section header.