---
id: 01M3WGXJDW9QFVKYW1SYF7ZZK6
created: 2026-10-01T20:01:31.068852Z
updated: 2026-10-08T16:21:17.602616Z
type: task
title: pypdf 6.17.0 — seven advisories fail the dependency scan on every PR
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 833
sprint: s3nfes0
comments:
- id: 01M3WHTEFS4JQ5368FD4EX236X
  author: Steve Vine
  at: 2026-10-01T20:17:17.305303Z
  text: 'Merged: PR #830 (e233c87). pypdf 6.17.0 → 6.19.0, floor raised in pyproject so the lock can''t resolve below the fix. The dependency scan is green again (was 7 advisories); the PDF tests pass on the new version (44 unit + 19 integration). Nothing to smoke-test — no visible change.'
assignee: steve
label:
- chore
priority: high
task_status: done
---
Found 2026-10-01 while landing the sprint 65 batch (COM-821..832): the PR dependency scan fails on **pypdf 6.17.0** — PYSEC-2026-4153, 4154, 4155, 4156, 4157, 4159 and 4160, **all fixed by 6.19.0**. Nothing merges until it's fixed, whatever the PR touches.

## What changes

Nothing anyone sees. Compass reads PDFs with this library; it moves to the fixed release.

## Notes (technical)

- pypdf is a direct dependency (`app/backend/pyproject.toml`, floor `>=6.16.1`). Raise the floor to `>=6.19.0` and `uv lock --upgrade-package pypdf`.
- No `[tool.uv]` table — semgrep's cooldown rule fires on it ([[uv-tool-table-needs-cooldown]]).
- Reproduce: `uv export --all-extras --no-emit-project --no-hashes --format requirements-txt -o r.txt && uvx --python 3.12 pip-audit -r r.txt --no-deps --disable-pip`.
- After it lands on main, rebase the open PRs so their merge refs pick it up.

**Done when:** the dependency scan is green on a PR again.