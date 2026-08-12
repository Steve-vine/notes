---
id: 01KZVE1KEDHWZ75V2TA2TTH3AB
created: 2026-08-12T16:49:15.725534Z
updated: 2026-08-12T17:18:11.945122Z
type: task
title: 'Cutover: branch protection contexts + reset staging to a pointer ref'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 200
blocked_by:
- 01KZVE174H56EM956HDRVNDZND
assignee: steve
label:
- chore
priority: high
task_status: active
---
Ops task, no code. **Sequenced *inside* COM-199's release, not after it** — see the hazard.

⚠️ **Hazard:** `enforce_admins` is `true`, so the moment COM-199's PR renames the `backend` job, the required `backend` context can never report and the PR becomes unmergeable — including for Steve. The protection update must land **after** COM-199's PR run has reported the new contexts and **before** merging it. One `gh api` call, timed; no window where the trunk is unprotected.

- [ ] Required contexts → `backend-static`, `backend-test`, `frontend`, `migrations`, `secret-scan`, `deps-scan`, `sast` (replacing `backend`).
- [ ] Set `strict: false`. "Require branches up to date" is currently **on**, which with stacked PRs forces an update-and-re-run after every merge.
- [ ] Keep `required_linear_history: true` and `enforce_admins: true`.
- [ ] **One-time pointer reset:** `staging` currently carries merge commits not on `main`, so the first move is not a fast-forward. `git push --force origin main:staging` once at cutover; every push after that is a plain fast-forward. (`staging` is unprotected — no setting change needed.)

Proves the cutover:
- [ ] push→`main` after merging COM-199 shows **only** `backstop`, ~2 min, building nothing.
- [ ] `git push origin main:staging` builds both images, deploys, passes rollout status and both smoke checks. **Steve smoke-tests the staging UI** — the real proof the deploy path survived losing its test jobs.
- [ ] Open a throwaway stacked PR (branch off a feature branch) and confirm CI fires on it — the exact failure the base filter was causing.
- [ ] Compare `gh run list --workflow ci.yml` durations against the ~28 min/task baseline; expect ~8–10 min.