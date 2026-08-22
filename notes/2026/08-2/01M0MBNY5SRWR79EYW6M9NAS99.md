---
id: 01M0MBNY5SRWR79EYW6M9NAS99
created: 2026-08-22T09:08:57.145372Z
updated: 2026-08-22T10:14:13.702472Z
type: task
title: Portal Requests section — approvers decide from the user portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 349
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
assignee: steve
label:
- feature
priority: medium
task_status: active
---
`vendor_approver` has no admin-portal access, so the portal grows a **Requests** section — the approver's home. Formalises the COM-226 direction (assessors already decide via the portal's shared `decide_from_body`); this gives that flow a proper surface instead of a borrowed one.

## Backend

- [ ] Portal queue read: the approver's slice — requests with an approval in one of **their** areas awaiting decision (`mine_to_approve` already exists on the internal queue; the portal wants the same shape on the portal router, portal-read gated).
- [ ] Decide stays on the shared `decide_from_body` — no new approval logic; the self-approval and membership gates apply identically through this door.

## Frontend

- [ ] "Requests" in the portal nav, visible to `vendor_approver` (and `vendor_admin`/`admin` when they use the portal); a `vendor_user` sees **their own submitted requests** here too — one section, two slices (mine to approve / mine submitted), rather than a second home for requesters elsewhere.
- [ ] Queue → request detail: the proposal, the transcript (COM-295/299), decide actions with the info-requested comment requirement, clear one-shot/decided states (409 handling).
- [ ] Empty states matter: an approver with nothing waiting, a user who has never submitted.

- [ ] Tests: approver sees only their areas' items; decide round-trips and the queue empties; vendor_user sees submitted-only; roles without either slice don't see the section.