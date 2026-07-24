---
id: 01KYA2TX2WMVYYPJCY4P4NYSKR
created: 2026-07-24T12:50:34.71686Z
updated: 2026-07-24T13:29:25.701713Z
type: task
title: 'AI spend: By Task daily breakdown, reconciled with the AI models list'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 250
sprint: sthz8ne
assignee: steve
priority: medium
task_status: backlog
---
Apply the same daily-breakdown layout as ISE-249 (Last 30 Days | Today | one column per previous day for 14 days, + Total row) to the "By task" section of `AISpendCard.tsx`, replacing the current runs/spend-over-30-days pair.

Reconciliation with the AI Models card (ISE-247): the task rows here must come from the same source of truth as the models list — every active task type appears (even at $0.00), and the retired `analyse` type appears only if it has historical spend in the window, marked retired. Today the section just echoes whatever `task_type` values happen to exist in `agent_run`, which is how a dead task type can silently linger in one list and be missing from the other.

Depends on the day-bucketed spend endpoint from ISE-249.