---
id: 01KYA2TD6CKHJYKJPB7KB0CYZD
created: 2026-07-24T12:50:18.444697Z
updated: 2026-07-24T16:09:50.490738Z
type: task
title: 'Settings → Spend limits: expose all spend/token caps for editing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 248
sprint: sthz8ne
comments:
- id: 01KYA9KASGP6QC66WZ9HGEJ276
  author: Steve Vine
  at: 2026-07-24T14:48:46.640283Z
  text: |-
    Done — PR #236 (feature/ise-248-expose-spend-caps → main), stacked on 247→249→250→251→252 (and complements ISE-253 for accurate token indicators).

    - Migration 0049 + SpendPolicy: 8 nullable override columns (NULL = env default), same fall-through as the existing ceiling/reserve override.
    - New spend.py `ai_limits(db, settings)` — the single effective-limits resolver (override ?? env), read at EVERY enforcement point so a raise is live with no redeploy: engine run token/iteration caps, the chat turn cap + history window (threaded onto _Turn so no DB session is held during the model call), and the assist / issue-chat refusal gates. Existing chat/engine/budget tests stay green (env defaults unchanged).
    - GET/PUT /ai-config/spend-limits now return a structured `limits` list — each cap with env_default, override, effective, and a current-usage indicator (usage_ratio + current/limit labels). "Current" per the task: today's provider/assist/issue-chat spend; the highest-spend conversation today; the largest chat turn / run by tokens over 24h. history-turns and tool-iterations carry no indicator (iteration count isn't stored per run — noted). Audited like the existing PUT.
    - SpendLimitsCard rebuilt into a full caps table: each editable (unit-aware input), with env-default hint and a 75/85/100% colour indicator. An override equal to the env default clears it back.

    Tests: backend (caps listed, override takes effect + returned, audited, migration-consistency green) and frontend (lists caps, shows 90% indicator, sends raised cap as override). Full mypy over 281 files green; 393 vitest green; build/prettier/eslint clean.

    That's all 7 Sprint 23 tasks in Review. Next: reset staging to main, merge the branches, regenerate combined API types, deploy staging.
assignee: steve
priority: medium
task_status: done
---
`SpendLimitsCard.tsx` edits only two knobs (daily ceiling + scheduled reserve, backed by the singleton `spend_policy` row). Every other cost/token control is env-only in `settings.py` and invisible to operators — this is the "black box": the 60k `ai_chat_max_tokens` cap that cut off an incident chat mid-investigation cannot even be seen in the UI, let alone raised.

Make the remaining caps runtime-overridable (extend `spend_policy` or add an `ai_limits` table + migration, mirroring the existing `PUT /ai-config/spend-limits` upsert + audit) and add them to the panel:

- `ai_chat_max_tokens` (60k per chat turn — the cap behind "This answer grew past its token budget")
- `ai_run_max_tokens` (200k per run) and `ai_run_max_tool_iterations` (12)
- `ai_chat_history_turns` (12)
- `ai_assist_daily_spend_share` (0.5) and `ai_assist_thread_spend_cap_usd` ($1)
- `ai_issue_chat_daily_spend_share` (0.5) and `ai_issue_chat_conversation_spend_cap_usd` ($1)

Show the env default vs any override, with a short description of what each cap protects against. Changes audited like the existing spend-limits PUT.

**Current value vs limit, with threshold indicator.** Alongside each limit, show the actual current spend/usage measured against it, with a colour indicator: **yellow at ≥75%**, **orange at ≥85%**, **red at 100%** of the limit. What "current" means per cap:

- Daily ceiling / daily shares → today's spend (provider total; assist and issue-chat spend vs their share of the ceiling).
- Thread / conversation spend caps → the highest-spend active conversation today.
- Per-turn/per-run token caps (`ai_chat_max_tokens`, `ai_run_max_tokens`, `ai_run_max_tool_iterations`) → the largest turn/run in the last 24h, so an operator can see how close real usage runs to the cap. Note: this depends on ISE-253 — budget-exceeded turns currently record 0 tokens, so the indicator would never show red without that fix.
- `ai_chat_history_turns` is a config value, not a spend — no indicator needed.

Acceptance: an admin can see, for every AI spend/token limit, how close current usage is to it (with 75/85/100% colour thresholds) and raise it from Settings without a redeploy.