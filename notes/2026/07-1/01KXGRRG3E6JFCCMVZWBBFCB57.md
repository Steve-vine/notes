---
id: 01KXGRRG3E6JFCCMVZWBBFCB57
created: 2026-07-14T16:53:29.326368206Z
updated: 2026-07-14T16:53:39.895474425Z
type: task
title: Bump CI actions to Node 24-capable versions
label:
- tech_debt
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 21
sprint: s7hkfxa
comments:
- id: 01KXGRRTDQ8J3YEQ4WBQDEYZ68
  author: Steve Vine
  at: 2026-07-14T16:53:39.895352377Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-14 09:34 UTC]
    **Done.** Squash-merged as `e24e614` ([PR #3](https://github.com/Steve-vine/compass/pull/3)).

    All eight actions bumped to current majors; CI green on the PR and the post-merge `release.yml` run succeeded on the new `docker/*` versions. **The Node.js 20 deprecation warning is now gone** (0 occurrences in the release run).

    | Action | From | To |
    | --- | --- | --- |
    | actions/checkout | v4 | v6 |
    | actions/setup-node | v4 | v6 |
    | actions/setup-python | v5 | v6 |
    | astral-sh/setup-uv | v5 | **v8.2.0** |
    | docker/setup-buildx-action | v3 | v4 |
    | docker/login-action | v3 | v4 |
    | docker/build-push-action | v6 | v7 |
    | gitleaks/gitleaks-action | v2 | v3 |

    **On the fly:** `setup-uv` has no moving `v8` major tag (only up to `v7` + full-version `v8.x` tags), so it's pinned to the exact `v8.2.0` rather than `@v8`. First push failed fast on `@v8` ("unable to find version v8"); the pin fixed it.
---
Follow-up from <issue id="18043ba7-04c2-482f-9937-fa7cbaa551d2" href="https://linear.app/stevevine/issue/DEV-390/ci-pipeline-and-branch-protection">DEV-390</issue>. GitHub flagged that several actions in our workflows run on **Node.js 20**, which is being forced to Node.js 24 from **2026-06-16** and removed from runners on **2026-09-16** ([changelog](<https://github.blog/changelog/2025-09-19-deprecation-of-node-20-on-github-actions-runners/>)).

No breakage is expected — the pinned majors already ship Node 24-capable builds — but we should bump to clear the warning and stay ahead of the removal.

Affected actions (in `.github/workflows/ci.yml` and `release.yml`):

- [ ] `actions/checkout`
- [ ] `actions/setup-node`
- [ ] `actions/setup-python`
- [ ] `astral-sh/setup-uv`
- [ ] `docker/setup-buildx-action`
- [ ] `docker/login-action`
- [ ] `docker/build-push-action`
- [ ] `gitleaks/gitleaks-action`
- [ ] Bump each to its latest Node 24-capable release and confirm CI stays green.

Refs: <issue id="18043ba7-04c2-482f-9937-fa7cbaa551d2" href="https://linear.app/stevevine/issue/DEV-390/ci-pipeline-and-branch-protection">DEV-390</issue>, ADR 0016.

---
*Migrated from Linear [DEV-415](https://linear.app/stevevine/issue/DEV-415/bump-ci-actions-to-node-24-capable-versions) · created 2026-06-14 · completed 2026-06-14*  
*Related to (Linear): DEV-422*