---
id: 01KYNB1H480HPXDJGKFPAYTP47
created: 2026-07-28T21:45:39.208026Z
updated: 2026-07-28T21:51:41.412736Z
type: task
title: Status Pages overview summary
project: 01KX671DATY39VW6GWK3M2T3DN
number: 357
sprint: s9cqr80
blocked_by:
- 01KYNB0HDA8Z6HCTHHQ0ZN70YX
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Pane-of-glass touch on the Status Pages list: current provider status at a glance.

- Summary card at the top of `StatusPagesPage.tsx`: all-green / N degraded / N unreachable across registered pages (derived from stored state — no extra fetching).
- Per-row worst-status badge (operational / degraded / outage / unreachable) + last-checked freshness, using `statusColors.ts` conventions.
- First candidate to drop if the sprint runs long (agreed at planning).

**Acceptance**: with mixed page states the summary counts are correct and each row's badge reflects its worst tracked-service status; all-green shows a calm all-operational state.