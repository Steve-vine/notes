---
id: 01KYF6TV0MBAPWXT81WZ2Q4RBD
created: 2026-07-26T12:36:39.060221Z
updated: 2026-08-07T12:16:00.000172Z
type: task
title: Set CPU/memory requests on ise-runners pods
project: 01KX671DATY39VW6GWK3M2T3DN
number: 314
sprint: sr2f21y
comments:
- id: 01KYF8T6SY4SPCYKAN3MNQN0XX
  author: Steve Vine
  at: 2026-07-26T13:11:15.518261Z
  text: |-
    Done — PR #272 (feature/ise-314-runner-resources), applied live to arc-runners.

    What changed:
    - ise-runners runner pods now reserve cpu 2 / memory 4Gi on the runner container (the whole-pod footprint — pytest xdist workers run there; testcontainers Postgres/redis run under the dind native-sidecar and are small/transient). No limits: the request is the scheduling floor, bursts use idle capacity.
    - maxRunners capped 10 → 6 (6 × 2 cpu = 12 of 16 on the shared g5 node, leaving margin for the compass/redvektor scale sets).
    - Values were Helm-only / not in git; now versioned at scripts/infra/ise-runners-values.yaml with the apply command.

    Applied via `helm upgrade` (release now revision 3). New runner pods verified 2/2 with the requests set. Node was chosen conservatively — the dind sidecar carries no request because the chart appends a user-supplied dind container as a duplicate rather than merging (verified with `helm template` before applying), so the footprint is reserved on the runner container instead.

    Full acceptance (wall-clock stable under concurrent runs) validates as the sprint's staging batch lands. Unblocks ISE-317 (pytest -n 8).
assignee: steve
label: null
priority: high
task_status: done
---
Runner pods declare **no resource requests** (`req= lim=`), so ARC packs up to 10 on the single g5 node (16 cpu / 96GB) and concurrent jobs thrash — the cause of the 6m→14m→41m backend wall-clock variance across 3 parallel runs (node itself sits at 3% CPU / 9% mem at rest). Set requests (≈2 cpu / 4Gi per runner, tuned so maxRunners × request ≤ node allocatable) in the `gha-runner-scale-set` Helm values (namespace `arc-runners`; Helm-only, not in git — see [[ise-g5-access-and-ci-runners]]). Consider capping maxRunners to what the node can guarantee.

**Biggest win, lowest effort.** Acceptance: backend job wall-clock stays roughly stable under 3 concurrent runs instead of degrading 4–5×.