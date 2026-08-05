---
id: 01KYCP5HV9Y4NZH36Q01BN9MSX
created: 2026-07-25T13:06:55.465389Z
updated: 2026-08-05T11:55:26.66742Z
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
priority: medium
task_status: done
---
Final slice: the actual TV. Depends on ISE-292.

## Board tokens (decided 2026-07-25: token URL, not a viewer session on the TV)
- Per-board read-only token, created/revoked in Settings (admin), shown once on creation. As built: stored plaintext, reveal-once, unique-indexed — the real webhook-token pattern (the original "hashed at rest" line here was wrong about webhook tokens; see completion comment). Revocation kills the URL immediately.
- Public read router `api/board_public.py` — the inverse of `webhook_ingest.py`, no `require_user`. Exposes ONLY the two dashboard reads, token-scoped; 404 (never 401) on unknown/revoked token; per-token Redis rate limit (default 120/min).

## Wallboard screen (as built)
- Chromeless `/board/:token` (outside RequireAuth/AppLayout so a TV never bounces to /login): dark, fit-to-screen count-adaptive grid, never scrolls; status word always written; calm-dim green, slow alert glow (reduced-motion respected); padlock when latched; status age; tap a service → components board, auto-return after ~45 s idle; polls 10 s reading persisted status only. Green tail elides into "+N healthy" (WALL_TILE_CAP).
- "Open wallboard" button + Settings → Wallboard tab (mint/copy/revoke tokens).

## Freshness / staleness (as built)
- Single scalar covers both failure modes: age of the newest `last_evaluated_at` from the latest successful poll — grows if polls fail (no new value) OR the evaluator stalls (value stops advancing).
- **Stale at age > 90 s** (`STALE_AFTER_MS` in `dashboardStatus.ts`; ~3 missed 30 s beats): big orange banner + the always-visible top-right freshness text ("updated Xs ago") turns orange. Unknown/revoked token shows a distinct "board link is not valid" state, not stale.
- Follow-up candidates (not built): age compares the TV's `Date.now()` against the server timestamp — a drifted TV clock shifts the banner (ISE-198 clock-skew lesson suggests server-relative + client-monotonic); and no second-stage treatment (~15 min: dim tiles to "last known state") — at present a very stale board keeps full-colour tiles under the banner.

## Design
Mockup agreed 2026-07-25 (claude.ai/code/artifact/9259d51e-3ad3-412d-ad15-4032362000a0): calm-when-green; status word never colour-alone; padlock = latched, eye = incident acknowledged (deferred at first, added in follow-up 245c347); status age from triggered_at; warn/alert tiles show the tripped rule. Distilled into ui-brief.md + ADR 0053 in ISE-290.