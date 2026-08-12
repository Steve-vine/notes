---
id: 01KZVE174H56EM956HDRVNDZND
created: 2026-08-12T16:49:03.121877Z
updated: 2026-08-12T17:11:01.106133Z
type: task
title: Restructure ci.yml to the three triggers (PR gate, trunk backstop, pointer deploy)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 199
blocked_by:
- 01KZVE0QF18BE3FYNN6DJ9621Y
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The substantive pipeline change of ADR 0041. One full suite per task instead of three.

| trigger | jobs |
|---|---|
| any PR (**no base filter**) | `changes` → `backend-static` ‖ `backend-test` ‖ `frontend` ‖ `migrations` ‖ `secret-scan` ‖ `deps-scan` ‖ `sast` |
| push → `main` | `backstop` only — single migration head + OpenAPI drift. No build, no deploy. Target ~2 min. |
| push → `staging` | `secret-scan` → `build-images` → `deploy-staging`. **No tests.** |

- [ ] **Drop `branches: [main]` from `on.pull_request`** (`ci.yml:22`). Hard rule: with the filter a stacked PR targeting a parent branch gets *no checks at all*, and branch protection then blocks a merge that cannot be unblocked without disabling the gate.
- [ ] **Split `backend`** into `backend-static` (ruff check, ruff format, mypy strict) and `backend-test` (unit, zot pre-pull, integration). Today a missing blank line costs the whole ~6-minute serial chain. Leave `frontend` as one job — already short.
- [ ] **`changes` job + job-level `if:` skips**, computed with plain `git diff --name-only` against the base (no new third-party action; every action here is SHA-pinned). Use job-level skips, **never workflow-level `paths-ignore`** — a required check whose job never runs sits "Expected" forever, whereas a skipped job satisfies protection. **Never filter `secret-scan`.**
- [ ] **`backstop` job** on push→`main`: checkout, cached `setup-uv` + `uv sync`, `setup-node`, then the two COM-198 scripts.
- [ ] **`build-images` + `deploy-staging` gate on `refs/heads/staging`** and `needs: [secret-scan]` only — all five test jobs come off their `needs:`.
- [ ] Keep `workflow_dispatch` (recovery path for GitHub silently dropping a push event — COM-190). On `staging` it now means "rebuild and redeploy this commit".
- [ ] Add `--connect-timeout 5 --max-time 30` to the deploy smoke-check curls so a stalled TCP connect fails fast into the retry loop instead of hanging the step.
- [ ] Retain unchanged: the `setup-uv` retry pair, zot pre-pull + docker.io mirror, buildx `network=host` (MTU), no `helm --wait`, the explicit rollout + in-cluster `/readyz` checks.

Verification: `pull_request` runs use the workflow from the merge ref, so **the restructured pipeline self-tests on its own PR** — confirm the new job names appear, a docs-only commit skips backend/frontend but still runs `secret-scan`, and static failures return in ~1 min.

Branch `feature/com-199-trunk-ci-pipeline`. ⚠️ Do not merge before the COM-200 protection update — see that task.