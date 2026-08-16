---
id: 01M04SG4CPDR9T4KTECQWBSBKM
created: 2026-08-16T08:02:36.054535Z
updated: 2026-08-16T08:02:40.386313Z
type: task
title: 'Portal: My Requests becomes My Vendors (vendors I own)'
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
Rename the portal's **My requests** tab to **My Vendors**; its main content becomes the vendors where the current user is owner (decided 2026-08-16). Pairs with COM-215 (requester becomes initial owner), which makes every vendor you've requested a vendor you own — so the tab tracks your requested vendors from birth.

- [ ] Backend: portal vendor register endpoint gains an `owner=me` filter (or reuse the existing owner query param through the portal router) so the page can list owned vendors under portal auth.
- [ ] Tab renamed **My Vendors** (nav + route + page title); main table = vendors where `owner_id == me`, same columns as the Vendors register (State / Compliance / Criticality / Flags) incl. engagement sub-rows (COM-212 layout).
- [ ] Keep a compact **"My open requests"** section beneath (assumption, 2026-08-16 — strike if unwanted): open requests raised by me, so tracking survives for new-engagement / amendment requests on vendors I don't own — otherwise those become invisible to the requester after the rename.
- [ ] Empty states: no owned vendors → point at the Vendors tab's "Request a new vendor" (COM-211).
- [ ] Tests: owner filter under portal auth (and 403 unchanged elsewhere), rename, both sections render.

Stacks on COM-215 (owner-at-request) for the flow to make sense end-to-end; COM-211 moved the request button out already.