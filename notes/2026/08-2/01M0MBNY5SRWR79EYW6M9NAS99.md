---
id: 01M0MBNY5SRWR79EYW6M9NAS99
created: 2026-08-22T09:08:57.145372Z
updated: 2026-09-01T13:55:50.4861Z
type: task
title: Portal Requests section — approvers decide from the user portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 349
sprint: sbph5q5
blocked_by:
- 01M0MBMZQNB1AKDM4KDXX5264N
comments:
- id: 01M0MHJ0X7DNHCC152YK762446
  author: Steve Vine
  at: 2026-08-22T10:51:40.327432Z
  text: |-
    Done — merged as #351 (1d17277).

    The two portal tabs ("My requests" and "My Approvals") are now one **Requests** tab with two slices. Which slices a reader gets is which slices they have; a reader with one gets **no tab strip at all** — one slice is not a choice, and a one-tab strip reads as a section with something missing. With both, the approve slice opens first: it is the half somebody else is blocked on.

    **Backend gating, as the ticket specified:** the queue read (list *and* detail) moves to `require_portal_read`. It was already scoped by the caller's `vendor_approvers` rows, so a caller who approves for nothing gets `[]` rather than a 403 — which is what lets the section render both slices without the client having to know its own roles. The decide route is untouched (`require_vendor_assess` + area membership + COM-346's self-approval rule), with a test asserting the widening did not reach the write.

    **Two things beyond the ticket:**

    1. `/portal/approvals` had to survive. `mail_render`'s per-kind map points approver notices at it, and those emails are already sent and cannot be edited — so the path stays as a redirect onto `?tab=approve`, and new notices point at `/portal/requests?tab=approve`. The per-kind map still lands the two halves of one event in different places, now on the same page.
    2. `PortalApprovalsPage.tsx` became `vendors/ApprovalQueue.tsx` (the slice, no page chrome) via `git mv`, so the diff reads as a rename rather than a delete plus an add.

    Tests as listed, plus the nav ones: approver and requester see the same single Requests tab, and a `viewer` — who approves nothing and submits nothing — is not offered the section at all.

    **One process note worth having:** the first push went red on Type-check. CI runs `npm run typecheck` (`tsc -b`), which caught a strict-null error that `npx tsc --noEmit` passed. Saved to memory; the local frontend gate is `npm run typecheck`, not bare `tsc`.
assignee: steve
label:
- feature
priority: medium
task_status: done
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