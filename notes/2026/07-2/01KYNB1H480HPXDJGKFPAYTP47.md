---
id: 01KYNB1H480HPXDJGKFPAYTP47
created: 2026-07-28T21:45:39.208026Z
updated: 2026-08-05T19:29:41.509289Z
type: task
title: Status Pages overview summary
project: 01KX671DATY39VW6GWK3M2T3DN
number: 357
sprint: s9cqr80
blocked_by:
- 01KYNB0HDA8Z6HCTHHQ0ZN70YX
comments:
- id: 01KYNE970QXB8CWVXGX6R0N9N3
  author: Steve Vine
  at: 2026-07-28T22:42:16.727371Z
  text: |-
    Built and in review. PR #330 (stacked tip: #325 → #326 → #327 → #328 → #329 → #330), merged to staging.

    Delivered: worst_status rollup per page (worst tracked-service status; all services when nothing tracked; "unreachable" when the page can't be read) carried on the list read; new Status column with colour-coded badge; OverviewCard above the register — one calm all-operational line when green, count badges (outage / degraded / unreachable / undetermined of N providers) when not. Derived entirely from stored state, zero extra fetching.

    Gates: backend ruff/mypy/pytest green, frontend build + 435 vitest + prettier green.
assignee: steve
priority: medium
task_status: done
---
Pane-of-glass touch on the Status Pages list: current provider status at a glance.

- Summary card at the top of `StatusPagesPage.tsx`: all-green / N degraded / N unreachable across registered pages (derived from stored state — no extra fetching).
- Per-row worst-status badge (operational / degraded / outage / unreachable) + last-checked freshness, using `statusColors.ts` conventions.
- First candidate to drop if the sprint runs long (agreed at planning).

**Acceptance**: with mixed page states the summary counts are correct and each row's badge reflects its worst tracked-service status; all-green shows a calm all-operational state.