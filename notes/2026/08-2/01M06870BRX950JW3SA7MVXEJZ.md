---
id: 01M06870BRX950JW3SA7MVXEJZ
created: 2026-08-16T21:39:00.088434Z
updated: 2026-08-16T21:39:14.608404Z
type: task
title: Every notice goes through the platform — rewire the three existing senders
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 234
sprint: ssydm1m
blocked_by:
- 01M068503XXKPYFGD6AF6YCS8C
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Compass already emails three things, and all three go through `core/email.py`'s env-SMTP path — a silent no-op when `SMTP_HOST` is unset, plain-text-only when not, with no failure signal:

- **Password reset** — `tasks/email.py` (`send_password_reset_email`), enqueued from `api/v1/auth.py:111`.
- **Reminder digests** — `tasks/reminders.py:250` (`_send_digests`), hourly Beat, batched per owner across the five scans.
- **Vendor approval notices** — `core/vendor_requests.py:84` (`notify()`), called from `_fan_out_approvals` (:392, one per approver per required area) and `apply_derived_status` (:532, requester on approved/rejected/info_requested) — **synchronously inside the API request and its transaction**.

Rewire all three through `core/mail.send` ([COM-230]); retire the `core/email.py` path (or reduce it to whatever env fallback the ADR chose). Works with any one transport configured; needs none of the other three.

Stacks on [COM-230].

## The specific fixes

1. **`notify()`'s email moves to the worker.** A blocking SMTP/HTTPS call in the request path was tolerable while it was a no-op; against a real provider it is a slow request and a transaction holding locks while mail crosses the network. New idempotent Celery task, ID args only (CLAUDE.md), the `send_password_reset_email.delay(...)` shape — and the ISE-748 ordering lesson: **commit the thing that happened first, then attempt delivery.** A worker dying mid-send must lose the email, never the in-app notification row it announces. (The in-app `Notification` + dedup stays exactly where it is — only the send leaves the transaction.)
2. **HTML + plain-text alternative** for all three messages, with a link back to the app (`app_base_url`, as `_send_digests` and the reset link already do) — and **escape everything user- or vendor-derived**. Vendor names, request titles and content titles reach the renderer unfiltered; left raw in HTML, a `<` breaks the message and a crafted one injects markup into every recipient's inbox. ISE-747 shipped the escaping with a test; do the same.
3. **The gate, named** (the ISE-461/747 bug class). When no sender is active, or the active transport is disabled, the skip logs a warning naming **what was skipped and why**, and the reason is `mail.unavailable_reason()` — the same string Admin ▸ Email shows, so a failed delivery and the screen can never disagree. The current `"SMTP not configured; skipping email"` silent-warn disappears; refusing to send is fine, doing it invisibly is how "we stopped getting the approval emails" becomes an investigation instead of a glance at the admin tab.
4. **The test that fails without the gate:** switching the mechanism off stops mail arriving — across every way it can be off (no sender chosen / active transport disabled / transport deleted). ISE-747 wrote exactly this test and it caught the gate the first time.

Tests to update alongside: `tests/test_password_reset.py`, `tests/test_reminders.py` (they stub or assert the old `send_email`).

## Out of scope — but park it in the ADR, not nowhere

- **Deliverability** (SPF/DKIM/DMARC for the from-domain) and **bounce/complaint handling** — deployment concerns COM-79 raised; record them in the ADR's consequences.
- **Vendor questionnaire sending** — `models/vendor_contact.py`'s `compliance` flag is addressing data for a send feature that doesn't exist yet, and its recipients are external (vendor-domain) addresses, unlike everything above. A future sprint's headline consumer; this platform is what it will call.