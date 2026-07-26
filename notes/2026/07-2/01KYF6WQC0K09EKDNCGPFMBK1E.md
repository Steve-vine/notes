---
id: 01KYF6WQC0K09EKDNCGPFMBK1E
created: 2026-07-26T12:37:40.864102Z
updated: 2026-07-26T12:37:40.864102Z
type: task
title: Stop re-running the full test suite on staging push
label: improvement
task_status: backlog
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 318
---
`push→staging` re-runs the entire backend+frontend suite the PR gate already ran on ~identical code, doubling runner load per release (and it competes with the two PR-gate runs). Let staging run **build-images + deploy + smoke only**, gating the build on the PR gate having passed. Weigh against the belt-and-braces intent (ADR 0011): the combined-state test has caught real drift (e.g. stacked-migration / api-types drift), so consider keeping a **reduced** combined check rather than none.

Acceptance: a staging release runs ~1 fewer full suite; combined-state safety retained or the risk explicitly accepted in the ADR.