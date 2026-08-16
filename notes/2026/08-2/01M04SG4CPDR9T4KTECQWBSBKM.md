---
id: 01M04SG4CPDR9T4KTECQWBSBKM
created: 2026-08-16T08:02:36.054535Z
updated: 2026-08-16T08:11:05.331787Z
type: task
title: 'Portal: new My Vendors tab (vendors I own)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 220
sprint: sbph5q5
blocked_by:
- 01M0313XDNMV364QN18S8MNTRJ
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
New portal tab **My Vendors** — all vendors where the current user is owner. **My requests stays exactly as it is** (decided 2026-08-16, superseding the earlier rename plan — request tracking keeps its own surface). Pairs with COM-215 (requester becomes initial owner): every vendor you've requested is a vendor you own, so this tab tracks your requested vendors from birth.

- [ ] Backend: portal vendor register endpoint gains an `owner=me` filter (or reuse the existing owner query param through the portal router) so the page can list owned vendors under portal auth.
- [ ] New tab/route **My Vendors**: **identical format to All Vendors** (decided 2026-08-16) — share the register page component, just pinned to `owner_id == me`. Same filter controls (State / Compliance / Criticality / Flag), same columns, engagement sub-rows (COM-212 layout + COM-217 row colouring), same row links to vendor detail. Only the owner scoping and the title differ.
- [ ] **Rename the first portal tab "Vendors" → "All Vendors"** (added 2026-08-16) — nav label + page title; keeps the distinction from My Vendors obvious. Route can stay `/portal/vendors`.
- [ ] **Tab order: All Vendors | My Vendors | My Requests** (added 2026-08-16).
- [ ] Empty state: no owned vendors → point at the All Vendors tab's "Request a new vendor" (COM-211).
- [ ] Tests: owner filter under portal auth (403 unchanged elsewhere), tab renders owned vendors only with the shared register UI, My requests untouched, tab labels + order updated.

Stacks on COM-215 (owner-at-request) for the flow to make sense end-to-end.