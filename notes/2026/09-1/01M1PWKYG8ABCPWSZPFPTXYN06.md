---
id: 01M1PWKYG8ABCPWSZPFPTXYN06
created: 2026-09-04T18:59:08.424929Z
updated: 2026-09-04T19:15:30.744186Z
type: task
title: The blast radius walks into retired entities and counts them as dependencies
project: 01KX671DATY39VW6GWK3M2T3DN
number: 779
sprint: s7nj09w
comments:
- id: 01M1PX7PCGDANRBQKQ4S0PA092
  author: Steve Vine
  at: 2026-09-04T19:09:55.472618Z
  text: |-
    Lifecycle windows, for whoever picks this up — **retirement is per type, the prune is not.**

    ```
    retire  host      2 days     entity_retire_after_days_host
            workload  3 days     entity_retire_after_days_workload
            everything else 14   entity_retire_after_days_default
            early path: 60 min once every integration holding an alias has
            synced and none reported it (ISE-514) — why the nodes here went
            the same day
            group: never retired

    prune   ALL types 30 days    entity_prune_after_retired_days
    ```

    Confirmed live on staging; no environment overrides.

    The settings comment justifies the per-type retirement in so many words — "per type, because the estate churns at wildly different rates: a Karpenter node absent for a day is dead, a namespace absent for a day means the cluster connector had a bad afternoon" — and then the prune ignores that same reasoning and applies one flat window to everything.

    Whether that is wrong is a real question, but it is a *retention* question, not a churn one: the prune's own comment says the failure it accepts is "keeping a dead entity too long, never deleting a live one", and findings and playbooks survive a prune with their pointers nulled anyway. So a longer window costs little except exactly the symptom this task is about.

    Which is the point: **fixing the walk makes the window almost irrelevant.** Once retired entities are out of the blast radius, a host sitting retired for 30 days is invisible rather than misleading, and there is no longer much reason to shorten it. Do the filter first; only revisit per-type prune windows if something else still wants them.

    Current spread (staging, all within the 30-day window — the prune is running correctly):

    ```
    secret 482 (avg 15.7d, max 29.1)   host 377 (17.8, 29.4)
    application 133 (1.7, 16.6)        workload 36 (20.8, 25.3)
    user 33 (10.4, 29.4)               kubernetes-service 26 (14.2)
    1,161 retired of 7,769 total
    ```
assignee: steve
label:
- bug
priority: high
task_status: todo
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
