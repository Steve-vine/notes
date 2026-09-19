---
id: 01M2WG1NXYZ45PVR0QG4SJKVWE
created: 2026-09-19T09:30:35.32674Z
updated: 2026-09-19T12:52:56.928859Z
type: task
title: The chart job gates a merge — add `chart` to main's required status checks
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 724
sprint: stek6vx
comments:
- id: 01M2WVM6Z0GNTMWJ7PWPGDM7D7
  author: Steve Vine
  at: 2026-09-19T12:52:56.926836Z
  text: Chart added.
assignee: steve
label:
- chore
priority: medium
task_status: backlog
---
**Steve's** — a branch-protection edit Claude cannot make (the classifier blocks protection calls, and enforce_admins is on).

COM-655 added the `chart` job to the PR suite, but it is not in `main`'s required status checks, so a red `chart` job reports and does not block. It has already cost one defect: PR #722 (COM-714) merged with `chart` failing — `mergeStateStatus` was UNSTABLE, not BLOCKED — and put a Helm-4-incompatible template on main (fixed forward as COM-715).

**Do**: GitHub → compass → Settings → Branches → main → required status checks → add `chart`. Adding a context is safe: the job is skipped on PRs that do not touch `chart/**`, workflows or `scripts/ci/`, and a skipped required check satisfies protection.

**Acceptance**: a PR with a failing `chart` job cannot be merged.