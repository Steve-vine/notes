---
id: 01M3Q7G3ENKNQ8K39JH2JG6G7Z
created: 2026-09-29T18:40:40.405821Z
updated: 2026-09-29T18:40:43.990874Z
type: task
title: pyjwt 2.14.0 — CVE-2026-102274 fails the dependency scan on every PR
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 793
sprint: s3nfes0
assignee: steve
label:
- chore
priority: high
task_status: active
---
Found 2026-09-29 while merging the Breadcrumbs stack (PR #800's run 36612823015). The advisory was published today: `pip-audit (backend)` in the required `deps-scan` check now reports **pyjwt 2.13.0 — CVE-2026-102274, fixed in 2.14.0**. Nothing merges until it's fixed, whatever the PR touches.

## What changes

Nothing visible. Compass's sign-in tokens are handled by the fixed version of the library.

## Notes (technical)

- `app/backend/uv.lock` pins pyjwt 2.13.0. `pyproject.toml` asks for `pyjwt>=2.10`, so `uv lock --upgrade-package pyjwt` is enough. Raise the floor to `>=2.14` so a fresh resolve can't fall back to a vulnerable version.
- Run the auth tests (JWT issue/verify, SSO callback) against the new version.

**Done when:** `deps-scan` is green on main, and the Breadcrumbs PRs rebased onto it pass.