---
id: 01M0WVJEJ5S0VKJ9459FHA07SP
created: 2026-08-25T16:20:35.525531Z
updated: 2026-08-25T16:20:35.525531Z
type: task
title: The vendor's owner approves changes to their own vendor — an owner approval alongside the areas
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 401
---
Found in scenario testing (2026-08-25). Raising a request is gated on `require_vendor_submit` alone — deliberately, per ADR 0049: a request is a proposal and the areas are what protect the register. But the **accountable owner has no say and no notification**. `vendor_requests.submit` notifies area approvers only, and the portal's submitted slice is scoped `requested_by == user.id` — so an `amend_engagement` raised by someone else against my engagement can be approved and applied without ever appearing anywhere I look. An amendment overwrites scope, data types, residency, access requirements and sub-processors.

The owner is the missing signature. Give the request an **owner approval** alongside its area approvals.

**Designed with Steve, 2026-08-25:**

* Owner approval is raised and notified **at the same time as the areas** — no extra step in the chain. Consequence accepted: an owner rejection can land after the areas have spent time on it, and owner-rejected + Legal-approved can coexist (status derives from the approvals, so it reads rejected — correct).
* The owner decides it in **My requests → To approve**, where every other decision already lives. **My Vendors** carries a badge linking through. Not an inline decide on My Vendors — one place where decisions happen.
* An **admin may decide on the owner's behalf** from the internal Requests tab, recorded as on-behalf-of.

## ADR first

- [ ] Amendment to ADR 0049 §2. Its rule is "the role gates the surface, the per-record row gates the work"; this adds a second per-record row and, for the first time, lets **being an owner be the whole reason you may decide** — a `vendor_user` decides this one approval on their own vendor and nothing else. That is an extension of §2's own argument, not a break, but it must be written down.
- [ ] Say explicitly what happens to the decide route's gate (below), since COM-349 deliberately declined to widen that write and this reverses part of that.

## Backend

- [ ] `vendor_approvals` gains **`kind`** (`area` | `owner`, `server_default='area'`). `area_id` becomes **nullable**, with a check constraint: `area_id IS NOT NULL` iff `kind = 'area'`. New enum type, so `sa.Enum` is fine here — but the migration must not touch `vendor_approval_status` (`postgresql.ENUM(create_type=False)` if it is referenced at all; see the Alembic enum-reuse trap).
- [ ] Fan-out in `vendor_requests.submit`: add one `kind='owner'` approval for **`new_engagement` and `amend_engagement` only**. `new_vendor` gets none — the requester becomes the owner, so there is nobody else to ask.
- [ ] **Unowned vendor ⇒ no owner approval.** `owner_id` NULL with no co-owners means the approval would hang on nobody. Skip it and say so on the request rather than blocking forever.
- [ ] **Requester is an owner ⇒ created already `approved`**, snapshot `decided_by_name` as "Approved on submission (requester is the owner)". Without this, the normal case — an owner asking for something on their own vendor — deadlocks on COM-346's no-self-approval rule.
- [ ] **Owners resolve at decision time, not submission.** Do not snapshot the owner set: if ownership transfers while the request is open, the pending approval follows the vendor. The new owner can decide it; the old owner cannot.
- [ ] `decide_from_body` learns the kind. For `kind='owner'` the gate is `vendor_ownership.is_owner(...)` **or** `user.is_admin` — *not* `_VENDOR_ASSESS`. A non-owner `vendor_admin` is refused, exactly as they are on an area they are not listed on; only global `admin` bypasses. COM-346's no-self-approval rule still applies to everyone but `admin`.
- [ ] **Decide route gate.** The routes are `require_vendor_assess`, which an owning `vendor_user` does not satisfy. Move both doors to `require_portal_read` and let `decide_from_body` be the sole authority — the shape COM-349 used for the queue *read*. Test that the widening does not reach anything else on those routers.
- [ ] Admin on-behalf: when an `admin` who is not an owner decides an owner approval, snapshot `decided_by_name` as "<name> (on behalf of the owner)". The activity log names the admin, never the owner.
- [ ] Notify **every owner** (main + co-owners) at submission — this is the gap that started the ticket, and it closes even if nothing else ships. New `NotificationKind`; reuses `notify()`'s dedup semantics.
- [ ] Owner approvals join the request-more-info loop on the same terms as an area — an owner may ask a question rather than only approve or reject.
- [ ] COM-347's Edit Request re-derives the required approvals: make sure the owner approval re-derives correctly when ownership changed between submission and edit.
- [ ] Status derivation is **unchanged** — an owner rejection rejects the request exactly as an area rejection does. No new code, but it needs a test given the mixed-verdict case.

## Frontend

- [ ] Portal **My requests → To approve** includes requests with a pending owner approval on a vendor I own. Today that slice is populated from `vendor_approvers` rows and the tab shows on `canAssessVendors` — both need to admit the owning `vendor_user`, who satisfies neither.
- [ ] **My Vendors**: a badge on any vendor with a request awaiting my owner approval, linking to `/portal/requests?tab=approve&request=<id>`.
- [ ] Internal **Requests** tab: the owner approval renders as one more line in the shared approval list, labelled **Vendor Owner** rather than an area name, naming who the owners are. Decide actions for an admin, presented as on-behalf-of so it is not mistaken for the owner having signed.
- [ ] Edge states: "No owner — owner approval skipped" on a request against an unowned vendor; "Approved on submission (requester is the owner)" shown as the decision rather than a blank.

## Tests

- [ ] An owning `vendor_user` decides their own vendor's owner approval — and still 403s on an area approval and on the internal register.
- [ ] A `vendor_admin` who does not own the vendor is refused; a global `admin` is not.
- [ ] Requester-is-owner auto-approves at submission; no deadlock.
- [ ] `new_vendor` gets no owner approval; an unowned vendor gets none and the request still completes.
- [ ] Owner rejection rejects the request with every area approved.
- [ ] Ownership transferred mid-flight: the new owner decides, the old owner is refused.
- [ ] Admin on-behalf decision records on-behalf-of in the snapshot and the activity log.
- [ ] Owners are notified at submission; the portal approve slice and the My Vendors badge both surface it for a `vendor_user`.