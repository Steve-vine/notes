---
id: 01KXGTJ5PC8FPY10J5KTSHP938
created: 2026-07-14T17:24:59.212068368Z
updated: 2026-07-19T21:30:30.044121691Z
type: task
title: Backend — editable & enrichable frameworks (CRUD, disable, descriptions, bulk import) (+ ADR)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 88
sprint: s7sxqts
assignee: steve
task_status: done
priority: medium
---
Backend for **M19 — Frameworks**. Turn the read-only framework library (frameworks + requirements) into governed, **editable and enrichable** in-app data — the framework-library analogue of M18/ADR 0027. Full CRUD, a reversible **disable**, a **guarded soft-delete**, and — the milestone's headline — a way to **add the missing requirement descriptions**. This reverses ADR 0027's "non-editable reference data" carve-out for frameworks; design decided in **ADR 0028** (project repo) — implement to it. Library writes are gated `require_library_write` (analyst/admin) per ADR 0026.

### Why (ADR 0028 context)

The 7 frameworks (M8–M13) were seeded as `ref,title` CSVs with **descriptions deliberately empty** — the standards' clause text is copyrighted, so Compass ships only the public control *names*. The fix is to make descriptions **user-editable** (an org pastes the text it's licensed for) and to **vendor descriptions only for the open frameworks**. The schema is already ready: `frameworks.description` / `framework_requirements.description` exist (nullable); both models carry Actor + SoftDelete + Timestamp mixins. Only a disable-status migration is new.

### Decisions (ADR 0028)

* **Descriptions are the enrichment vehicle (§1).** In-app editable description on requirements (and frameworks), filled **inline** and via a **bulk description import** (upload `ref,description` / `ref,title,description` CSV for one framework; match by `ref`; fill/update only rows in the file).
* **Vendor open frameworks only (§2).** Extend seed CSVs to optional `description` column; vendor real descriptions for **NIST CSF 2.0**, **HIPAA** (US-Gov public domain) and **Cyber Essentials** (Crown copyright / OGL). ISO/CIS/SOC 2/PCI stay blank in-repo, filled in-app.
* **Disable = derived visibility (§3).** `status: active | disabled` on both. A requirement is effectively hidden when its own status is `disabled` **OR** its framework is `disabled` — computed at read time, never bulk-written.
* **Delete = guarded soft-delete (§4).** `DELETE` sets `deleted_at` only when nothing references the row; else **409 "in use — disable instead"**. A requirement is "in use" if it has any non-deleted control-mappings; a framework if it has any non-deleted requirements.
* **Importer = insert-missing-only + blank-description backfill (§5).** Never updates an existing row's title/order; but if an existing requirement's description is null/empty and the CSV supplies one, **fill it — never overwrite a user-set value**.
* **Now audited (§6).** Add `frameworks`, `framework_requirements` to the allowlist.
* **Crosswalk unchanged (§7).** The `ControlMapping` model / `mappings` API / crosswalk UI are not touched; only the entities they point at.

### Checklist

- [ ] **Migration 0022**: add `status` to `frameworks` (new enum `framework_status` = `active|disabled`, default `active`, not null) and to `framework_requirements` (new enum `framework_requirement_status` = `active|disabled`, default `active`, not null). Backfill existing rows to `active`. Down-migration reverses. (No description columns — they already exist.)
- [ ] **Schemas** (`api/v1/schemas.py`): `FrameworkCreate` (name, version, slug, description?), `FrameworkUpdate` (all optional + status); `FrameworkRequirementCreate` (framework_id, ref, title, description?, display_order?, status?), `FrameworkRequirementUpdate` (all optional incl. status). Validate slug/ref non-empty; slug regex as for companies. A `RequirementDescriptionImport` shape for the bulk endpoint.
- [ ] **Frameworks router** (`api/v1/frameworks.py`, currently read-only): add `POST` (create; unique slug → 409), `PUT /{slug}` (sparse update incl. status toggle; unique slug if changed), `DELETE /{slug}` (guarded: 409 if non-deleted requirements exist). Add requirement endpoints: `POST /{slug}/requirements`, `PUT /{slug}/requirements/{ref}` (sparse, incl. status + description), `DELETE /{slug}/requirements/{ref}` (guarded: 409 if mappings exist). All mutations `require_library_write`; set `created_by`/`updated_by`.
- [ ] **Bulk description import**: `POST /{slug}/requirements/import-descriptions` (`require_library_write`) — accept a CSV (`ref,description` or `ref,title,description`), match by `ref` within the framework, fill/update only those rows, report applied/skipped/unmatched counts. Reuse the same matching as the seed backfill.
- [ ] **Effective-visibility filtering**: by default exclude disabled frameworks, and requirements that are disabled **or** whose framework is disabled, from `GET /frameworks`, `GET /frameworks/{slug}` requirement lists, framework **coverage** derivation (`coverage.py`), crosswalk/mapping pick-lists (`mappings.py`), and **global search** (`search.py`). Add opt-in `include_disabled=true` (library-write only). Keep `deleted_at IS NULL` everywhere.
- [ ] **Seed importer** (`seed/frameworks.py`): switch from upsert-in-place to **insert-missing-only** (create framework by slug / requirement by `(framework, ref)` if absent; never update existing title/order). Read the optional `description` CSV column; **blank-only backfill** existing requirements' descriptions (fill null/empty, never overwrite). Update the docstring (it currently says "idempotent / updates in place").
- [ ] **Vendor descriptions** for the open frameworks: extend `data/frameworks/nist-csf-2-0.csv`, `hipaa-2013.csv`, `cyber-essentials.csv` with a `description` column populated from the public-domain / OGL sources (attribute CE per OGL). Leave ISO/CIS/SOC 2/PCI CSVs as `ref,title` (or blank description).
- [ ] **Audit** (`db/audit.py`): add `frameworks`, `framework_requirements` to `_AUDITED_TABLES`.
- [ ] **Tests**: framework + requirement CRUD happy-paths; uniqueness 409s; disable hides from browse/coverage/crosswalk/search but retains rows + mappings; `include_disabled` shows them to writers; guarded-delete 409 when mapped/has-requirements + soft-delete when not; description edit (inline) + bulk import (applied/unmatched counts); importer no longer overwrites edited rows but blank-backfills descriptions; vendored NIST/HIPAA/CE descriptions seed on a fresh DB; permission gating (analyst writes; viewer/assessor 403).
- [ ] Regenerate OpenAPI schema for the frontend client.

Refs: ADR 0028 (this milestone), 0027 (the M18 pattern this mirrors), 0010 (framework/crosswalk model; posture is derived), 0023 (audit), 0026 (library write gate), 0017 (Frameworks section IA).

---
*Migrated from Linear [DEV-655](https://linear.app/stevevine/issue/DEV-655/backend-editable-and-enrichable-frameworks-crud-disable-descriptions) · created 2026-06-26 · completed 2026-06-26*  
*Related to (Linear): DEV-656*