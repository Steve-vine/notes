---
id: 01KYA2TD6CKHJYKJPB7KB0CYZD
created: 2026-07-24T12:50:18.444697Z
updated: 2026-07-24T14:43:12.908059Z
type: task
title: 'Settings → Spend limits: expose all spend/token caps for editing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 248
sprint: sthz8ne
assignee: steve
label: null
priority: medium
task_status: active
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