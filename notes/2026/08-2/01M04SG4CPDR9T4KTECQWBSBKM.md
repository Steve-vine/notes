---
id: 01M04SG4CPDR9T4KTECQWBSBKM
created: 2026-08-16T08:02:36.054535Z
updated: 2026-09-01T13:55:50.556745Z
type: task
title: 'Portal: new My Vendors tab (vendors I own)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 220
sprint: sbph5q5
blocked_by:
- 01M0313XDNMV364QN18S8MNTRJ
comments:
- id: 01M055EE6S4VSBABR5ZNYY4GWD
  author: Steve Vine
  at: 2026-08-16T11:31:23.481398Z
  text: |-
    Implemented — PR #218.

    Frontend only, as it turned out: the portal register endpoint already accepted `owner`, and COM-222 made that filter mean "main owner **or** co-owner". So the page passes an owner id and ownership stays a server question — a co-owner's vendors appear here without the client comparing ids.

    Identical format to All Vendors, as decided: the *same component* with a `mine` flag, so the filter controls, columns, engagement sub-rows (COM-212) and row colouring (COM-217) are shared rather than reimplemented. Only the scoping and the wording differ.

    "Vendors" → "All Vendors" done; tab order is All Vendors | My Vendors | My requests; My requests untouched.

    Empty state points back at the All Vendors tab rather than repeating the "Request a new vendor" button — asking belongs where not finding a supplier is the moment somebody wants one (COM-211).

    Tests: tab labels and order; the scoped page issuing `owner=<me>` and rendering the same parent/child-coloured table; the empty state; plus the routing test updated for the renamed heading.

    One incidental find while testing: `PortalRouting.test.tsx` renders the whole App and is timing-sensitive, so it flakes locally under parallel load. CI is unaffected — COM-188 already set `asyncUtilTimeout` to 5s when `CI` is set, and the suite is green with that.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
New portal tab **My Vendors** — all vendors where the current user is owner. **My requests stays exactly as it is** (decided 2026-08-16, superseding the earlier rename plan — request tracking keeps its own surface). Pairs with COM-215 (requester becomes initial owner): every vendor you've requested is a vendor you own, so this tab tracks your requested vendors from birth.

- [ ] Backend: portal vendor register endpoint gains an `owner=me` filter (or reuse the existing owner query param through the portal router) so the page can list owned vendors under portal auth.
- [ ] New tab/route **My Vendors**: **identical format to All Vendors** (decided 2026-08-16) — share the register page component, just pinned to `owner_id == me`. Same filter controls (State / Compliance / Criticality / Flag), same columns, engagement sub-rows (COM-212 layout + COM-217 row colouring), same row links to vendor detail. Only the owner scoping and the title differ.
- [ ] **Rename the first portal tab "Vendors" → "All Vendors"** (added 2026-08-16) — nav label + page title; keeps the distinction from My Vendors obvious. Route can stay `/portal/vendors`.
- [ ] **Tab order: All Vendors | My Vendors | My Requests** (added 2026-08-16).
- [ ] Empty state: no owned vendors → point at the All Vendors tab's "Request a new vendor" (COM-211).
- [ ] Tests: owner filter under portal auth (403 unchanged elsewhere), tab renders owned vendors only with the shared register UI, My requests untouched, tab labels + order updated.

Stacks on COM-215 (owner-at-request) for the flow to make sense end-to-end.