---
id: 01KZVE0QF18BE3FYNN6DJ9621Y
created: 2026-08-12T16:48:47.073231Z
updated: 2026-08-12T16:48:47.073231Z
type: task
title: 'CI check scripts: migration heads, OpenAPI drift, migrations append-only'
label: improvement
priority: medium
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 198
---
The three checks that the trunk backstop (COM-199) will run, written and verified first so the workflow change is just wiring. New `scripts/ci/`, alongside `scripts/infra/` and `scripts/m365/`. Each `set -euo pipefail` and runnable locally.

These are the *combinatorial* failures two independently-green PRs can cause — the things a second full suite never actually checked for.

- [ ] `check-single-migration-head.sh` — `uv run alembic heads` must print exactly one `(head)` line. Offline, no database. (Currently one head: `0051_vendor_request_kinds`.)
- [ ] `check-openapi-drift.sh` — dump the schema with placeholder `DATABASE_URL`/`SESSION_REDIS_URL`, **filter to the line containing `"openapi"`** (`create_app()` writes structured log lines to stdout first, which breaks the generator), run `openapi-typescript@^7` into `app/frontend/src/api/schema.d.ts`, then `git diff --exit-code` that path.
  - Verified 2026-08-12: raw generator output is **byte-identical** to the committed file, so this is green on day one and needs **no prettier step** — `schema.d.ts` is in `.prettierignore:5` and `eslint.config.js:9`.
- [ ] `check-migrations-append-only.sh` — `git diff --diff-filter=MD --name-only "$BASE...HEAD" -- app/backend/migrations/versions` must be empty. `$BASE` = the PR base ref, so a stacked PR is checked against its parent and the parent against `main`; together they cover the chain. Enforces a CLAUDE.md hard rule that currently has no enforcement.
- [ ] Wire **only** the append-only script into `ci.yml` now, as a lightweight `migrations` job on PRs (`fetch-depth: 0`). Additive and safe: not yet a required context, so it cannot block anything mid-transition.
- [ ] Prove each fails when it should, then revert: add a second migration head; touch `schema.d.ts`; edit a merged migration.

Branch `feature/com-198-ci-backstop-checks`. Straight PR → `main`.