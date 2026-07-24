---
id: 01KYA2TD6CKHJYKJPB7KB0CYZD
created: 2026-07-24T12:50:18.444697Z
updated: 2026-07-24T12:51:11.009884Z
type: task
title: 'Settings → Spend limits: expose all spend/token caps for editing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 248
sprint: sthz8ne
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
`SpendLimitsCard.tsx` edits only two knobs (daily ceiling + scheduled reserve, backed by the singleton `spend_policy` row). Every other cost/token control is env-only in `settings.py` and invisible to operators — this is the "black box": the 60k `ai_chat_max_tokens` cap that cut off an incident chat mid-investigation cannot even be seen in the UI, let alone raised.

Make the remaining caps runtime-overridable (extend `spend_policy` or add an `ai_limits` table + migration, mirroring the existing `PUT /ai-config/spend-limits` upsert + audit) and add them to the panel:

- `ai_chat_max_tokens` (60k per chat turn — the cap behind "This answer grew past its token budget")
- `ai_run_max_tokens` (200k per run) and `ai_run_max_tool_iterations` (12)
- `ai_chat_history_turns` (12)
- `ai_assist_daily_spend_share` (0.5) and `ai_assist_thread_spend_cap_usd` ($1)
- `ai_issue_chat_daily_spend_share` (0.5) and `ai_issue_chat_conversation_spend_cap_usd` ($1)

Show the env default vs any override, with a short description of what each cap protects against. Changes audited like the existing spend-limits PUT.

Acceptance: an admin can raise any AI spend/token limit from Settings without a redeploy.