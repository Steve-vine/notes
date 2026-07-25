---
id: 01KYCP4V340HTE4BG5V5ZGTDM0
created: 2026-07-25T13:06:32.164702Z
updated: 2026-07-25T17:33:45.66981Z
type: task
title: Dashboard evaluator + service grid — latched status, manual clear, main board screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 291
sprint: sak4nk6
blocked_by:
- 01KYCP41CJ3DFMJ9VKPBFCYDMV
assignee: steve
priority: high
task_status: backlog
---
Second slice: services actually go green/orange/red. Depends on ISE-290 (model + rules).

## Evaluator (Celery beat, ~30s)
- Idempotent task, takes no objects: for each enabled service, resolve members via `group_members()` over its groups, fetch present signals ("present" = ISE-229 definition in `signal_state_for_entities`: unresolved, not silenced, not `ignored`; webhook-System findings excluded), evaluate warn + alert rule sections, persist transitions to `dashboard_service_status`.
- Latch semantics: section with auto-clear OFF stays triggered when conditions drop, until manually cleared. Auto-clear ON resets on the first evaluation below threshold. Alert precedence over warn. Zero member entities → `unknown`, never `ok`.
- Transitions stamp `triggered_at`/`cleared_at` — the grid shows status age ("red for 23m").

## Manual clear
- Operator-role endpoint to clear a latched section; audit-logged (who/when → `cleared_by`). Clear button on the service tile. Acknowledged incidents do NOT change tile colour (ack = eyes-on, ADR 0038).

## Screen
- `GET /api/v1/dashboards` returns services + persisted status (reads only, no evaluation in GET).
- Main Dashboards screen: big service tiles readable at a distance (green/orange/red/grey), status age, latch indicator, manual clear. React Query `refetchInterval` ~10-15s per existing pattern. `statusColors.ts` stays the one colour mapping — add the ok/warn/alert bucket mapping there.