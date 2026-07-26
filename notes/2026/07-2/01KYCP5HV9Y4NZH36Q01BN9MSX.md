---
id: 01KYCP5HV9Y4NZH36Q01BN9MSX
created: 2026-07-25T13:06:55.465389Z
updated: 2026-07-26T09:52:51.941078Z
type: task
title: Wallboard mode + board tokens — chromeless TV route behind a signed token URL
project: 01KX671DATY39VW6GWK3M2T3DN
number: 293
sprint: sak4nk6
blocked_by:
- 01KYCP539ARNFDMNA74WG0BHCR
assignee: steve
priority: medium
task_status: backlog
---
Final slice: the actual TV. Depends on ISE-292.

## Board tokens (decided 2026-07-25: token URL, not a viewer session on the TV)
- Per-board read-only token, created/revoked in Settings (admin), shown once on creation, hashed at rest like webhook tokens. Revocation kills the URL immediately.
- New unauthenticated read router — the inverse of `webhook_ingest.py`, which is the pattern to copy for mounting without `require_user` and is currently the only public v1 surface. Exposes ONLY the two dashboard reads (service grid + per-service components), token-scoped; nothing else leaks past it. Cover the surface in the Dashboards ADR (written in ISE-290) — expand there if the section needs it.
- Rate-limit the public route modestly; 404 (not 401) on unknown token.

## Wallboard screen
- Chromeless `/board/{token}` route (Estate Explorer pop-out pattern — no nav, no chrome): service grid full-bleed, dark-friendly, tile text sized for across-the-room reading; tap/click a service → components board, auto-return after idle so the TV drifts back to the top level.
- **Fit-to-screen, never scroll**: the grid is count-adaptive — column count computed from tile count + viewport aspect, tiles shrink so everything fits one screen. Off-screen tiles are invisible exactly when nobody is at the keyboard, so scrolling is a hard no. Practical legibility ceiling ~16 service tiles; beyond that the answer is curation (enabled flag + order) — future option: token-scoped service subsets per board (not this sprint).
- Auto-refresh via React Query `refetchInterval` (~10s); show a stale-data indicator if polls start failing rather than freezing green.
- "Open wallboard" button on the Dashboards screen (with token picker) for smoke-testing the exact TV view.

## Design
Mockup agreed 2026-07-25 (claude.ai/code/artifact/9259d51e-3ad3-412d-ad15-4032362000a0): calm-when-green (dim deep-green OK tiles on near-black; warn/alert fully filled amber/red, slow glow on alert, reduced-motion respected); status word always written (never colour-alone); padlock = latched, eye = incident acknowledged; status age from triggered_at; warn/alert tiles show the tripped rule. Distil into ui-brief.md in ISE-290.