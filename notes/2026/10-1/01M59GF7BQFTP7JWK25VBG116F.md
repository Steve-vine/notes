---
id: 01M59GF7BQFTP7JWK25VBG116F
created: 2026-10-19T07:19:30.423464Z
updated: 2026-10-19T09:22:36.443442Z
type: task
title: The backend unit tests and the security scan finish in a couple of minutes, so they don't become the slowest check once the big two are faster
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1109
sprint: sjlj05e
comments:
- id: 01M59QGK8YRJT19G0K141PTXR3
  author: Steve Vine
  at: 2026-10-19T09:22:35.422326Z
  text: |-
    Merged in PR #1097 (2026-10-19).

    Security scan:
    - Now diff-aware (--baseline-commit at the merge base). It scans the changed files and fails only on findings the PR introduces: 2.4–8.8 min → 25s.
    - Found and fixed a gap. Under load, Semgrep gave up on files after three 5s rule timeouts and still exited 0; run 39177315004 skipped schemas.py, access_execute.py, directory_sync.py and others. Now --timeout 30 --timeout-threshold 0.
    - New weekly whole-tree scan (sast-full.yml, Mondays 05:17 UTC + manual), gating nothing, for new rules matching merged code.
    - scripts/ci/semgrep-scan.sh retries only when Semgrep fails to run (exit ≥2), never on findings.
    - Seeded subprocess shell=True → fails, as it should.

    Semgrep 1.181.0 is baked into runner image 2.336.0-20261019-0825 (pushed; the values file points at it). The script falls back to uvx until the roll. **Steve to run the helm upgrade** when no CI is in flight.

    Unit tests: -n 4 measured no faster (145s vs 144s serial). Collection imports all ~290 test modules and every worker repeats it, so I kept them serial. The job is 2.4 min after COM-1108, inside the 3-min target. Fixed a test whose random PEM in its test id made xdist workers disagree.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Start after sprint 76 is on staging.

## Why

Measured across PR runs on 2026-10-18/19:

| job | step | time |
|---|---|---|
| backend-unit | `pytest` (serial) | 3.6–5.2 min |
| sast | `uvx semgrep scan --config p/default` | 2.4–8.8 min |

The ci.yml comment says the unit suite was ~50s when it was split out (COM-332). It now runs one test at a time, with coverage. Semgrep downloads itself on every run (`uvx`, and the sast job doesn't restore the uv cache), fetches the `p/default` rules from semgrep.dev, then scans the whole repository.

Neither is the slowest check today, but once the integration and frontend jobs fall to ~10 minutes they will be close behind, and the variance (Semgrep 2.4 → 8.8 min) comes from the uplink.

## What changes

- The unit tests run in parallel.
- The security scan stops downloading itself every run, and on a PR it looks at what the PR changed, not the whole repository.
- The security bar doesn't move: a new finding still fails the PR.

## Notes (technical)

- Unit: `uv run pytest -n 4` (xdist is already a dev dependency). Check the unit suite is safe in parallel: tmp paths, env monkeypatching, module-level caches such as `get_settings`.
- Semgrep: pin it in the runner image (`scripts/infra/ci-runner-image/Dockerfile`), the same answer COM-327 gave uv/Node. Rolling the runner image is classifier-blocked; Steve runs the helm upgrade (memory: runner image rolls on g5). Keep a `uvx` fallback for a runner without it, as deploy-staging does for helm/kubectl.
- Rules: vendor a pinned copy of `p/default` into the repo (or the image), so a scan doesn't depend on semgrep.dev being reachable. Document how to refresh it.
- Diff-aware on PRs: `semgrep scan --baseline-commit "$(git merge-base origin/$BASE HEAD)"` reports only findings the PR introduces. It needs `fetch-depth: 0`. The whole-repo scan can keep running on main if wanted, gating nothing.
- Confirm the `nosemgrep` exemptions still behave (memory: Semgrep blocks interpolation), and that a deliberately bad line in a throwaway PR still fails.

**Done when:** backend-unit and sast each finish in under 3 minutes on a typical PR; Semgrep makes no network fetches in a normal run; a seeded finding still fails a PR.