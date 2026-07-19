---
id: 01KXGRT4534RJGZP2M2CT525FQ
created: 2026-07-14T16:54:22.627568567Z
updated: 2026-07-19T21:30:28.700948184Z
type: task
title: Email-based password reset (forgot-password)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 23
sprint: sz3kacg
comments:
- id: 01KXGRTFDXKB5MQ32XJKH4QHFR
  author: Steve Vine
  at: 2026-07-14T16:54:34.17328019Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-16 19:31 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/24

    All checklist items delivered:
    - **SMTP integration + Celery task** — `core/email.py` (stdlib smtplib) + `tasks/email.py::send_password_reset_email`, enqueued from the endpoint. Chart points at the in-cluster **mailpit** (`mailpit:1025`).
    - **`POST /auth/forgot-password`** — single-use, expiring token stored hashed in **Redis** (key = SHA-256(token), TTL); emails the link; **always 202, no enumeration** (token only for an active local account).
    - **`POST /auth/reset-password`** — consumes the token (single-use), sets the new password, and **revokes all outstanding sessions**.
    - **Tests** — integration with Celery eager + a fake SMTP: issue→link→consume→change→session-kill, no-enumeration, single-use, bad-token.

    Design note: the reset token lives in **Redis with a TTL** (like sessions, ADR 0007) rather than a DB table — single-use via delete, auto-expiry, **no migration**. Frontend adds Forgot/Reset pages + a login link.

    Verification: backend ruff/mypy(src) clean, 27 unit + 53 integration pass; frontend eslint/tsc/prettier clean, 21 vitest pass; helm lint clean.

    Left at In Review. On merge + redeploy, the live flow works end-to-end (mailpit's web UI on `:8025` catches the emails) — say the word and I'll merge + roll the cluster.
assignee: steve
task_status: done
priority: medium
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