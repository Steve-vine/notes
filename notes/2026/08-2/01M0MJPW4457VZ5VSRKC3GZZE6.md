---
id: 01M0MJPW4457VZ5VSRKC3GZZE6
created: 2026-08-22T11:11:47.844234Z
updated: 2026-08-25T18:43:02.983243Z
type: task
title: Start Assessment — contacts modal, valid-until, tokens sent to the supplier, owners informed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 358
sprint: sbph5q5
blocked_by:
- 01M0MJNY3KMPB0JHTTEVDS4SZS
- 01M0MJPBWS380PTTECM60DA63G
- 01M0MGQTSDP5EA24RXHPZSWPT9
comments:
- id: 01M0MWJWSV86TYN4MMXP4GQZW8
  author: Steve Vine
  at: 2026-08-22T14:04:23.227347Z
  text: |-
    Done — PR #360.

    **The modal.** Only compliance contacts listed — that flag is the addressing data it was built for. All ticked by default; `contact_ids` is explicit in the payload rather than implicit "all compliance contacts", because the one gesture the modal exists to support is *unticking* somebody and an implicit set would make that unrepresentable. Valid-until defaults to two weeks out.

    **Zero compliance contacts** gets a real answer, as asked: it says so and points at the Contacts card, with no Start offered. A ticked contact with no email address is caught the same way, per-contact, before Start becomes available.

    **One transaction, then the emails.** `core/vendor_assessment_start.py`, because it is four writes and two sends that must agree. Tokens, the transition and the activity-log line commit together or not at all — a token minted against an assessment that failed to open is a live credential to nothing, and an email announcing an assessment that was never opened is worse. Sends are enqueued *after* the commit (the COM-234 ordering): a worker dying loses an email somebody can chase; the reverse loses the fact that an assessment was ever sent, which nobody can.

    Token expiry is read after the flush, so this assessment's own `valid_until` is already part of "the latest across everything open".

    **`vendor_portal_base_url` is its own setting**, never falling back to `app_base_url`: different hosts, and emailing a supplier the employee app's address is the one thing the separate hostname exists to avoid. Unset, Start **refuses** with a 409 rather than sending a link to nowhere — tested.

    **The invite task takes the link, not an id.** Everything else is IDs per the task conventions; this is the exception because the plaintext token exists exactly once, in the transaction that minted it. Only its hash is stored, so there is nothing to look it up from. Documented as intended shape rather than left looking like a shortcut.

    **Owners get a direct send**, not a digest row — somebody has just written to their supplier on their behalf, and this is the one moment they can say "not that contact" before an answer comes back. Main owner and co-owners, through COM-222's single ownership definition. The log line names who it went to and until when.

    Also worth noting: the Assessments tab offers **Start** and **Complete** side by side on a pending assessment — both are real ways to get it answered, one via the supplier and one internally. Once open, only Complete remains: starting twice would mint a second set of links for one ask.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The launch flow: an assigned assessment goes live on the Vendor Portal and the right people hear about it.

## The modal (admin vendor detail, Assessments tab — COM-355)

- [ ] A **Start Assessment** button on each `pending` (assigned) assessment opens a modal with:
  - the vendor's **compliance contacts** (`VendorContact.compliance` — the addressing data that flag was built for), each with a checkbox, **all ticked by default**; contacts without the flag are not listed
  - a **valid until** date, defaulting to **two weeks from today**, editable via date picker (must be in the future)
  - **Start** and **Cancel**
- [ ] Zero compliance contacts is a real state the model allows — the modal must say so and point at the Contacts card rather than offering a Start that would email nobody.

## On Start (one backend transaction, vendor-write gated)

- [ ] Assessment `pending → open` with the chosen `valid_until` (the lifecycle task's transition).
- [ ] Per-contact portal tokens (re)generated for the **ticked** contacts (COM-357's model — regeneration revokes a contact's prior token; unticked contacts get nothing and keep nothing).
- [ ] **Email each ticked contact** their own link (Celery, `tasks/email.py` pattern: idempotent, IDs not objects). Content: which company is asking, which assessment, the expiry date, their personal URL.
- [ ] **Email all vendor owners** — main owner + co-owners (`vendor_ownership`) — informing them the assessment has been sent, to whom, and when it expires. Notification row + digest pattern where it fits, but this one warrants a direct send like the contact emails.
- [ ] Activity log: who started it, contacts addressed, valid-until.

- [ ] Tests: default date +14 days; untick excludes a contact from tokens and email; owner email covers main + co-owners; re-start after a re-assign regenerates tokens; email tasks idempotent on retry; zero-contact state blocks cleanly.