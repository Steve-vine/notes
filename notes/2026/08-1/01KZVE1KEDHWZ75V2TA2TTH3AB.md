---
id: 01KZVE1KEDHWZ75V2TA2TTH3AB
created: 2026-08-12T16:49:15.725534Z
updated: 2026-08-12T19:53:00.016974Z
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
- id: 01KZVGT40C667GZSYNBQ7W0SA2
  author: Steve Vine
  at: 2026-08-12T17:37:36.268606Z
  text: |-
    **Staging deploy done — and it ran on the new deploy path, which is the part of this task that could actually be proven now.**

    Rebuilt `staging` from `main` (already level, so no reset was needed) and mechanically merged all four branches — 197, 198, 199, 201, no conflicts. Ran the two backstop checks against the *combined* tree before pushing: one Alembic head, no contract drift. That is the first real use of them and the first time the combination has been checked for the things a second full suite never looked at.

    Because COM-199's `ci.yml` is in that merge, the push was graded by the **new** pipeline:

    ```
    secret-scan     success          33s
    changes         skipped
    backstop        skipped     (main-only)
    backend-static  skipped
    backend-test    skipped
    frontend        skipped
    migrations      skipped
    deps-scan       skipped
    sast            skipped
    build-images    success
    deploy-staging  success
    ```

    **Total 3m50s**, against ~12m for the previous staging pushes (COM-195, COM-196). Images `compass/{backend,frontend}:staging-20260812-1733`, rollout clean on all four deployments, both smoke checks passed, and `https://compass.citops.net/` returns 200.

    So the deploy path works with no tests on it, which was the open question. What remains unproven until the release: the backstop-only run on `main`, the pointer fast-forward, and a stacked PR getting CI.

    Note this staging deploy was a *mechanical merge*, i.e. the old ADR 0036 process, run one last time. The pointer cutover (`git push --force origin main:staging`) belongs to the release, per the sequence in the previous comment.
- id: 01KZVRJ1BGM6ZYGHDJBT18M26F
  author: Steve Vine
  at: 2026-08-12T19:53:00.016817Z
  text: |-
    **Cutover done. All four remaining checklist items proven.**

    Applied the protection swap in **two** steps rather than one, which the release showed was necessary. `strict: true` was still on, so merging #190 would have invalidated #191 and #193 and forced two needless full re-runs. So:

    - **Step A** (before merging anything): `strict: false`, contexts left as the *old* set. Safe in isolation — it only removes the up-to-date requirement.
    - Merged #190, #191, #193 under the old contexts.
    - Rebased #192 with `git rebase --onto origin/main 8b7b13f` → one clean commit; force-pushed; CI reported the new contexts.
    - **Step B**: swapped contexts to the new set. Merged #192.

    Final protection: contexts `backend-static`, `backend-test`, `frontend`, `migrations`, `secret-scan`, `deps-scan`, `sast`; `strict: false`; `linear: true`; `enforce_admins: true`; force-push off.

    **Verification**

    1. **Backstop-only main run** ✅ — first push to `main` under the new workflow ran `backstop` and skipped all ten other jobs. **Job time 45s** (checkout 1s, uv 6s, install 7s, node 14s, head check 0s, drift check 8s). The run's *wall clock* was 7m41s, but that is ARC runner-pod provisioning plus queueing behind the other merge runs — not work. Worth knowing the distinction: the backstop costs 45 seconds; getting a runner costs the rest.
    2. **Pointer fast-forward** ✅ — `git push --force origin origin/main:refs/heads/staging`. Before doing it I diffed the trees: `git diff origin/main origin/staging` was **empty**, i.e. the squash-merges produced byte-identical content to what staging had smoke-tested. Deploy run: 2m41s, secret-scan → build-images → deploy-staging, images `staging-20260812-1948`, site 200.
    3. **Stacked PR gets CI** ✅ — throwaway PR #194 with base `scratch/stacked-parent` (a feature branch). CI fired. Under the old `branches: [main]` filter it would have received nothing. Deleted afterwards.
    4. **Path filtering** ✅ — bonus from the same probe: that docs-only PR skipped backend, frontend, migrations, deps-scan and sast, while `secret-scan` still ran. **33s total.** Compare COM-201's docs-only PR under the old workflow: 8m0s in the `backend` job alone.

    **One behaviour worth recording.** The COM-198 push→`main` run shows `cancelled`. Not a failure: with `cancel-in-progress: false` GitHub allows one running + one *pending* run per concurrency group, and a newly queued run evicts the older pending one. Three rapid merges meant the middle run was evicted. Under the new model this means **rapid consecutive merges can skip intermediate backstop runs** — the tip still gets checked, and the tip is what gets deployed, so the guarantee that matters holds. But it does mean "every trunk commit gets a backstop" is not strictly true, and it is worth knowing before anyone relies on that phrasing.

    Duration comparison against the ~28 min/task baseline: PR 6m (`backend-static` 1m1s, `backend-test` 5m32s, uncontended) + backstop 45s of work + deploy 2m41s.
assignee: steve
label:
- chore
priority: high
task_status: review
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