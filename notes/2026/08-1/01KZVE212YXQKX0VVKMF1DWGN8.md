---
id: 01KZVE212YXQKX0VVKMF1DWGN8
created: 2026-08-12T16:49:29.694977Z
updated: 2026-08-12T16:49:50.964572Z
type: task
title: Docs sweep for the trunk-based workflow (CLAUDE.md, ci.md, CONTRIBUTING, ways-of-working)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 201
blocked_by:
- 01KZVE1KEDHWZ75V2TA2TTH3AB
assignee: steve
label: chore
priority: medium
task_status: todo
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