---
id: 01KXGRE5NWNWF7R0QZ2WVSG0CH
created: 2026-07-14T16:47:50.972870903Z
updated: 2026-07-19T21:30:28.993010573Z
type: task
title: Domain & Core control models + import controls.csv
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 11
sprint: sz3kacg
comments:
- id: 01KXGREPQ0GTF7P4ST177H4YF2
  author: Steve Vine
  at: 2026-07-14T16:48:08.415674709Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 15:54 UTC]
    **Done — in review.** PR: https://github.com/Steve-vine/compass/pull/9 · branch `steve/dev-397-domain-core-control-models-import-controlscsv`.

    ### What was built
    - **Models** `Domain` and `CoreControl` (soft-deleted governance entities; mixins from `db/mixins.py`), `CoreControlStatus` enum (active/retired), registered in `models/__init__.py`.
    - **Migration** `0004_domains_and_core_controls` (down_revision `0003_companies`) — schema only, hand-authored in the `0003` house style. Alembic drift check reports no difference vs the models.
    - **Importer** — `controls.csv` vendored into the package (`compass_api/data/`, read via importlib.resources); `seed/controls.py` import_controls does an idempotent upsert (domain by slug, control by ref), wired as the `import-controls` CLI subcommand.
    - **Read API** (`/api/v1`, authenticated, read-only): list domains (with control_count), domain by slug, list controls (with domain filter), control by ref.
    - **Tests** `tests/test_controls.py` (integration): seeds 35/269, idempotency, list/detail/filter, 401/404.

    ### Decisions made on the fly
    1. **Domain naming** — strip a trailing " Policy" repeatedly rather than hard-coding the special case; turns "Access Control Policy" into "Access Control" and normalises the "Internal Audit Policy Policy" source quirk into "Internal Audit" generically.
    2. **Identifiers** — domains addressed by slug, controls by ref (supports the IA's "jump straight to ACC.4"); UUIDs remain the primary keys.
    3. **Soft-delete filtering** — reads filter out soft-deleted rows even though the importer never soft-deletes, so the API stays correct once curation lands.

    ### Note on counts (the "37 domains")
    `controls.csv` is authoritative → 35 domains / 269 controls (every Control ID matches PREFIX.N, no duplicate refs). The "37" in this issue / ADR 0010 is approximate: there are 36 policy PDFs incl. an "Artificial Intelligence Policy" that has no controls in the CSV. No action needed — flagging for the record.

    ### Problems encountered
    - Local `docker compose` v2 isn't available in this environment, so the live compose smoke ran against a throwaway postgres:16 container instead (migrate, import 35/269, idempotent re-run, hit the endpoints). Integration tests use testcontainers and cover both up and down migration.

    ### Checks
    ruff check · ruff format · mypy strict · pytest (22) · pytest integration (23) — all green.

    ### Follow-up
    Filing a follow-up for deploy-time auto-import (a Helm post-deploy job running the importer).
assignee: steve
task_status: done
priority: medium
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