---
id: 01KYF6TV0MBAPWXT81WZ2Q4RBD
created: 2026-07-26T12:36:39.060221Z
updated: 2026-07-26T12:36:39.060221Z
type: task
title: Set CPU/memory requests on ise-runners pods
task_status: backlog
label: tech_debt
assignee: steve
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 314
---
Runner pods declare **no resource requests** (`req= lim=`), so ARC packs up to 10 on the single g5 node (16 cpu / 96GB) and concurrent jobs thrash — the cause of the 6m→14m→41m backend wall-clock variance across 3 parallel runs (node itself sits at 3% CPU / 9% mem at rest). Set requests (≈2 cpu / 4Gi per runner, tuned so maxRunners × request ≤ node allocatable) in the `gha-runner-scale-set` Helm values (namespace `arc-runners`; Helm-only, not in git — see [[ise-g5-access-and-ci-runners]]). Consider capping maxRunners to what the node can guarantee.

**Biggest win, lowest effort.** Acceptance: backend job wall-clock stays roughly stable under 3 concurrent runs instead of degrading 4–5×.