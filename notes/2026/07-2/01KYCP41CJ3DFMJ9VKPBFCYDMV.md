---
id: 01KYCP41CJ3DFMJ9VKPBFCYDMV
created: 2026-07-25T13:06:05.842105Z
updated: 2026-08-06T08:15:03.425033Z
type: task
title: Dashboard configuration — Service model, rules, curation UI (+ ADR)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 290
sprint: sak4nk6
comments:
- id: 01KYFKV29AHBZDC5BEANXX5GNA
  author: Steve Vine
  at: 2026-07-26T16:23:57.994235Z
  text: |-
    Done — PR #279 (feature/ise-290-dashboard-config → main).

    Built:
    - Migration 0056 + models: dashboard_service, dashboard_service_group (M2M to group entities), dashboard_rule (one table, two CHECK-constrained shapes — asset_count / signal_match), dashboard_service_status (latched level + age; evaluator writes it in ISE-291).
    - /api/v1/dashboards CRUD: viewer reads, operator/admin writes, audited. Group refs must resolve to real group entities; signal_match regex compiled/validated at save (typo fails in the editor); member_count unions the groups minus retired assets. Webhook-System findings excluded per design.
    - Shared dashboards.service_member_ids — the membership resolver the evaluator reuses.
    - Dashboards nav entry + /dashboards curation page (services, group multi-select, warn/alert rule editor, auto-clear toggles). ok/warn/alert/unknown added to the single statusColors.ts map.
    - ADR 0053 (dashboards; includes the public board-token posture decided here, built in ISE-293) + ui-brief Dashboards section. OpenAPI + TS types regenerated.

    Verified locally: real-Postgres API tests + migration-match + page tests green; mypy/ruff/build/lint/format clean.

    Note: ISE-293 says board tokens are "hashed at rest like webhook tokens", but webhook tokens are actually stored plaintext (reveal-once, unique-indexed, compared by equality). Followed the real webhook pattern for consistency — flagged for ISE-293.

    ADR number: 0051 is reserved by the Code Repos sprint's GitHub register, 0052 exists → Dashboards took 0053.
assignee: steve
priority: high
task_status: done
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