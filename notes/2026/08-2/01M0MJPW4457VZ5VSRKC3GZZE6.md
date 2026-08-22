---
id: 01M0MJPW4457VZ5VSRKC3GZZE6
created: 2026-08-22T11:11:47.844234Z
updated: 2026-08-22T11:11:47.844234Z
type: task
title: Start Assessment — contacts modal, valid-until, tokens sent to the supplier, owners informed
assignee: steve
priority: medium
label: feature
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 358
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