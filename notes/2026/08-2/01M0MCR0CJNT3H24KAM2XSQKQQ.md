---
id: 01M0MCR0CJNT3H24KAM2XSQKQQ
created: 2026-08-22T09:27:33.522994Z
updated: 2026-08-22T09:27:36.987376Z
type: task
title: Admins can delete a vendor completely — hard delete, purging the record and its graph
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 350
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Today `DELETE /vendors/{id}` is a soft delete (`deleted_at`, `vendors.py:390`) and offboarding is the governed exit. Neither actually removes anything — a test vendor, a duplicate, or a mistaken import stays in the database forever. Give **global `admin`** a true purge.

- [ ] **Admin only, not `vendor_admin`.** Unrecoverable destruction is a different act from running the register; the existing soft delete stays on the vendor-write gate for vendor_admins.
- [ ] New route (e.g. `DELETE /vendors/{id}?purge=true` or `POST /vendors/{id}/purge` — pick one and say why) that removes the vendor row **and its whole dependent graph**: contacts, engagements, certifications, reviews + review actions, assessments, flags assignments, risk links, additional owners, revisions, onboarding requests + approvals + messages. Verify which FKs already `ON DELETE CASCADE` and delete explicitly where they don't — no orphans.
- [ ] **Decide the precondition**: purge anything, or only a vendor that is already offboarded or soft-deleted? Recommendation: require one of those states, so the purge is a cleanup step, never a shortcut around the offboarding flow.
- [ ] **The audit log is the mitigation** (the ADR 0049 pattern): write an ActivityLog line carrying the vendor's name and id *before* the rows go, since nothing else will remember it existed. Vendor revisions die with the vendor — the log line is the surviving record; if that is not enough, say so on this task rather than keeping the revisions table rows orphaned.
- [ ] Frontend: a Delete-permanently action on the internal vendor page, admin-only, with a type-the-name confirm — this is the one button in the section that cannot be undone.
- [ ] Tests: full graph gone (count child rows before/after), non-admin 403, precondition enforced, activity log line written, soft delete unchanged.