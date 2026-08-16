---
id: 01M04SG4CPDR9T4KTECQWBSBKM
created: 2026-08-16T08:02:36.054535Z
updated: 2026-08-16T08:06:26.375707Z
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
- [ ] New tab/route **My Vendors** in the portal shell nav (alongside Vendors and My requests); table = vendors where `owner_id == me`, same columns as the Vendors register (State / Compliance / Criticality / Flags) incl. engagement sub-rows (COM-212 layout + COM-217 row colouring).
- [ ] Rows link to the portal vendor detail page, as on the register.
- [ ] Empty state: no owned vendors → point at the Vendors tab's "Request a new vendor" (COM-211).
- [ ] Tests: owner filter under portal auth (403 unchanged elsewhere), tab renders owned vendors only, My requests untouched.

Stacks on COM-215 (owner-at-request) for the flow to make sense end-to-end.