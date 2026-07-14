---
id: 01KXGRAHNECVCY3BP70X6P4BK3
created: 2026-07-14T16:45:52.174370082Z
updated: 2026-07-14T16:46:17.281513214Z
type: task
title: Company entity + default company
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 8
sprint: s7hkfxa
comments:
- id: 01KXGRB39RDY4XKHHGTQF3G833
  author: Steve Vine
  at: 2026-07-14T16:46:10.23272102Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 14:16 UTC]
    **Done building — moving to In Review.** PR: https://github.com/Steve-vine/compass/pull/7 (all 5 CI checks green)

    ## What was done
    - **`models/company.py`** — `Company` (`name`, `slug` unique, `is_default`, `status` active/archived); a **partial unique index** enforces at most one default.
    - **`db/mixins.py`** — `CompanyScopedMixin` (`company_id` FK, `ondelete=RESTRICT`): the per-company FK pattern Assessment/Gap/Risk adopt later (the "establish the pattern" deliverable).
    - **Migration `0003`** — creates `companies` + **seeds the default company** (`gen_random_uuid()`); reversible (drops the `company_status` enum on downgrade). Verified up→down→up with exactly one default.
    - **`api/v1/companies.py`** — list/detail (any authenticated user) + create/patch/archive (**admin**). One-default invariant switched atomically; duplicate slug → 409; archiving the default → 400.

    ## Decisions on the fly
    - **Mutations admin-only**, reads open to any authenticated user (companies are admin config; editors work on assessments).
    - **"Delete" = archive** (status), not hard delete (ADR 0005 ethos). The default can't be archived or unset directly — promote another instead.
    - **Default seeded in the migration** (deterministic via the Helm hook) rather than at app startup.
    - ruff: `require_role()` added to the B008 immutable-calls exemption (FastAPI factory pattern).

    ## Verification
    - ruff / format / mypy strict / unit + **integration (real Postgres + Redis)** — seed present, admin gating (403/401), CRUD, atomic default switch, archive rules, migration up *and* down. All green in CI.

    ## Acceptance criteria
    - [x] Company model (name, slug, is_default, status) + migration
    - [x] CRUD API under `/api/v1`
    - [x] Seed a default company (in migration `0003`)
    - [x] Establish the per-company FK pattern (`CompanyScopedMixin`)

    ## Out of scope
    "Current company" selection / global switcher backing data → with per-company data (DEV-401/402) + the frontend shell (DEV-395).
- id: 01KXGRBA618X6HEHBKJ464HXBM
  author: Steve Vine
  at: 2026-07-14T16:46:17.281377012Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 14:20 UTC]
    **Merged + verified — Done.** Squash-merged as `cb616d0` ([PR #7](https://github.com/Steve-vine/compass/pull/7)); post-merge `release.yml` rebuilt + pushed the image (incl. migration `0003` + default-company seed) — green.

    Next: **DEV-395** (Frontend app shell) — the last M1 brief, which completes the walking skeleton.
---
Introduce Company as the first-class scoping entity per ADR 0009.

- [ ] Company model (`name`, `slug`, `is_default`, `status`) + migration
- [ ] CRUD API under `/api/v1`
- [ ] Seed a default company so single-company operation has no friction
- [ ] Establish the per-company FK pattern other tables will adopt

Depends on: Database foundation. Refs: ADR 0009, 0015.

---
*Migrated from Linear [DEV-394](https://linear.app/stevevine/issue/DEV-394/company-entity-default-company) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-401, DEV-395, DEV-393*