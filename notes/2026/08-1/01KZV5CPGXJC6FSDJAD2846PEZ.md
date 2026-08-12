---
id: 01KZV5CPGXJC6FSDJAD2846PEZ
created: 2026-08-12T14:18:02.141645Z
updated: 2026-08-12T14:18:02.141645Z
type: task
title: Trim the push-to-main run to the combined-state checks, and unblock the staging pointer
label: improvement
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 668
---
Implements ADR 0098 (ISE-667). Depends on it.

**`.github/workflows/ci.yml`** — on `push` to `main` only, run the three combined-state checks and skip the rest:
- keep `api-types` in full (it *is* a combined-state check, 75s)
- run the backend job's **OpenAPI snapshot** step and pytest's **`test_single_head`** only — not the full suite, not the migration append-only check (that one compares against origin/main and is meaningless once merged)
- skip `frontend`, `backend-lint`, and the ~617s pytest run
- PR runs are untouched — they keep the full suite, and they remain the real gate
- `backend` and `frontend` are branch-protection required checks, so they must still *report*: gate the expensive steps inside the jobs rather than skipping the jobs, or a required check sits "Expected" forever. This is the same trap the `changes` job's comment already documents.

**`CLAUDE.md`** — the deploy loop currently says "verify the main push was green before pushing the pointer". Replace with: fast-forward the pointer as soon as the PR merges; the main run is an async backstop. Keep everything else about ADR 0093 intact — staging is still a pointer, still never committed to, still `git push origin origin/main:staging` (never local `main`).

**Expected effect**, from the 2026-08-12 measurements: push-to-main 13.7 min → ~2.5 min, and it leaves the critical path entirely. Combined with ISE-666, a batch of 5 front+backend tasks goes from ~143 min wall / 195 min runner time to ~54 min / ~91 min.

**Verify by running CI as CI does, not by reading the YAML** — merge something small and confirm the main run reports green on all required checks in ~2.5 min, and that a deliberate OpenAPI drift still reddens it.

No user-facing surface — CI/infra, stated explicitly.