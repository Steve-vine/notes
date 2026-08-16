---
id: 01M04T6MEWRPZ1072BWRZKEA6H
created: 2026-08-16T08:14:53.404034Z
updated: 2026-08-16T08:14:57.486727Z
type: task
title: 'Portal: Contacts section on vendor detail — owner-editable'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 221
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Contacts join the portal vendor detail page (reached from both All Vendors and My Vendors), read-only for portal users generally and **editable where the current user is the vendor's owner** (decided 2026-08-16 — supersedes COM-214's "not on the portal").

**ADR note:** this is the portal's first write surface beyond the request workflow — ADR 0040 §"no edit affordances anywhere" is deliberately breached for owner-managed contacts (operational data, owner-accountable; not a governance decision). Record as an amendment note in ADR 0040.

- [ ] Portal router: contacts **read** on the portal vendor detail payload (all portal users); contacts **write** endpoints (create/update/delete, compliance flag) on `/api/v1/portal/…`, gated `vendor.owner_id == current_user.id` — the main `/vendors/{id}/contacts` API stays closed to portal users (no internal roles). Server is the enforcement boundary.
- [ ] Frontend: the COM-214 Contacts card rendered on `PortalVendorDetailPage` — read-only presentation for non-owners (COM-213 readable read-only styling), full add/edit/delete + Compliance checkbox when owner. Same component, `canEdit = isOwner` on the portal.
- [ ] Ordering fix (COM-219) applies to the portal read too — same stable order.
- [ ] Tests: non-owner portal user reads but cannot write (403), owner CRUD via portal endpoints, internal behaviour unchanged.

Stacks on COM-214 (shipped) and COM-215 (owners actually exist for portal-requested vendors); pairs with COM-220's My Vendors tab.