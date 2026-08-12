---
id: 01KZVE174H56EM956HDRVNDZND
created: 2026-08-12T16:49:03.121877Z
updated: 2026-08-12T19:53:21.880266Z
type: task
title: Restructure ci.yml to the three triggers (PR gate, trunk backstop, pointer deploy)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 199
blocked_by:
- 01KZVE0QF18BE3FYNN6DJ9621Y
comments:
- id: 01KZVG8S64H8VMWJVA434031WT
  author: Steve Vine
  at: 2026-08-12T17:28:08.131977Z
  text: |-
    Done — PR #192, all checks green. The PR is graded by the pipeline it introduces (a `pull_request` run uses the workflow from the merge ref), so the new job names appearing on it *is* the test: `changes` 10s, `backend-static` 2m24s, `backend-test` 11m0s, `frontend` 3m29s, `migrations` 28s, `secret-scan` 18s, `deps-scan` 3m17s, `sast` 2m51s — with `backstop`, `build-images` and `deploy-staging` all correctly **skipping** on a PR.

    Everything in the task description landed: base filter dropped, backend split, `changes` job driving job-level skips, `backstop` on push→main, build/deploy gated on `refs/heads/staging` and needing only `secret-scan`, dispatch retained, curl timeouts added, and all the hard-won bits kept (setup-uv retry pair, zot pre-pull + docker.io mirror, buildx `network=host`, no `helm --wait`, explicit rollout + in-cluster `/readyz`).

    **One bug caught before it shipped.** I first wrote the backstop's `node-version-file: app/frontend/.nvmrc`, reasoning from the frontend job's `working-directory: app/frontend`. `.nvmrc` is actually at the **repo root**, and `node-version-file` resolves from the workspace — a job's `working-directory` default applies only to `run` steps, not to action inputs. The frontend job gets away with `.nvmrc` for exactly that reason. Fixed before pushing; noted in the file so the next person doesn't repeat it.

    **Honest note on timings — the split is not a pure win.** `backend-static` came back in **2m24s** against 7m44s–8m38s for the old combined job, which is the fast-feedback win. But `backend-test` took **11m0s**, *longer* than the old combined 8m38s. Two jobs each pay their own `uv sync`, and both ran while PR #193's run was live on the same self-hosted node. That is the blueprint's own warning about self-hosted runners sharing a machine, showing up on the first run. So for a full-code PR the wall-clock is currently no better and possibly slightly worse; the real saving is elsewhere and is much bigger — two of the three full-suite runs per task disappear, and a docs-only PR skips nearly everything. Worth a follow-up on runner serialisation if this persists (COM-188 was the same class of failure).
assignee: steve
label:
- improvement
priority: medium
task_status: done
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