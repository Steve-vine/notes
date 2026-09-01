---
id: 01M0MCR0CJNT3H24KAM2XSQKQQ
created: 2026-08-22T09:27:33.522994Z
updated: 2026-09-01T13:55:50.440505Z
type: task
title: Admins can delete a vendor completely — hard delete, purging the record and its graph
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 350
sprint: sbph5q5
comments:
- id: 01M0MNSAGRXEG2T2E84S0JVFE5
  author: Steve Vine
  at: 2026-08-22T12:05:33.848639Z
  text: |-
    Done — PR #354, merged to main.

    **Route: `DELETE /vendors/{id}/purge`**, not `?purge=true`. A query parameter would put a reversible act and an unrecoverable one behind the same URL and the same handler, and the two need different gates — which one dependency cannot express. A distinct path cannot be reached by accident.

    **Precondition (as recommended): already offboarded or soft-deleted.** A purge is the cleanup after a decision, never a shortcut around one. Admin only; the soft delete stays on the vendor-write gate, unchanged.

    **The graph** (`core/vendor_purge.py`). Order follows the constraints, not the model file: `vendor_onboarding_requests.engagement_id` is RESTRICT, so requests go before engagements.
    - Deleted by hand (the six RESTRICT children): requests, engagements, assessments, certifications, contacts, revisions
    - Left to the database (CASCADE from `vendors`): reviews, risk links, flag assignments, additional owners — plus everything cascading from those (review actions; approvals, messages, form answers; assessment answers; engagement data-type/entity links)
    - **Notifications carry no FK at all** — swept explicitly, or they outlive their subject as reminders about a vendor the recipient can no longer open. Both `vendor` and `vendor_onboarding_request` target types.

    **The audit line.** Deletes are Core statements, so the `before_flush` listener never sees them — the purge writes one hand-authored `ActivityLog` row instead of the dozen a unit of work would produce. That is the `data_types` reorder precedent (ADR 0023): the listener is per-entity and cannot say "these N deletions were one act". Written *before* the rows go, and it names the vendor.

    On the task's open question — "if the log line is not enough, say so": it is enough. The alternative (keeping revision rows for a vendor that no longer exists) is orphaned rows describing something unresolvable, which is worse than one line that reads correctly.

    Frontend: admin-only Danger Zone card, last on the Details tab, only on an offboarded vendor (a soft-deleted one 404s from that page), with a type-the-name confirm.

    Tests: every child table counted before (all 1) and after (all 0) — the "all 1" assertion matters, else "nothing left" would be trivially true; admin gate; precondition; soft-deleted route in; one log line; soft delete unchanged. Frontend: visibility by role and state, and the confirm gate.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Today `DELETE /vendors/{id}` is a soft delete (`deleted_at`, `vendors.py:390`) and offboarding is the governed exit. Neither actually removes anything — a test vendor, a duplicate, or a mistaken import stays in the database forever. Give **global `admin`** a true purge.

- [ ] **Admin only, not `vendor_admin`.** Unrecoverable destruction is a different act from running the register; the existing soft delete stays on the vendor-write gate for vendor_admins.
- [ ] New route (e.g. `DELETE /vendors/{id}?purge=true` or `POST /vendors/{id}/purge` — pick one and say why) that removes the vendor row **and its whole dependent graph**: contacts, engagements, certifications, reviews + review actions, assessments, flags assignments, risk links, additional owners, revisions, onboarding requests + approvals + messages. Verify which FKs already `ON DELETE CASCADE` and delete explicitly where they don't — no orphans.
- [ ] **Decide the precondition**: purge anything, or only a vendor that is already offboarded or soft-deleted? Recommendation: require one of those states, so the purge is a cleanup step, never a shortcut around the offboarding flow.
- [ ] **The audit log is the mitigation** (the ADR 0049 pattern): write an ActivityLog line carrying the vendor's name and id *before* the rows go, since nothing else will remember it existed. Vendor revisions die with the vendor — the log line is the surviving record; if that is not enough, say so on this task rather than keeping the revisions table rows orphaned.
- [ ] Frontend: a Delete-permanently action on the internal vendor page, admin-only, with a type-the-name confirm — this is the one button in the section that cannot be undone.
- [ ] Tests: full graph gone (count child rows before/after), non-admin 403, precondition enforced, activity log line written, soft delete unchanged.