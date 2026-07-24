---
id: 01KYA2TX2WMVYYPJCY4P4NYSKR
created: 2026-07-24T12:50:34.71686Z
updated: 2026-07-24T14:43:03.713619Z
type: task
title: 'AI spend: By Task daily breakdown, reconciled with the AI models list'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 250
sprint: sthz8ne
comments:
- id: 01KYA7G60KFNBGQW371FY24QHZ
  author: Steve Vine
  at: 2026-07-24T14:12:06.291618Z
  text: |-
    Done — PR #233 (feature/ise-250-task-daily-breakdown → main), stacked on ISE-247 (#231) → ISE-249 (#232).

    - AISpendRead.by_task_daily reuses the ISE-249 day-bucketed shape. Rows are reconciled with the AI models list (ISE-247's ACTIVE_AI_TASK_TYPES/RETIRED_AI_TASK_TYPES): every active task type appears even at $0.00, and retired `analyse` appears ONLY when it has historical spend in the window, labelled "analyse (retired)". A dead task type can no longer silently linger in one list and be missing from the other.
    - Removed the old by_task_type / AITaskSpend (runs + 30-day total) — fully replaced by the reconciled daily table.
    - AISpendCard renders the By task DailySpendTable; By system stays a mini table until ISE-251.

    Test test_by_task_daily_reconciles_with_the_models_list covers all three cases. Updated the frontend spend fixtures across the page tests that render AISpendCard (they lacked the new required daily fields). All 393 vitest tests pass; backend green; build + prettier + eslint clean.
assignee: steve
label: null
priority: medium
task_status: review
---
Apply the same daily-breakdown layout as ISE-249 (Last 30 Days | Today | one column per previous day for 14 days, + Total row) to the "By task" section of `AISpendCard.tsx`, replacing the current runs/spend-over-30-days pair.

Reconciliation with the AI Models card (ISE-247): the task rows here must come from the same source of truth as the models list — every active task type appears (even at $0.00), and the retired `analyse` type appears only if it has historical spend in the window, marked retired. Today the section just echoes whatever `task_type` values happen to exist in `agent_run`, which is how a dead task type can silently linger in one list and be missing from the other.

Depends on the day-bucketed spend endpoint from ISE-249.