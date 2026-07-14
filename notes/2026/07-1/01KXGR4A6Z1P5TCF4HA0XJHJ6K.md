---
id: 01KXGR4A6Z1P5TCF4HA0XJHJ6K
created: 2026-07-14T16:42:27.935359377Z
updated: 2026-07-14T16:42:37.679176419Z
type: task
title: Monorepo scaffolding & tooling
task_status: done
label:
- chore
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 3
sprint: s7hkfxa
---
Set up the monorepo skeleton and developer tooling per ADR 0008 (layout) and ADR 0002 (stack).

- [ ] `app/backend/`, `app/frontend/`, `chart/` layout
- [ ] uv project + Python 3.12, pinned deps
- [ ] ruff (lint + format), mypy/pyright, pytest configured
- [ ] Frontend: Vite + React + TS, ESLint + Prettier, vitest
- [ ] pre-commit hooks running the fast gates locally
- [ ] README / CONTRIBUTING pointing at decisions/ and brief/ways-of-working.md

Refs: ADR 0002, 0003, 0008, 0016.

---

## Agreed approach (plan)

Repo: `git@github.com:Steve-vine/compass.git` at `/Users/steve/code/compass`. Conventions mirror the sibling `redvektor` repo.

**Bootstrap:** scaffolding is committed directly to `main` and pushed (repo bootstrap — no CI/branch-protection yet). The branch+PR loop begins at <issue id="18043ba7-04c2-482f-9937-fa7cbaa551d2" href="https://linear.app/stevevine/issue/DEV-390/ci-pipeline-and-branch-protection">DEV-390</issue>.

**In scope:** repo dir skeleton; backend uv project + ruff/mypy/pytest config; frontend Vite/React/TS + ESLint/Prettier/vitest; pre-commit (ruff only); root docs (README, CONTRIBUTING, CLAUDE.md, .gitignore, .nvmrc). Just enough placeholder code that lint/type/test run green.

**Out of scope (later issues):** CI + branch protection → <issue id="18043ba7-04c2-482f-9937-fa7cbaa551d2" href="https://linear.app/stevevine/issue/DEV-390/ci-pipeline-and-branch-protection">DEV-390</issue> · FastAPI app → <issue id="69cbe30d-04be-4aff-a0e7-138a914ecc70" href="https://linear.app/stevevine/issue/DEV-391/backend-api-scaffolding-fastapi">DEV-391</issue> · DB/Alembic → <issue id="5848cfcb-6bb5-44d3-be70-e97b90a7c322" href="https://linear.app/stevevine/issue/DEV-392/database-foundation-sqlalchemy-alembic">DEV-392</issue> · Helm templates + migration hook + Dockerfiles → <issue id="f0a2a763-d31f-4369-8332-10ba499ec5a7" href="https://linear.app/stevevine/issue/DEV-396/deployment-and-observability-skeleton-helm">DEV-396</issue> · Tailwind/Radix + app shell → <issue id="ab20197d-023f-4ec8-866c-02093d28b9f3" href="https://linear.app/stevevine/issue/DEV-395/frontend-app-shell">DEV-395</issue> · `compose.yaml` → <issue id="5848cfcb-6bb5-44d3-be70-e97b90a7c322" href="https://linear.app/stevevine/issue/DEV-392/database-foundation-sqlalchemy-alembic">DEV-392</issue>. `chart/` is a placeholder only.

**Deliberate divergences from redvektor:** sync SQLAlchemy is the target (ADR 0002, wired later); **no coverage-% fail gate** (ADR 0016 — pragmatic testing); mypy (not pyright); runtime framework deps added by the issues that use them.

---
*Migrated from Linear [DEV-389](https://linear.app/stevevine/issue/DEV-389/monorepo-scaffolding-and-tooling) · created 2026-06-13 · completed 2026-06-13*  
*Related to (Linear): DEV-392, DEV-390, DEV-396, DEV-395*