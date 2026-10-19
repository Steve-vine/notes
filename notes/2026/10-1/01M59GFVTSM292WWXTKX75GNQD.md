---
id: 01M59GFVTSM292WWXTKX75GNQD
created: 2026-10-19T07:19:51.385521Z
updated: 2026-10-19T07:45:18.949541Z
type: task
title: A PR merges itself as soon as every check is green, and a red PR can't be merged at all
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1111
sprint: sjlj05e
comments:
- id: 01M59HYF04TDZTMWG2HT3K82CJ
  author: Steve Vine
  at: 2026-10-19T07:45:18.339968Z
  text: |-
    2026-10-19: Steve upgraded the RootCause-IT org to GitHub Team, so the protected route went ahead.

    Configured via the API: main requires the ten PR jobs (changes, backend-static, backend-unit, backend-test, frontend, secret-scan, deps-scan, sast, migrations, chart), each pinned to the GitHub Actions app; enforce_admins on; linear history; no force-push or deletion; no reviews; strict off. The repo allows auto-merge.

    CLAUDE.md's per-task loop updated in PR #1093: set --auto --squash on PRs to main, and never on a stacked child still targeting its unprotected parent.

    Proven on #1093 itself: a plain merge with checks pending was refused ("base branch policy prohibits the merge"), and --auto merged it 22s after the last required check went green. I didn't test the admin-override path (my tool permissions block it); enforce_admins reads as enabled on the protection.

    Follow-on: if COM-1089 adds or renames required jobs, update the protection's checks list in the same change.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks.

## Why

Two problems, one fix:
- **Merges wait to be noticed.** A green PR sits until I next poll its checks, then merges, then its child is restacked. Every minute between "green" and "merged" adds to a serial stack.
- **A red PR can be merged.** Since the move to RootCause-IT, `main` has no branch protection. The protection API answers 403 "Upgrade to GitHub Pro or make this repository public". `gh pr merge` landed a red PR (#1015, COM-1036), which broke main and needed fix-forward #1016. "The PR is the only gate" (ADR 0041) holds only because I check by hand.

GitHub's auto-merge needs required status checks to mean anything, and those need branch protection or rulesets. On a private repo, both need a paid plan. `allow_auto_merge` is currently off.

## Decision for Steve (first step)

- **Upgrade the RootCause-IT org to GitHub Team** (per-user monthly cost): restores protection, then auto-merge. Recommended.
- **Or stay on the free plan**: a merge script that refuses unless every check is green, and waits then merges. It closes most of the gap, but it isn't enforced: anything that calls `gh pr merge` directly can still bypass it.

## What changes

- A PR is marked to merge when it's opened. It merges the moment every required check is green, and never while one is red or still running.
- The required checks are the PR jobs as today. Skipped jobs still count as passed, so path filtering and the `changes` fail-safe keep working (COM-202).
- Stacked PRs: a child marked to merge targets its parent. GitHub retargets it to main when the parent's branch auto-deletes, but it still needs the `--onto` restack (memory: restack children with --onto). Say in the PR whether a child merging into its parent before the parent reaches main can happen, and stop it if so.

## Notes (technical)

- With protection: required contexts = changes, backend-static, backend-unit, backend-test, frontend, secret-scan, deps-scan, sast, migrations, chart (plus any aggregators COM-1089 adds; renaming a required job is a two-step change, see the ci.yml note). `enforce_admins` on. Then `gh api -X PATCH repos/RootCause-IT/compass -f allow_auto_merge=true`, and `gh pr merge --auto --squash` at PR creation.
- Fallback: `scripts/dev/merge-when-green.sh <pr>` polls head-SHA check-runs, not the rollup (memory: CI format gates; `gh pr checks` has no --json), and merges only when all are success/skipped/neutral. Poll in the foreground with ≤600s timeouts (memory: background CI waits killed).
- Update the per-task loop in CLAUDE.md and the "main is unprotected" memory to match.

**Done when:** Steve has chosen; a red PR cannot be merged by the normal merge path (and, with protection, by any path); a green PR merges without a human or agent having to notice; the stack loop in CLAUDE.md says how.