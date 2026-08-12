---
id: 01KZV5C7MC8NE51CPER2M6VDZ8
created: 2026-08-12T14:17:46.892182Z
updated: 2026-08-12T14:18:13.733284Z
type: task
title: 'ADR 0098: the push-to-main run stops being the pre-deploy gate'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 667
sprint: s669j7t
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Record the decision before ISE-668 implements it (hard rule: no architecture decision without an ADR). Amends the CI section of **ADR 0093** (trunk-based pipeline); does not supersede it.

**The finding.** A PR run checks out `refs/pull/N/merge` — verified in the ISE-663 run log, `git checkout --progress --force refs/remotes/pull/613/merge`. So the PR run *already tests the merged state*. The push-to-main run then re-runs the entire suite over a tree that is byte-identical whenever main has not moved between the two, which is the normal case here because CI is deliberately serialised (one PR's CI at a time — the runners share the dev host).

**What is genuinely only checkable on main** is the combined state across independently-green PRs, and ADR 0093 already names exactly three: the OpenAPI snapshot, api-types drift, and single-alembic-head. Those cost ~2.5 min. The other ~11 min is duplication.

**Decision to record:**
- The push-to-main run drops to the combined-state checks only. It stays a required check.
- The full suite's gate is the PR run, on the merge commit.
- The staging pointer push stops waiting on the main run. It is fast-forwarded as soon as the PR merges; the main run is an async backstop, and a red main is still fixed forward immediately (unchanged from ADR 0093).

**The residual risk, stated plainly:** if main moves between a PR's CI run and its merge, the tree that merges was never fully tested. The backstop catches it within ~2.5 min instead of ~14, and the fix-forward rule already covers it. If this ever bites, the answer is branch protection's "require branches to be up to date", not restoring the duplicate run.

**Why it matters at all** — measured 2026-08-12, per backend task: PR 14.3 min + main 13.7 min + deploy 3.4 min ≈ 31 min, which matches the observed "30 minutes is the softest time". Runner contention is the second cost: the slowest PR run in the sample was 36.5 min against a 14.3 min median, purely from overlap, so halving machine time also removes that tail.

No user-facing surface — CI/infra, stated explicitly.