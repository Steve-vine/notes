---
id: 01KXGRT4534RJGZP2M2CT525FQ
created: 2026-07-14T16:54:22.627568567Z
updated: 2026-07-14T16:54:28.565793716Z
type: task
title: Email-based password reset (forgot-password)
task_status: done
label:
- follow_up
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 23
sprint: sz3kacg
---
Surfaced during <issue id="afcfa2b1-3773-4e20-9adc-ee2a78aa2d01" href="https://linear.app/stevevine/issue/DEV-393/auth-local-accounts-sessions-roles-api-tokens">DEV-393</issue>. Self-service change-password shipped, but **forgot-password (unauthenticated email-based reset)** was deferred because the project has no email/SMTP integration yet.

Build the full flow:

- [ ] An email/SMTP integration (config + likely a Celery task to send mail) — coordinate with <issue id="7f7d24b6-5a6f-4707-95aa-6ac2206631b3" href="https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check">DEV-416</issue> (Celery wiring).
- [ ] `POST /api/v1/auth/forgot-password` — issue a single-use, expiring reset token (stored hashed), email the link. No user enumeration in the response.
- [ ] `POST /api/v1/auth/reset-password` — consume the token, set the new password, invalidate outstanding sessions.
- [ ] Tests (token issue/consume/expiry; integration with a fake SMTP).

Depends on: <issue id="afcfa2b1-3773-4e20-9adc-ee2a78aa2d01" href="https://linear.app/stevevine/issue/DEV-393/auth-local-accounts-sessions-roles-api-tokens">DEV-393</issue> (auth). Likely depends on / pairs with <issue id="7f7d24b6-5a6f-4707-95aa-6ac2206631b3" href="https://linear.app/stevevine/issue/DEV-416/wire-celery-app-broker-workerbeat-readyz-broker-check">DEV-416</issue> (Celery). Refs: ADR 0007.

---
*Migrated from Linear [DEV-417](https://linear.app/stevevine/issue/DEV-417/email-based-password-reset-forgot-password) · created 2026-06-14 · completed 2026-06-16*  
*Related to (Linear): DEV-416, DEV-460, DEV-406, DEV-395*