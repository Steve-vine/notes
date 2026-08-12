---
id: 01KZVE1KEDHWZ75V2TA2TTH3AB
created: 2026-08-12T16:49:15.725534Z
updated: 2026-08-12T17:28:58.845328Z
type: task
title: 'Cutover: branch protection contexts + reset staging to a pointer ref'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 200
blocked_by:
- 01KZVE174H56EM956HDRVNDZND
comments:
- id: 01KZVGAAPX77EA3FQ3F9DKWNR2
  author: Steve Vine
  at: 2026-08-12T17:28:58.844907Z
  text: |-
    Prepared and rehearsed, **deliberately not applied**. Payload staged and verified against the live settings; applying it now would break three of the four open PRs.

    **The hazard is worse than the task described.** I planned for one ordering constraint (swap contexts after #192 reports, before it merges). Preparing it exposed a second: PRs #190, #191 and #193 all branched from `main` and were graded by the **old** workflow, so they report `backend` and will *never* report `backend-static`/`backend-test`/`changes`. #192 reports only the new names. With `enforce_admins: true` there is no context set that satisfies both groups — whichever way protection is set, one group is unmergeable, and nobody can override it.

    So the swap has to sit *inside* the release, between the two groups:

    1. Merge **#190** (COM-197), **#191** (COM-198), **#193** (COM-201) — all report `backend` under current protection. ✅
    2. Rebase **#192** onto the new `main` (it is stacked on #191, which will have been squashed) → its run reports the new contexts.
    3. **Then** apply the protection swap.
    4. Merge **#192**. ✅
    5. `git push --force origin main:staging` once — `staging` carries merge commits not on `main`, so the first pointer move is not a fast-forward. Every push after that is.

    Payload staged at `scratchpad/protection.json`:

    ```
    gh api -X PUT repos/:owner/:repo/branches/main/protection --input protection.json
    ```
    → contexts `backend-static`, `backend-test`, `frontend`, `migrations`, `secret-scan`, `deps-scan`, `sast`; `strict: false`; `required_linear_history` and `enforce_admins` kept `true`.

    Current state for comparison: `contexts: [backend, frontend, secret-scan, deps-scan, sast]`, `strict: true`, `linear: true`, `admins: true`.

    Note `changes` is deliberately **not** a required context — it is a plumbing job that always runs, and requiring it adds nothing over requiring the jobs that depend on it.

    Remaining checklist items (backstop-only main run, pointer push, throwaway stacked PR, duration comparison) are all post-merge and belong to the release, not to this staging deploy.
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