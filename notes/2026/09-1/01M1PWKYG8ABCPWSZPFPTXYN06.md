---
id: 01M1PWKYG8ABCPWSZPFPTXYN06
created: 2026-09-04T18:59:08.424929Z
updated: 2026-09-04T18:59:14.5139Z
type: task
title: The blast radius walks into retired entities and counts them as dependencies
project: 01KX671DATY39VW6GWK3M2T3DN
number: 779
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
Smoke finding, 2026-09-04, on `deepgram.test.us`. Its Inferred section reports
**51 dependencies, 32 of which are retired** Karpenter-rotated EC2 nodes.

**Measured on staging** (`blast_radius` run against the live row):

```
direct:    6 members    0 retired
inferred: 51            32 retired   — all type `host`
oldest retired 2026-08-07 (28 days), newest 2026-09-04 12:55
```

**Retirement is not slow — it is working exactly as configured.** Each node was
retired the same day it was last seen, and `entity_prune_after_retired_days`
defaults to 30 (`settings.py:183`), so the 2026-08-07 nodes are two days from
being pruned on schedule. The problem is what happens during those 30 days.

**The walk has no notion of retirement.** `blast_radius`
(`business_applications.py:1218-1245`) selects the reached entities with
`select(Entity).where(Entity.id.in_(...))` and filters `inferred` only on
`DEPENDENCY_EXCLUDED_TYPES`. Nothing anywhere checks `retired_at` —
`estate.py` and `impact.py` contain **zero** references to it, so no graph walk
in ISE excludes a retired entity. Retirement marks the entity; it does not
remove its edges, so the walk still reaches it.

The asymmetry is the tell: **direct members are live-only** — `member_ids` is
documented as "Every live Resource the given predicates ALL match" and returned
0 retired — while the inferred half beside it is 63% retired.

The docstring on both the function and the UI section claims the opposite:
"Computed fresh on every read and never stored, so it cannot go stale as
workloads recycle." The *computation* is fresh; the *edges it walks* are stale.
Recomputing a walk over a dead edge produces a fresh wrong answer.

**Scale, estate-wide:** 3,314 edges point at 403 retired entities; 1,161 of
7,769 entities are retired. This is not one unlucky Business Application.

**The row already knows.** `IncludedEntityRead.retired` exists
(`business_applications_api.py:1093`) and the UI renders a "Retired" badge
(`IncludedEntities.tsx:58`) — which is how the 32 were counted. So the fact is
carried and displayed, and then ignored by the list and the headline number.

**Proposed**

- Exclude retired entities from `inferred`. A retired host is not something the
  application currently rests on, and "51 dependencies" that is really 19 is a
  number an operator cannot use.
- Do **not** extend ADR 0108 §3's treatment here. That rule keeps a *named*
  member that vanished, struck through and dated, because a deliberate human
  inclusion that disappeared is a finding. Nobody stated an inferred dependency,
  so there is no statement to honour — the two cases are different and should
  stay different.
- Decide whether the exclusion belongs in `estate.traverse`/`traverse_many`
  (fixing the impact walk and every other consumer at once) or only at this call
  site. The traversal layer is the honest place, but it changes the incident
  impact walk too — which is very likely also showing retired entities today and
  should be checked before choosing.
- Consider whether a `runs-on` edge into a retired host should be cleaned up at
  retirement rather than left for the prune 30 days later. Karpenter rotation
  makes this the normal case, not the exception.
