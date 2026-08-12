---
id: 01KZVE0B33XR2PKNJ5N1X8XPH1
created: 2026-08-12T16:48:34.403516Z
updated: 2026-08-12T16:55:08.360964Z
type: task
title: 'ADR 0041: trunk-based CI/CD (supersedes ADR 0036)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 197
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Record the move from the ADR 0036 staging-integration model to the trunk-based model in the Notuvia memo "Build & Deploy Blueprint — trunk-based CI/CD for a new project". Documentation only — no pipeline changes here.

Today the full suite runs three times per task (PR ~6m, push→staging ~12m, push→main ~10m ≈ **28 min/task**, ~17m of it re-testing trees the PR already tested). A `pull_request` run checks out `refs/pull/N/merge` — the merged result — so the post-merge re-runs judge an identical tree.

Decisions taken with Steve (2026-08-12):
- `main` becomes the integration surface; smoke-test defects are **fixed forward**.
- `staging` becomes a **pointer ref**, fast-forwarded to a tested trunk commit, never merged into.
- The pointer moves on **every merge to `main`**.
- Images build **only on the pointer push**, not on push→`main`.
- **Stacked PRs return** (Claude Code does the rebase/retarget).
- The pointer fast-forward stays a **manual CLI step** — a push made with the default `GITHUB_TOKEN` does not trigger workflows, so automating it would need a PAT/App token as a secret for no real gain.

- [ ] Add `decisions/0041-trunk-based-cicd.md` (Accepted, **Supersedes: 0036**) covering: the three triggers; trunk-as-integration + fix-forward; the pointer model; build-on-pointer-only; stacked PRs; branch-protection settings (`strict` off, new required contexts, `required_linear_history` + `enforce_admins` retained); why the pointer push is manual.
- [ ] Fill ADR 0036's existing `Superseded by: —` field with `0041`. That field exists for this; the body is not rewritten, so the append-only rule holds.
- [ ] Confirm no change needed to ADRs 0008, 0016 (gates/testing/DoD), 0020, 0037.

Branch `feature/com-197-adr-trunk-cicd`. Straight PR → `main`, no staging batch (nothing to smoke-test).