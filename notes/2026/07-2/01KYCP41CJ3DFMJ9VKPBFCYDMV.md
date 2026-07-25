---
id: 01KYCP41CJ3DFMJ9VKPBFCYDMV
created: 2026-07-25T13:06:05.842105Z
updated: 2026-07-25T17:31:18.400757Z
type: task
title: Dashboard configuration — Service model, rules, curation UI (+ ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 290
sprint: sak4nk6
assignee: steve
label: null
priority: high
task_status: backlog
---
Foundation slice of the wallboard Dashboards feature (design agreed 2026-07-25, recorded as a comment on the ISE Canon memo).

## Model + migration
- `dashboard_service` — name, display order, enabled, `warn_auto_clear`, `alert_auto_clear`.
- `dashboard_service_group` — M2M to entities of type `group` (1+ groups per service; tag-rule-backed groups compose, ADR 0037).
- `dashboard_rule` — service FK, `section` (`warn`|`alert`), `kind` (`asset_count`|`signal_match`), `threshold_count`, `severity`, `title_pattern`, order. One table, two shapes, CHECK-constrained per kind.
- `dashboard_service_status` — level (`ok`|`warn`|`alert`|`unknown`), per-section latched flags, `triggered_at`/`cleared_at`/`cleared_by`, `last_evaluated_at`. Written by the evaluator (next task), created here.

## Rule semantics (fixed by design)
- `asset_count`: "N or more member assets with <severity>-or-worse present signals" — severity is a minimum (`severity_at_least`).
- `signal_match`: signal title regex + severity. Validate regex at save time (compile, reject invalid, cap length) so typos fail in the editor, not the evaluator.
- Scope: Alerts and Observations joined to member entities only; findings from the synthetic webhook System (ADR 0048) are explicitly excluded — no reliable all-clear, services would latch forever.

## API + UI
- CRUD under `/api/v1/dashboards` (admin/operator for writes, viewer for reads).
- **Dashboards** nav entry (`components/nav.ts`). Curation UI: create/reorder services, attach groups (group picker), add/edit/remove warn + alert rules, auto-clear toggles per section.

## ADR (next free NNNN)
Dashboards: service = groups + rule set; warn/alert rule sections; latched status + manual clear; the board-token public read surface (built in the wallboard task, decided here). Fold the Canon comment (2026-07-25) into the Canon body — standing instruction.