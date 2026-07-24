---
id: 01KYA2V4QBTGCE9FQRX5R5ZVMA
created: 2026-07-24T12:50:42.539354Z
updated: 2026-07-24T12:51:14.534517Z
type: task
title: 'AI spend: replace By System with By Integration (daily breakdown)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 251
sprint: sthz8ne
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the "By system" section of `AISpendCard.tsx` with a "By Integration" section using the same daily-breakdown layout as ISE-249 (Last 30 Days | Today | previous 14 days, + Total row).

Data note: there is no separate Integration model — a `System` row *is* the integration instance (the UI already says "Add integration"; `System.connector_type` names the Integration Type per ADR 0031). So this is largely a rename of the existing `GROUP BY agent_run.system_id` dimension, keeping the "Estate-wide" row for runs with `system_id IS NULL` (assist chat, estate-wide summaries). If a per-Type rollup (all DataDog instances together) turns out to be wanted too, that needs a join through `system.connector_type` — decide during implementation, default to per-instance as today.

Depends on the day-bucketed spend endpoint from ISE-249.