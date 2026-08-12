---
id: 01KZVC8SMABF2R8C1VTQ2SMDAM
created: 2026-08-12T16:18:14.282948Z
updated: 2026-08-12T16:19:27.281984Z
type: task
title: Rename the dashboard join from groups to sources
project: 01KX671DATY39VW6GWK3M2T3DN
number: 672
sprint: sdshnf8
blocked_by:
- 01KZVC8BSQBE4B3533Y5CMW0H0
assignee: steve
label:
- chore
priority: medium
task_status: backlog
---
A pure rename, done **first** — the way Sprint 60 renamed the middle layer while it was still cheap. No behaviour change; every following task in this sprint builds on it.

**Backend**
- Migration (next free number after **0130** — re-check `origin/main`, a parallel sprint may have taken it): `dashboard_service_group` → `dashboard_service_source`, `group_entity_id` → `source_entity_id`, and rename the unique constraint and index to match (`uq_dashboard_service_group`, `ix_dashboard_service_group_service`). Migrations are append-only; a rename migration is fine, hand-editing a merged one is not.
- `models.py:2479-2500` — `DashboardServiceGroup` → `DashboardServiceSource`, relationship `DashboardService.groups` → `.sources`, docstring updated to say the source is a group, Business Application or Business Service.
- **Do NOT add a `source_type` column.** `entity.type` is the answer; a stored copy would drift. Type validation stays where it is today, in the API layer.
- `dashboards_api.py` — `_resolve_groups`/`_set_groups` → `_resolve_sources`/`_set_sources`, keeping the in-place reconcile that avoids tripping the unique constraint on flush ordering. `DashboardServiceWrite.group_entity_ids` → `source_entity_ids`; `DashboardServiceRead.groups: GroupRef[]` → `sources: SourceRef[]` where `SourceRef` is `{id, name, type}` (the `type` is needed by the next tasks and costs nothing now).
- Accepted types stay `{"group"}` in this task — widening is task 3's job, so a red CI here means the rename broke something, not the feature.
- `dashboards.py:39-50` `service_member_ids` iterates `service.sources`, still calling `group_members`.
- `board_public.py` is unaffected (the wall shows status, not configuration) — confirm, don't assume.

**Frontend**
- `DashboardsPage.tsx` — `ServiceDraft.group_entity_ids` → `source_entity_ids`, `draftFrom()` maps `service.sources.map(s => s.id)`, the MultiSelect keeps its "Groups" label for now.
- Regenerate types: `uv run python -m ISE_api.dump_openapi` then `npm run generate:api`.

**Tests**
- A **populated-data migration test**: migrate to N-1, insert a service with two group links, upgrade, assert both links survive with the same ids. Staging has ~12 services with real group links — an empty-schema migration test would prove nothing.
- Existing `test_dashboards_api.py` / `test_dashboard_evaluator.py` / `test_dashboard_board.py` and the frontend `Dashboards.test.tsx` should need only mechanical renames. If one needs a logic change, the rename is not a rename.

Gates: `ruff check .`, bare `uv run mypy` (both cover `migrations/` and `tests/`), `uv run pytest`, `npm run build`, `npm run format:check`, vitest.