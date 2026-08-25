---
id: 01KZVE0QF18BE3FYNN6DJ9621Y
created: 2026-08-12T16:48:47.073231Z
updated: 2026-08-25T18:42:58.921844Z
type: task
title: 'CI check scripts: migration heads, OpenAPI drift, migrations append-only'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 198
blocked_by:
- 01KZVE0B33XR2PKNJ5N1X8XPH1
comments:
- id: 01KZVFHHYE8R7XQK1YKGYQGFJ9
  author: Steve Vine
  at: 2026-08-12T17:15:27.053844Z
  text: |-
    Done — PR #191, all eight checks green. The new `migrations` job ran in **10s**.

    Three scripts in `scripts/ci/` (+ a README), each verified to pass on a clean tree and then deliberately broken to prove it fails:

    - **`check-single-migration-head.sh`** — added a scratch migration off `0050`, check reported both heads and exited 1.
    - **`check-openapi-drift.sh`** — added a scratch endpoint to `core/health.py`; check caught it, regenerated `schema.d.ts` (39 lines) and exited 1. Runs in ~7s.
    - **`check-migrations-append-only.sh`** — committed an edit to `0050` on a scratch branch; check named the file and exited 1.

    Only the append-only check is wired in so far, as a PR-only `migrations` job. The other two go to the trunk backstop in COM-199.

    **Two things worth flagging.**

    *The generator could not be pinned the way I planned.* `openapi-typescript@7.13.0` (the latest) peer-requires TypeScript `^5` and this project is on 6.0.3, so `npm install --save-dev` fails with ERESOLVE. Rather than force it in with `--legacy-peer-deps`, it stays out of the dependency tree and runs through `npx` at an **exact** version — the same isolation `uvx` already gives semgrep and pip-audit. The pin still matters and is the whole point: unpinned, the generator's next release would reformat the file and fail a byte-comparison check for no reason (COM-196's lesson). `generate:api` in `package.json` is pinned to the identical version so local regeneration and CI cannot disagree — those two are the thing to keep in step.

    *The drift check regenerates in place rather than diffing to a temp file.* A red run therefore leaves the fix already applied in the working tree, ready to commit. Side effect worth knowing: it silently overwrites a hand-edit of `schema.d.ts`, which is correct — that file is generated — but it does mean the check answers "does the committed file match the API", not "did anyone touch this file".

    Also confirmed no prettier step is needed: `schema.d.ts` is in both `.prettierignore` and `eslint.config.js` ignores, and raw generator output is byte-identical to what is committed.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
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