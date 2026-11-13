---
id: 01M7B39K7M8ECEB4MZ80F3DJRK
created: 2026-11-13T18:39:06.996383Z
updated: 2026-11-13T22:47:59.499786Z
type: task
title: 'Dependency scan: move opentelemetry-api to 1.45.2 (CVE-2026-126360) so PR checks go green again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1802
sprint: spsp226
comments:
- id: 01M7B45B6X4EPPNS39Q5EC49BZ
  author: Steve Vine
  at: 2026-11-13T18:54:16.285043Z
  text: 'Done — PR #1786 merged (97deea28). The lockfile moves opentelemetry-api 1.45.1 → 1.45.2, the release that fixes CVE-2026-126360; nothing else changed. Its dependency scan passed. The round-6 PRs get the fix by taking main.'
- id: 01M7BHH9RBDKDW5XJTQN4FCGXR
  author: Steve Vine
  at: 2026-11-13T22:47:59.499659Z
  text: 'Pre-UAT: Passed. The dependency scan passed on every round-6 PR after this merged and on the main build (2f72416b). Staging is on that build, and the Browser smoke passed 32/32. Nothing on screen to check.'
assignee: steve
label:
- chore
priority: high
task_status: review
---
Found 2026-11-13 ~18:40 GMT while building sprint 116 round 6. A new advisory against opentelemetry-api 1.45.1 (CVE-2026-126360, fixed in 1.45.2) turned every PR's deps-scan red, and the backend jobs are skipped behind it, so nothing can merge.

Fix: `uv lock --upgrade-package opentelemetry-api` (1.45.1 → 1.45.2), lockfile only.

**Independent.** Done when deps-scan passes on its PR and on the round-6 PRs after they pick it up.