---
id: 01KZVE212YXQKX0VVKMF1DWGN8
created: 2026-08-12T16:49:29.694977Z
updated: 2026-08-12T17:28:37.588028Z
type: task
title: Docs sweep for the trunk-based workflow (CLAUDE.md, ci.md, CONTRIBUTING, ways-of-working)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 201
blocked_by:
- 01KZVE1KEDHWZ75V2TA2TTH3AB
comments:
- id: 01KZVG9GY97CYQJA8AC6Q8H6EJ
  author: Steve Vine
  at: 2026-08-12T17:28:32.456821Z
  text: |-
    Done — PR #193, all five checks green (backend 8m0s, frontend 3m12s, deps-scan 2m6s, sast 1m19s, secret-scan 40s).

    Updated `CLAUDE.md`, `docs/ci.md`, `CONTRIBUTING.md`, `brief/ways-of-working.md` — and `README.md`, which I found still describing "batch smoke-testing on a long-lived `staging` branch" and wasn't in the task list.

    `docs/ci.md` got the most work: a new section on the backstop that explains *why* only two checks belong there rather than just listing them, and an explicit note on job-level skips vs `paths-ignore` (a required check whose job never runs sits "Expected" forever). `brief/ways-of-working.md`'s "Dependent briefs" section was rewritten from merge-order-into-staging back to stacking, keeping the ADR 0036 history as a marked note rather than deleting it.

    **Small irony worth recording:** this docs-only PR spent **8m0s** in the `backend` job, because it branched from `main` and so was graded by the *old* workflow. It is the last PR that will pay that — with COM-199's `changes` job it would have skipped backend and frontend entirely and finished in about a minute. Good accidental before/after measurement.
assignee: steve
label:
- chore
priority: medium
task_status: review
---
Last in the sequence, so it documents what actually shipped rather than what was planned. All four point at ADR 0041.

- [ ] `CLAUDE.md` "How we work" — replace the per-task loop, batch testing phase, release phase and CI summary with the three triggers and the pointer.
- [ ] `docs/ci.md` — trigger table, new job list, the backstop, the `scripts/ci/` checks and how to run them locally.
- [ ] `CONTRIBUTING.md` — workflow steps 2–6; add the stacked-PR mechanics.
- [ ] `brief/ways-of-working.md` — same model change.

The loop being documented:
1. Branch from `main` (or from the parent for stacked work).
2. PR — targeting `main`, or the parent for a stack. **The only gate.**
3. Merge when green, in dependency order; rebase and retarget children after each parent lands (`required_linear_history` means squash, so children need `git rebase --onto main <parent> <child>`).
4. Trunk backstop runs (~2 min). It gates nothing, but **don't move the pointer if it's red**.
5. `git push origin main:staging` — builds images, deploys, smoke-checks.
6. Steve smoke-tests the staging UI. A defect is **fixed forward** with a new task and a new PR; the batch is never rebuilt.

Branch `feature/com-201-docs-trunk-cicd`.