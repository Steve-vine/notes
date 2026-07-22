---
id: 01KY5XYXWTYVCQ7M3MKF4A4TBV
created: 2026-07-22T22:08:26.010154Z
updated: 2026-07-22T22:27:11.085934Z
type: task
title: Graph layout modes & filters — blast radius, dependency flow, containment, explore
project: 01KX671DATY39VW6GWK3M2T3DN
number: 224
sprint: s5khymf
blocked_by:
- 01KY5XYNXF7D4P2RPBDY9XFS53
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The "different ways to visualise" half: one canvas, four layouts, cross-cutting filters. Each mode answers a different Canon question.

- Add `elkjs` (layout runs in a web worker; ~100KB).
- **Modes** (switcher on the graph toolbar, choice remembered per user):
  - *Blast radius* — radial rings by hop distance (the ported default): "what breaks if this fails?"
  - *Dependency flow* — elkjs layered left→right: dependents ← entity → dependencies; the natural view for `depends-on`/`routes-to` and the SaaS edges.
  - *Containment* — elkjs top-down tree over `part-of`: cluster → namespace → workload, groups visible.
  - *Explore* — force-directed (d3-force) free-form browsing.
- **Filters** (apply in every mode): edge-type toggles (part-of / depends-on / routes-to / runs-on / hosted-on), **provenance toggles** incl. show/hide unconfirmed proposals, depth slider (re-query `/entities/{id}/graph` with depth), entity-type filter, `env:` filter via canonical tags.
- **Group collapse**: a group's members fold into the single group node (fan-out control on big neighbourhoods).
- **Persistence**: user-dragged positions saved per entity (user-scoped), restored on revisit; "reset layout" undoes.
- Empty/thin states stay honest ("graph may be incomplete", link to edge assertion, per ISE-216).