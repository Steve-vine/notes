---
id: 01KXGRE5NWNWF7R0QZ2WVSG0CH
created: 2026-07-14T16:47:50.972870903Z
updated: 2026-07-14T16:47:50.972870903Z
type: task
title: Domain & Core control models + import controls.csv
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 11
---
Create the canonical Core control library and seed it from source per ADR 0010/0015. Domains/controls are the **shared, company-agnostic library** (ADR 0017 IA) — no company scoping.

**Agreed approach (plan-mode, 2026-06-14):**

**Models** (mirror `models/company.py`; mixins from `db/mixins.py`)

- [ ] `Domain` (`domains`): `name`, `slug` (unique), `description` (null), `display_order`. Soft-delete (governance entity).
- [ ] `CoreControl` (`core_controls`): `domain_id` FK→domains RESTRICT, `ref` (unique, e.g. `ACC.4`), `title` (Text), `description` (null), `status` enum `core_control_status` (`active|retired`, default `active`). Soft-delete.
- [ ] Register both in `models/__init__.py`.

**Migration** `0004_domains_and_core_controls` (down_revision `0003_companies`)

- [ ] Hand-authored in the `0003` house style; tables + enum + indexes/FKs. No data (importer seeds).

**Importer (re-runnable CLI)**

- [ ] Vendor `controls.csv` → `compass_api/data/controls.csv` (packaged, read via `importlib.resources`).
- [ ] `seed/controls.py::import_controls` — idempotent upsert (domain by `slug`, control by `ref`).
- [ ] `cli.py` `import-controls` subcommand (mirrors `create-admin`).

**Read API** under `/api/v1` (authenticated, no mutations)

- [ ] `GET /domains` (ordered by `display_order`, with `control_count`), `GET /domains/{slug}`.
- [ ] `GET /controls` (flat index by `ref`, optional `?domain=<slug>`), `GET /controls/{ref}`.
- [ ] `DomainOut` / `CoreControlOut` schemas.

**Tests** `tests/test_controls.py` (integration, testcontainers): importer counts + idempotency, API list/detail/filter, 401 + 404.

**Resolved forks (confirmed):**

1. `Domain.name` = CSV policy minus trailing  `Policy` → "Access Control" (special-case `Internal Audit Policy Policy` → "Internal Audit").
2. Control statement → `CoreControl.title`; `description` left null.
3. Seed via re-runnable CLI importer (not a data migration).

**Note on counts:** `controls.csv` is authoritative → **35 domains, 269 controls** (every `Control ID` matches `PREFIX.N`, no dup refs). The "37 domains" here/in ADR 0010 is approximate — there are 36 policy PDFs incl. an "Artificial Intelligence Policy" with no controls in the CSV.

**Out of scope → follow-up:** deploy-time auto-import (Helm job running `import-controls`).

Refs: ADR 0010, 0015, 0017. Source: `controls.csv`.

---
*Migrated from Linear [DEV-397](https://linear.app/stevevine/issue/DEV-397/domain-and-core-control-models-import-controlscsv) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-398*