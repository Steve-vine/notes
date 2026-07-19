---
id: 01KXKTGN1KBZ6ZCFBNRVX44JPJ
created: 2026-07-15T21:21:52.691086988Z
updated: 2026-07-19T13:23:30.265951797Z
type: task
title: API rate limiting — the doc already claims it
priority: high
task_status: backlog
label:
- feature
- brief
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 74
sprint: sd1gs0p
tech: null
---
**`security-model.md` is ahead of the code.** It states "The API rate-limits authentication endpoints and break-glass attempts" — but only **break-glass** is limited today (a hand-rolled Redis counter in `auth/break_glass.py`). `main.py` installs **no middleware of any kind**. `/auth/login`, `/auth/callback` (which makes unauthenticated outbound calls to Entra per request), `/auth/dev-login` and **all of `/api/v1`** are unthrottled.

## Scope

- A real rate-limit layer (library or middleware; there is none today). Cover the auth endpoints and `/api/v1`, tiered by cost — the Entra-calling callback and the AI-triggering endpoints matter most.
- **`X-Forwarded-For` handling.** Behind Traefik + the frontend nginx, `request.client.host` is a proxy IP — so the existing break-glass per-IP lockout may already be collapsing every caller into one bucket. Verify and fix as part of this.
- Bring `security-model.md` back in line with reality once it's true.

**New ADR** for the rate-limiting approach. Reuse the Valkey/Redis the session store and break-glass counter already use. Staging-first.