---
id: 01KXGTCNK8SMM30YB1FV5PRME3
created: 2026-07-14T17:21:58.888131064Z
updated: 2026-07-19T21:30:31.046271897Z
type: task
title: Backend — editable domains & controls (CRUD, disable, control detail) (+ ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 83
sprint: s114vjm
comments:
- id: 01KXGTD6Q1K2M8ZJBDW9BVJG54
  author: Steve Vine
  at: 2026-07-14T17:22:16.417591239Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-25 13:38 UTC]
    Done — PR [#76](https://github.com/Steve-vine/compass/pull/76), branch `steve/dev-628-backend-editable-domains-controls-crud-disable-control`.

    **What was built** (to ADR 0027): migration 0020 (`domains.status`; `core_control_status` `active|retired`→`active|disabled`); Create/Update schemas + `POST/PUT/DELETE` for domains and controls under `require_library_write`; `core/visibility.py` effective-visibility clauses wired into browse, assessment queue, coverage, crosswalk pick-list, search and the dashboard rollup; writer-only `include_disabled`; guarded delete (409 "disable instead"); `CoreControlDetail` enrichment; insert-missing-only importer; `domains`/`core_controls` added to the audit allowlist.

    **Verification**: 15 cases in `test_controls.py` + the 8 affected modules (coverage/search/dashboard/mappings/assessments/activity/reports/soa) all green; `ruff` + `mypy` clean. Frontend OpenAPI types regenerated.

    **Decisions made on the fly** (worth a look at review):
    1. **Disable reuses the control `status` enum** via Postgres `RENAME VALUE` (`retired`→`disabled`) rather than a new column — `retired` was unused, and this gives domains/controls one shared vocabulary with a trivial migration.
    2. **Control detail omits per-company risk links.** The brief listed "linked risks", but risk↔control links are Company-section data (ADR 0026); surfacing them on a Library page would leak company posture to an analyst-only user. Detail returns domain + mapped requirements + linked content + linked decisions (all Library). Risk links can live in the company-scoped "Assess for {company}" section on the frontend (DEV-629) if wanted.
    3. **Dashboard rollup also gets the visibility filter** (beyond the brief's enumerated surfaces) — otherwise a disabled domain still appeared on the dashboard, contradicting "no longer appears". Denominator + numerator filtered together to keep ratios consistent.

    **Problem encountered**: the first migration revision id (`0020_editable_domains_and_controls`, 34 chars) overflowed alembic's `version_num varchar(32)` — shortened to `0020_editable_domains_controls`.

    Moving to **In Review**. Frontend brief [DEV-629](https://linear.app/stevevine/issue/DEV-629) builds on this.
assignee: steve
task_status: done
priority: medium
---
Backend for **M18 — Domains & Controls Editing**. Make the read-only Core library (domains + controls) **editable**: full CRUD, a reversible **disable**, a **guarded soft-delete**, and the data the new control detail page needs. This reverses the read-only-Core stance of ADR 0014 for the shared library (ADR 0010); design decided in **ADR 0027** (project repo) — implement to it. Library writes are gated `require_library_write` (analyst/admin) per ADR 0026.

### Decisions (ADR 0027)

* **Disable = derived visibility.** Unify on `status: active | disabled`. Domain gains `status`; control's enum migrates `active|retired → active|disabled`. A control is effectively hidden when its own status is `disabled` **OR** its domain is `disabled` — computed at read time, never bulk-written. Disabling a domain hides all its controls; re-enabling restores each control to its own state.
* **Delete = guarded soft-delete.** `DELETE` sets `deleted_at` only when nothing references the row; otherwise **409 "in use — disable instead"**. A control is "in use" if it has assessments, gaps, control-mappings, risk-links or content-links; a domain if it has any non-deleted controls or content.
* **Seed import = insert-missing-only.** The domain/control importer creates rows absent by slug/ref and **never updates** existing rows, so user edits survive redeploys.
* Domains and controls are **now audited** (ADR 0023) — add to the allowlist.

### Checklist

- [ ] **Migration 0020**: add `status` to `domains` (new enum `domain_status` = `active|disabled`, default `active`, not null); migrate `core_controls.status` from `active|retired` → `active|disabled` (existing `active` stays; `retired` → `disabled`). Backfill existing rows to `active`. Down-migration reverses.
- [ ] **Schemas** (`api/v1/schemas.py`): `DomainCreate` (name, slug, description?, display_order?), `DomainUpdate` (all optional + status), `CoreControlCreate` (domain_id, ref, title, description?, status?), `CoreControlUpdate` (all optional incl. domain_id, status). Validate slug/ref non-empty; slug regex as for companies.
- [ ] **Domains router** (`api/v1/domains.py`): `POST` (create; unique slug → 409), `PUT /{slug}` (sparse update incl. status toggle; unique slug if changed), `DELETE /{slug}` (guarded soft-delete: 409 if non-deleted controls or content exist). All mutations `require_library_write`; set `created_by`/`updated_by`.
- [ ] **Controls router** (`api/v1/controls.py`): `POST` (create; validate domain FK; unique ref → 409), `PUT /{ref}` (sparse update incl. status toggle + domain reparent), `DELETE /{ref}` (guarded: 409 if assessments/gaps/mappings/risk-links/content-links exist). `require_library_write`.
- [ ] **Effective-visibility filtering**: by default exclude disabled domains, and controls that are disabled **or** whose domain is disabled, from `GET /domains`, `GET /controls`, the **assessment queue**, framework **coverage** derivation (`coverage.py`), crosswalk/mapping pick-lists, and **global search** (`search.py`). Add opt-in `include_disabled=true` (library-write only) so the management UI can list disabled items to re-enable. Keep `deleted_at IS NULL` everywhere.
- [ ] **Control detail enrichment**: ensure the control detail endpoint returns what the new page needs — domain, status, mapped framework requirements, linked content, linked decisions, linked risks. Reuse existing relations; add only what's missing.
- [ ] **Seed importer** (`seed/controls.py`): switch domain/control upsert to **insert-missing-only** (create by slug/ref if absent; never update existing).
- [ ] **Audit** (`db/audit.py`): add `domains`, `core_controls` to `_AUDITED_TABLES`.
- [ ] **Tests**: CRUD happy-paths; uniqueness 409s; disable hides from browse/queue/coverage/search but retains rows; `include_disabled` shows them to writers; guarded-delete 409 when in use + soft-delete when not; importer no longer overwrites edited rows; permission gating (analyst writes; viewer/assessor 403).
- [ ] Regenerate OpenAPI schema for the frontend client.

Refs: ADR 0027 (this milestone), 0010 (Core library), 0014 (read-only stance, now reversed), 0023 (audit), 0026 (library write gate), 0017 (control detail page).

---
*Migrated from Linear [DEV-628](https://linear.app/stevevine/issue/DEV-628/backend-editable-domains-and-controls-crud-disable-control-detail-adr) · created 2026-06-25 · completed 2026-06-25*  
*Related to (Linear): DEV-629, DEV-636*