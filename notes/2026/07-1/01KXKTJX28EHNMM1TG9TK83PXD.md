---
id: 01KXKTJX28EHNMM1TG9TK83PXD
created: 2026-07-15T21:23:06.440035146Z
updated: 2026-07-19T13:22:49.995983906Z
type: task
title: Break-glass verification drill
label:
- chore
- follow_up
task_status: backlog
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 77
sprint: sd1gs0p
blocked_by:
- 01KXKTH9X83EAWD6XMH200ZFJ9
- 01KXKTJ3FZSP86JFQYY7PCMV7Y
---
Exercise the break-glass path end to end and prove the controls fire — the ADR 0015 "periodically verified" promise, made an actual routine rather than an aspiration.

## The drill

On staging: set the bcrypt hash via the `ise-env-overrides` Secret → `POST /api/v1/auth/break-glass` → confirm the **audit rows** (`break_glass_login`), confirm the **DataDog alert fires** (ISE-75), confirm the **lockout** trips on repeated failures, then **rotate** the hash and record last-verified/last-used (ISE-76).

## What must be true first

- ISE-75 — the alert has to exist to be verified. A drill against a non-existent alert proves nothing.
- ISE-76 — somewhere to record that the drill happened and that rotation followed.

Also verify the `X-Forwarded-For` question from ISE-74: behind the proxy, is the per-IP lockout actually per-IP, or one bucket? The drill is where that surfaces.

Deliverable: a short runbook + a recorded first run. `chore`/`follow-up`. Blocked by ISE-75, ISE-76.