---
id: 01KYCP5HV9Y4NZH36Q01BN9MSX
created: 2026-07-25T13:06:55.465389Z
updated: 2026-07-25T13:06:55.465389Z
type: task
title: Wallboard mode + board tokens — chromeless TV route behind a signed token URL
task_status: backlog
assignee: steve
label: feature
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 293
---
Final slice: the actual TV. Depends on ISE-292.

## Board tokens (decided 2026-07-25: token URL, not a viewer session on the TV)
- Per-board read-only token, created/revoked in Settings (admin), shown once on creation, hashed at rest like webhook tokens. Revocation kills the URL immediately.
- New unauthenticated read router — the inverse of `webhook_ingest.py`, which is the pattern to copy for mounting without `require_user` and is currently the only public v1 surface. Exposes ONLY the two dashboard reads (service grid + per-service components), token-scoped; nothing else leaks past it. Cover the surface in the Dashboards ADR (written in ISE-290) — expand there if the section needs it.
- Rate-limit the public route modestly; 404 (not 401) on unknown token.

## Wallboard screen
- Chromeless `/board/{token}` route (Estate Explorer pop-out pattern — no nav, no chrome): service grid full-bleed, dark-friendly, tile text sized for across-the-room reading; tap/click a service → components board, auto-return after idle so the TV drifts back to the top level.
- Auto-refresh via React Query `refetchInterval` (~10s); show a stale-data indicator if polls start failing rather than freezing green.
- "Open wallboard" button on the Dashboards screen (with token picker) for smoke-testing the exact TV view.