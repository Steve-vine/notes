---
id: 01KYCP5HV9Y4NZH36Q01BN9MSX
created: 2026-07-25T13:06:55.465389Z
updated: 2026-07-27T07:13:39.793456Z
type: task
title: Wallboard mode + board tokens — chromeless TV route behind a signed token URL
project: 01KX671DATY39VW6GWK3M2T3DN
number: 293
sprint: sak4nk6
blocked_by:
- 01KYCP539ARNFDMNA74WG0BHCR
comments:
- id: 01KYFNS8H0FAAG7XZTKRYZ9KNX
  author: Steve Vine
  at: 2026-07-26T16:57:56.000831Z
  text: |-
    Done — PR #282 (feature/ise-293-wallboard, stacked on #281).

    Built:
    - Migration 0057 + model: dashboard_board_token (name, token unique-indexed, created_by). Admin CRUD under /dashboards/board-tokens: create (reveal-once URL + board_path), list (never the secret), revoke — the webhook-token pattern.
    - Public read router api/board_public.py — the inverse of webhook_ingest: NO require_user, mounted before the v1 router. Exposes ONLY the two dashboard reads (grid + per-service components), token-scoped, 404 (never 401) on unknown/revoked token, per-token Redis rate limit (board_rate_limit_per_minute, default 120). Nothing else leaks past it.
    - Chromeless /board/:token wallboard: dark, fit-to-screen count-adaptive grid (never scrolls), status WORD always written, calm-dim green, slow alert glow (reduced-motion respected via CSS), padlock when latched, status age, stale indicator. Tap a service → components board, auto-returns after ~45s idle. Polls 10s. Outside RequireAuth/AppLayout so a TV never bounces to /login.
    - Settings → Wallboard tab (BoardTokensCard) + "Open wallboard" button on the Dashboards screen: mint a token, one-time URL with copy + open, revoke.

    Verified locally: real-Postgres board tests (admin-only mint, reveal-once, no-session public read, disabled-service exclusion, unknown/revoked → 404) + wallboard page tests green; mypy/ruff/build/lint/format clean.

    Design note on token storage: the task said "hashed at rest like webhook tokens", but webhook tokens are actually stored plaintext (reveal-once, unique-indexed, compared by equality). Followed the real webhook pattern for consistency — an internal wall URL, not a password. The "eye = incident acknowledged" tile marker from the mockup is deferred (status carries no ack signal today) — flagged as a small follow-up; padlock/glow/word/age/tripped-rule are all in.
assignee: steve
label: null
priority: medium
task_status: done
---
Final slice: the actual TV. Depends on ISE-292.

## Board tokens (decided 2026-07-25: token URL, not a viewer session on the TV)
- Per-board read-only token, created/revoked in Settings (admin), shown once on creation, hashed at rest like webhook tokens. Revocation kills the URL immediately.
- New unauthenticated read router — the inverse of `webhook_ingest.py`, which is the pattern to copy for mounting without `require_user` and is currently the only public v1 surface. Exposes ONLY the two dashboard reads (service grid + per-service components), token-scoped; nothing else leaks past it. Cover the surface in the Dashboards ADR (written in ISE-290) — expand there if the section needs it.
- Rate-limit the public route modestly; 404 (not 401) on unknown token.

## Wallboard screen
- Chromeless `/board/{token}` route (Estate Explorer pop-out pattern — no nav, no chrome): service grid full-bleed, dark-friendly, tile text sized for across-the-room reading; tap/click a service → components board, auto-return after idle so the TV drifts back to the top level.
- **Fit-to-screen, never scroll**: the grid is count-adaptive — column count computed from tile count + viewport aspect, tiles shrink so everything fits one screen. Off-screen tiles are invisible exactly when nobody is at the keyboard, so scrolling is a hard no. Practical legibility ceiling ~16 service tiles; beyond that the answer is curation (enabled flag + order) — future option: token-scoped service subsets per board (not this sprint).
- Auto-refresh via React Query `refetchInterval` (~10s), reading persisted status only.

## Freshness / staleness (agreed 2026-07-27)
- One freshness scalar covers both failure modes: data age derived from `last_evaluated_at` on the newest successful poll — grows if polls fail (no new value) OR the evaluator stalls (value stops advancing).
- **Stale banner at age > 90 s** (~2× the worst healthy case of 30 s beat + 10 s poll; three missed beats). Banner shows a live counter ("Data stale — last update 2 m ago").
- Age computed server-relative + client monotonic elapsed since response — never the TV's wall clock (ISE-198 clock-skew lesson).
- **At age > 15 min**: tiles dim/desaturate with a "last known state" treatment — a stale board must not keep looking confidently green.
- 404 (revoked/unknown token) is not stale: distinct full-screen "board unavailable" state immediately.

## Design
Mockup agreed 2026-07-25 (claude.ai/code/artifact/9259d51e-3ad3-412d-ad15-4032362000a0): calm-when-green (dim deep-green OK tiles on near-black; warn/alert fully filled amber/red, slow glow on alert, reduced-motion respected); status word always written (never colour-alone); padlock = latched, eye = incident acknowledged; status age from triggered_at; warn/alert tiles show the tripped rule. Distil into ui-brief.md in ISE-290.