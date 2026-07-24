---
id: 01KYA2V4QBTGCE9FQRX5R5ZVMA
created: 2026-07-24T12:50:42.539354Z
updated: 2026-07-24T16:07:41.868121Z
type: task
title: 'AI spend: replace By System with By Integration (daily breakdown)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 251
sprint: sthz8ne
comments:
- id: 01KYA7TPK6XP1083EGVMTVV7D8
  author: Steve Vine
  at: 2026-07-24T14:17:50.950418Z
  text: |-
    Done — PR #234 (feature/ise-251-integration-daily-breakdown → main), stacked on ISE-247→249→250.

    - AISpendRead.by_integration_daily replaces by_system / AISystemSpend, reusing the ISE-249 daily shape. GROUP BY agent_run.system_id, most-expensive first; System names resolved server-side so the table carries labels; runs with no system (assist chat, estate-wide summaries) roll up under an "Estate-wide" row.
    - Per the task's data note, defaulted to per-instance (one row per System), not a per-Type rollup — that would need a join through system.connector_type and nobody's asked yet.
    - AISpendCard renders it as a third DailySpendTable ("By integration"). The card no longer needs the `systems` prop (labels come from the API) and the old MiniTable helper is gone.

    Test test_by_integration_daily_labels_and_estate_wide asserts a system's runs roll up under its resolved name. Frontend fixtures updated; 393 vitest tests pass; backend green; build + prettier + eslint clean.

    Note: the AISpendCard is now three stacked daily tables (By provider / By task / By integration) — consistent layout across all three dimensions.
assignee: steve
label: null
priority: medium
task_status: review
---
Replace the "By system" section of `AISpendCard.tsx` with a "By Integration" section using the same daily-breakdown layout as ISE-249 (Last 30 Days | Today | previous 14 days, + Total row).

Data note: there is no separate Integration model — a `System` row *is* the integration instance (the UI already says "Add integration"; `System.connector_type` names the Integration Type per ADR 0031). So this is largely a rename of the existing `GROUP BY agent_run.system_id` dimension, keeping the "Estate-wide" row for runs with `system_id IS NULL` (assist chat, estate-wide summaries). If a per-Type rollup (all DataDog instances together) turns out to be wanted too, that needs a join through `system.connector_type` — decide during implementation, default to per-instance as today.

Depends on the day-bucketed spend endpoint from ISE-249.