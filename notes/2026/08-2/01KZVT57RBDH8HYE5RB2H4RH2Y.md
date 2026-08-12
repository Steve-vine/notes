---
id: 01KZVT57RBDH8HYE5RB2H4RH2Y
created: 2026-08-12T20:20:57.739513Z
updated: 2026-08-12T20:21:10.587908Z
type: task
title: 'Fail-safe the changes filter: a failed `changes` job must not skip the gate'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 202
assignee: steve
label:
- bug
priority: high
task_status: active
---
Gate-bypass defect introduced by COM-199. **Proven, not theoretical.**

If the `changes` job fails, every job with `needs: changes` is **skipped**, and GitHub counts a skipped required check as passing. Probe PR #195 (since deleted): touched `app/backend/`, forced `changes` to exit 1 → `backend-static`, `backend-test`, `frontend`, `migrations`, `deps-scan`, `sast` all skipped, `secret-scan` passed, and GitHub reported **`mergeable: MERGEABLE`**. A backend change could have merged with zero tests run.

This is the mirror of the hazard ADR 0041 records: a job that *never runs* blocks forever, while a *skipped* job satisfies protection. That asymmetry is what makes path filtering work — and what makes a failed filter job dangerous. COM-199 built the filter without closing the second side.

**Fix — make the workflow fail-safe rather than relying on protection config.** For every job with `needs: changes`:

```yaml
if: ${{ !cancelled() && github.event_name == 'pull_request'
        && (needs.changes.result != 'success' || needs.changes.outputs.<flag> == 'true') }}
```

A broken filter then runs **everything** instead of nothing.

- [ ] Apply to `backend-static`, `backend-test`, `migrations` (backend), `frontend` (frontend), `deps-scan`, `sast` (code).
- [ ] Keep the explicit `github.event_name == 'pull_request'` term — without it, `needs.changes.result == 'skipped'` on a push to `main` satisfies `!= 'success'` and the test jobs would run on the trunk, breaking the backstop-only run.
- [ ] Use `${{ }}` form: a bare `!` starts a YAML tag.
- [ ] `secret-scan` unchanged — it has no `needs` and is never filtered.
- [ ] Re-run the probe to confirm a failed `changes` now blocks the merge.

**Defence in depth, separate from this PR:** also add `changes` to the required contexts (`docs/ci.md` already documents it as one). One `gh api` call — the sandbox classifier blocked Claude from making it, so Steve runs it. Payload is staged with `changes` already prepended.