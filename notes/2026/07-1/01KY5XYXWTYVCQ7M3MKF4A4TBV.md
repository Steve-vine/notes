---
id: 01KY5XYXWTYVCQ7M3MKF4A4TBV
created: 2026-07-22T22:08:26.010154Z
updated: 2026-07-23T08:12:30.708266Z
type: task
title: Graph layout modes & filters — blast radius, dependency flow, containment, explore
project: 01KX671DATY39VW6GWK3M2T3DN
number: 224
sprint: s5khymf
blocked_by:
- 01KY5XYNXF7D4P2RPBDY9XFS53
comments:
- id: 01KY60205A68JGNAV7ZA0EGB0M
  author: Steve Vine
  at: 2026-07-22T22:45:03.786131Z
  text: |-
    Done — PR #207 (feature/ise-224-graph-layout-modes → base feature/ise-223, stacked on #206).

    Four layout modes on a toolbar switcher (remembered per user): blast radius (radial), dependency flow (elk layered L→R), containment (elk layered T→B over part-of), explore (d3-force). elk/d3 are lazily imported so the default view and tests never load the ~440KB elk chunk.

    Filters (only offering values actually present): relationship, provenance incl. show/hide unconfirmed, entity type, environment via canonical env: tags. Depth slider re-queries /graph. Group collapse folds members + subtrees into the group node with a count. Per-entity drag persistence in localStorage (ISE-156 pattern) + reset layout.

    Backend: added via_source_id (parent linkage, so edges are real parent→child, not root-spokes) and canonical tags to GraphNode; regenerated API types.

    One deviation from the brief: elk runs on the main thread (its bundled-build default) as a lazy chunk rather than in a Web Worker — the graphs are bounded and ring-capped so layout is a few ms, and this dodges the worker-bundling/CSP/test fragility. Flagged in the PR; easy to switch if you'd rather.

    CI gates green locally: 352 frontend tests, backend graph/impact/traverse tests, build, ESLint, Prettier, ruff, mypy all clean.
- id: 01KY70H13M6443W0C3T5J5ARTC
  author: Steve Vine
  at: 2026-07-23T08:12:30.708132Z
  text: 'RELEASED to main 2026-07-23 (PR #207, merge 262f196). Smoke tests passed on staging; main CI green (tests + production image build). Feature branch deleted, staging reset to main. Note: elk runs main-thread as a lazy chunk (not a Web Worker) — accepted at release.'
assignee: steve
label:
- feature
priority: medium
task_status: review
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