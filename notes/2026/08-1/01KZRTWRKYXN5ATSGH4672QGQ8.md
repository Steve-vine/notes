---
id: 01KZRTWRKYXN5ATSGH4672QGQ8
created: 2026-08-11T16:36:05.374052Z
updated: 2026-08-11T16:40:31.858344Z
type: task
title: 'Blast radius: an alert names the Business Applications and Services it hits'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 656
sprint: sj9fsph
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The impact read currently answers "nothing affected" for the two cases that matter most — a whole production cluster failing, and a shared database failing. Fix the traversal and the rollup. This is the same mechanism as the inferred-entities list, walked upstream instead of downstream.

- **`IMPACT_EDGE_TYPES` is `["depends-on", "routes-to"]`** — add `runs-on` and containment `part-of`. A production cluster failing today returns ZERO dependents, because workloads reach it only via `runs-on` / `part-of`.
- **The stated reason for excluding `runs-on` does not hold.** `impact.py:30` says the reverse walk would claim a workload failing takes its node down. The walk is `direction="upstream"` (target→source, `estate.py:34`), and the edge is `workload -runs-on-> host`, so upstream from a host yields its workloads — the correct direction. Upstream from a workload can never reach the host. Include it, and pin the direction with a test.
- **`part-of` is overloaded**: containment (namespace→cluster, host→network) IS consequence; group membership (workload→group, user→identity-group) is a lens and is not. Filter by TARGET type rather than excluding the key — that also drops 20,721 of 23,449 part-of edges from the walk, keeping it bounded.
- **Roll up over the dependent set.** `_applications_of(db, entity.id)` (`impact.py:270`) reads the subject's own composition only, so a cluster failure would list 40 workloads and name zero Business Applications.
- **Report proportions, not just a set.** "3 of 18 members affected" — `_member_counts` already exists. One host failing and a whole cluster failing are not the same event, and this is where the `impact:` tag finally earns its place (nothing reads it today).
- **`HEADLINE_TAG_KEYS`** (`impact.py:45`) still names `tier`, which the tagging strategy renamed to `impact`; neither key exists in the estate. Fix or drop.

Surface: the impact panel on entity and incident names the Business Applications and Business Services hit, with proportions.