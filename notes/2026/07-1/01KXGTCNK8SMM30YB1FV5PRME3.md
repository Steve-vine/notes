---
id: 01KXGTCNK8SMM30YB1FV5PRME3
created: 2026-07-14T17:21:58.888131064Z
updated: 2026-07-14T17:21:58.888131064Z
type: task
title: Backend — editable domains & controls (CRUD, disable, control detail) (+ ADR)
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 83
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