---
id: 01M0DCX28YDCY8SGR6HX4A3ZF9
created: 2026-08-19T16:15:38.270388Z
updated: 2026-08-19T16:48:17.18295Z
type: task
title: Vendor conversations — the thread, its participants, and the notifications that carry it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 291
sprint: sbph5q5
comments:
- id: 01M0DERV8YT3H0R8S5HMCM5MVC
  author: Steve Vine
  at: 2026-08-19T16:48:17.182502Z
  text: |-
    Cancelled the same day it was planned (Steve, 2026-08-19): a free-form vendor chat collides with the info-requested loop (COM-183) rather than complementing it — two channels asking the same question, and the reviewer would have to guess which one the owner is watching.

    The requirement stands; the answer changes. Instead of a second channel beside the formal one, the info-requested loop itself becomes conversational: a stored transcript of question and response, an 'Updated' status so both sides can see a reply landed, emails in both directions, and a requester view that can actually answer rather than only resubmit. COM-292 and COM-293 cancelled with it.

    Carried into the replacement tasks: the notification dedup trap (a second message announces nothing while due_on is null), the per-recipient email link, and the transcript's owner-gated visibility.
assignee: steve
label:
- feature
priority: medium
task_status: cancelled
---
A reviewer needs to ask the owner a question about a vendor, and the owner needs to ask back. Today the only channel is the **info-requested loop** (COM-183) — one approver comment, one resubmit, bound to an approval decision. Anything that is not "your answers are wrong, fix them" goes by email and leaves the record.

A conversation attached to the **vendor**, persisting across requests and reviews.

**Settled at planning (Steve, 2026-08-19):**

* **The info-requested loop is untouched.** It stays the formal gate — it blocks approval and resets on resubmit. This is the informal channel beside it. No change to the approval state machine.
* **Participants** are internal managers (`admin`, `vendor_manager`), the **approvers for this vendor**, and the vendor's **owners** (main + co-owners). Not every portal reader — the thread is not company-visible.
* Every message **emails the other side** with a link to the surface that recipient can actually reach.

Backend only; the two surfaces follow.

- [ ] **`vendor_messages`** — `vendor_id`, `author_id` (FK users, `SET NULL`: a message outlives its author's account, as `requested_by` does), `body`, `CompanyScopedMixin` + `TimestampMixin` + `ActorMixin`. Migration takes the next free number.
- [ ] **Order by `created_at`** — and say in a comment *why* that is safe here: messages are written one per transaction, so unlike COM-219's contacts they cannot share a `now()`. Otherwise someone reads the contacts lesson and adds a `position` nothing needs.
- [ ] **Read state**: `vendor_message_reads` — (`vendor_id`, `user_id`, `last_read_at`). Unread = messages on this vendor, newer than my `last_read_at`, **not authored by me**. One rule serves both directions of badge; per-message receipts would be heavier and answer nothing extra.
- [ ] **The participant gate is a new dependency, not a widened one** — ADR 0040's lesson. Define "approver for this vendor" precisely: a `vendor_approvers` row for an area that has a decision on one of this vendor's requests. Write it down, because "approves for something, somewhere" is the weaker question ADR 0043 warned against.
- [ ] **API**: list + post under the internal router; the same two under `/api/v1/portal/*` for owners. Post marks the thread read for its author.
- [ ] **Unread counts are batched** — one query for every vendor on screen, surfaced on the request-list payloads the two badge surfaces already fetch. The COM-223 `approver_names` precedent; not N+1.
- [ ] **Notification + email**: new `NotificationKind.vendor_message` against the existing `vendor` entity type, then `queue_notification_email` — notification committed first so a crash loses the email, never the record of it (the `vendor_requests` pattern).
- [ ] **The dedup trap COM-183 already hit**: with `due_on` null the exists-check suppresses a second notification, so a follow-up message would announce nothing. Delete-and-recreate so each message produces a fresh unread, as the resubmit path does.
- [ ] **The link is per-recipient**: an internal reviewer gets the internal vendor record, an owner gets the portal. One notification kind, two destinations, resolved from the recipient not the sender.
- [ ] Recipients = the participant set minus the author. A vendor with no owner notifies the managers alone rather than failing.
- [ ] Decide: are messages in the **activity log**? They are correspondence, not a governance state change — but `vendors` is an audited table and the answer should be deliberate.
- [ ] **Worth an ADR?** This is a third relationship-shaped gate (after ownership and approval, ADR 0043 §2) and it narrows ADR 0040's "the whole record renders" for the first time. Steve's call — but do not let it land as an undocumented access rule.
- [ ] OpenAPI regenerated → `schema.d.ts`.
- [ ] Tests: each participant class can read and post; a plain portal reader gets 403 both ways; unread excludes my own messages and respects `last_read_at`; two messages in a row produce two unread notifications; the email link differs by recipient.