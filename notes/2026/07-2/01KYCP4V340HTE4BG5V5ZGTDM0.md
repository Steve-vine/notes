---
id: 01KYCP4V340HTE4BG5V5ZGTDM0
created: 2026-07-25T13:06:32.164702Z
updated: 2026-08-05T13:25:22.304092Z
type: task
title: Dashboard evaluator + service grid — latched status, manual clear, main board screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 291
sprint: sak4nk6
blocked_by:
- 01KYCP41CJ3DFMJ9VKPBFCYDMV
comments:
- id: 01KYFMG46ZDCSSW6QJ16CPWMZQ
  author: Steve Vine
  at: 2026-07-26T16:35:28.095607Z
  text: |-
    Done — PR #280 (feature/ise-291-dashboard-evaluator, stacked on #279).

    Built:
    - dashboards.evaluate_service/evaluate_all: rolls each service's members' present signals through its warn/alert rule sections. Severity floors (severity_at_least), alert-over-warn precedence, webhook-System findings excluded (no reliable all-clear), zero members → unknown. Latch model: each section holds a single effective-ON memory; a no-longer-active section stays ON only if auto-clear is off (held), else resets. triggered_at anchors status age; last_evaluated_at drives the stale indicator.
    - Celery beat evaluate_dashboards every 30s (sync queue, idempotent).
    - POST /dashboards/{id}/clear (operator, audited → cleared_by): releases latched sections then re-evaluates, so a still-firing condition re-trips rather than flashing green. 409 when nothing latched. Ack does NOT change tile colour (ADR 0038).
    - Board UI: /dashboards renders big filled status tiles (level colour + written word, member count/tripped-rule detail, status age "for 23m", padlock when latched, stale marker), polled 12s. Curation moved into a per-tile menu. Shared dashboardStatus helpers (tileBackground/levelWord/compactAge/isStale) so ISE-293's wallboard renders identically.

    Verified locally: real-Postgres evaluator tests (floors, precedence, webhook exclusion, latch + auto-clear + manual clear, unknown) + tile-helper + page tests green; mypy/ruff/build/lint/format clean.
assignee: steve
label: null
priority: high
task_status: done
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