---
id: 01M04T6MEWRPZ1072BWRZKEA6H
created: 2026-08-16T08:14:53.404034Z
updated: 2026-08-25T18:43:03.368452Z
type: task
title: 'Portal: Contacts section on vendor detail — owner-editable'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 221
sprint: sbph5q5
blocked_by:
- 01M0313XDNMV364QN18S8MNTRJ
comments:
- id: 01M055EP2MAT07F6GJRFY7Q1FX
  author: Steve Vine
  at: 2026-08-16T11:31:31.540451Z
  text: |-
    Implemented — PR #219.

    Read and write both landed, and the read went further than the brief: contacts are readable by **every** portal user, not only owners. "Who do I call at this supplier?" is the question the register exists to answer, and withholding it does not stop people asking — it moves the answer into email, where nobody maintains it. COM-214's reversal and that reasoning are written into the ADR 0040 amendment rather than left implicit.

    Write is gated on the COM-222 ownership helper, so a **co-owner counts** — otherwise co-ownership would be a label. The internal `/vendors/{id}/contacts` routes stay shut to portal accounts (no vendor role), so the portal router is the only door and it checks ownership on every write. The server is the boundary; `canEdit = useIsVendorOwner(vendor)` only decides what renders.

    The COM-219 ordering applies to both surfaces by construction, not by coincidence: `list_contacts` and `get_contact_or_404` moved into `core/vendor_reads` and both routers call them. A test asserts the two surfaces return the same order.

    The contact hooks became surface-aware on the **write** side as well as the read — unusual for this codebase, and the reason is commented where it happens: the portal's write path is a different router, not the same one behind a different guard.

    The portal write tripwire test grew three entries deliberately.

    Tests: non-owner reads but is refused all three writes (and the internal route too); owner CRUD end to end via the portal; a co-owner may maintain them; internal behaviour unchanged. Frontend: contacts render for a non-owner with the compliance flag readable but not clickable, and an owner's toggle posts to the portal endpoint.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
Contacts join the portal vendor detail page (reached from both All Vendors and My Vendors), read-only for portal users generally and **editable where the current user is the vendor's owner** (decided 2026-08-16 — supersedes COM-214's "not on the portal").

**ADR note:** this is the portal's first write surface beyond the request workflow — ADR 0040 §"no edit affordances anywhere" is deliberately breached for owner-managed contacts (operational data, owner-accountable; not a governance decision). Record as an amendment note in ADR 0040.

- [ ] Portal router: contacts **read** on the portal vendor detail payload (all portal users); contacts **write** endpoints (create/update/delete, compliance flag) on `/api/v1/portal/…`, gated `vendor.owner_id == current_user.id` — the main `/vendors/{id}/contacts` API stays closed to portal users (no internal roles). Server is the enforcement boundary.
- [ ] Frontend: the COM-214 Contacts card rendered on `PortalVendorDetailPage` — read-only presentation for non-owners (COM-213 readable read-only styling), full add/edit/delete + Compliance checkbox when owner. Same component, `canEdit = isOwner` on the portal.
- [ ] Ordering fix (COM-219) applies to the portal read too — same stable order.
- [ ] Tests: non-owner portal user reads but cannot write (403), owner CRUD via portal endpoints, internal behaviour unchanged.

Stacks on COM-214 (shipped) and COM-215 (owners actually exist for portal-requested vendors); pairs with COM-220's My Vendors tab.