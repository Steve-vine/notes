---
id: 01KXGT9EY5FCVZQFCKZ8P892F7
created: 2026-07-14T17:20:13.765899313Z
updated: 2026-09-01T13:55:55.20126Z
type: task
title: 'Candidate: Email sending capability — configure options for integrating with different email systems'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 79
order: 2.0
comments:
- id: 01M0687KEV0A1T7691R4WHCCQG
  author: Steve Vine
  at: 2026-08-16T21:39:19.643707Z
  text: 'Superseded by the "Email delivery" sprint (COM-230…COM-234), created 2026-08-16 from the model proven in ISE sprint 67 (ISE-743…748/750). Every scope question this candidate raised is now decided there: multiple backends → four transports (SendGrid COM-230, SMTP COM-231, M365 Graph COM-232, SES COM-233) as encrypted-credential rows with one DB-enforced active sender; config surface → Admin ▸ Email, not env/values (the env question is an explicit ADR decision in COM-230); reliability/worker sends and the consumers → COM-234; deliverability + bounce handling parked in the ADR''s consequences. Mailpit stays, as just another SMTP transport.'
assignee: steve
label: null
priority: medium
task_status: cancelled
---
**Candidate for M17 — to scope and commit, not yet a committed brief.**

Make Compass able to actually send email, with configurable integration options for different email systems/providers.

## Current state

* `core/email.send_email` is a **best-effort no-op when SMTP is unconfigured**; the reminders/notifications Beat job (`tasks/reminders.py`) batches per-owner digests and calls it (ADR 0006). So the *send path exists and is wired*, but there's no real outbound delivery configured in prod.
* Dev uses **Mailpit** (in the `compass` namespace) to catch mail; nothing leaves the cluster.
* The password-reset flow and reminder digests are the current consumers; review-due / treatment-overdue notifications would benefit from real delivery.

## Scope to decide

* **Integration options** — support more than one backend and make it config-driven (env/values):
  * **SMTP relay** (generic; e.g. an internal relay, Google Workspace SMTP, Mailgun/SES SMTP interface).
  * **Provider API** — Amazon **SES**, **SendGrid**, **Postmark**, or similar (better deliverability/observability than raw SMTP).
  * Keep **Mailpit/no-op** as the dev/test default.
* **Config surface** — `EMAIL_BACKEND` + per-backend settings (host/port/credentials via secrets; from-address; reply-to), surfaced through the Helm chart values and (prod) the ExternalSecrets path.
* **Deliverability** — from-domain, SPF/DKIM/DMARC notes, bounce/complaint handling (esp. SES).
* **Reliability** — send via the Celery worker (retries, idempotency), not in-request; templating for the digest/reset emails.
* **Observability** — log/metric on send success/failure (respect the log-redaction list — no full addresses/bodies in logs).

## Open questions

* Which provider(s) to prioritise — generic SMTP first (lowest friction) vs an API backend for deliverability?
* Does this warrant a short ADR (new outbound-integration subsystem) or is it config under ADR 0006?
* Tie-in with M17's prod-readiness items (S3 storage <issue id="5b42de08-9dc5-4fa8-9994-249ce6e634e5" href="https://linear.app/stevevine/issue/DEV-423/s3-storage-backend-for-attachments">DEV-423</issue>, SSO) — all part of "make it production-grade".

Refs: ADR 0006 (Celery/Beat), `core/email.py`, `tasks/reminders.py`.

---
*Migrated from Linear [DEV-518](https://linear.app/stevevine/issue/DEV-518/candidate-email-sending-capability-configure-options-for-integrating) · created 2026-06-20*  
*Related to (Linear): DEV-410, DEV-423*