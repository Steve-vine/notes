---
id: 01KZ48WF469MHXQQ936WEEVXBZ
created: 2026-08-03T16:56:32.64639Z
updated: 2026-08-05T12:31:37.156547Z
type: task
title: Graph element toggle
project: 01KX671DATY39VW6GWK3M2T3DN
number: 520
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ4F1W9RWJJ24F3NPZHT3BMQ
  author: Steve Vine
  at: 2026-08-03T18:44:21.432026Z
  text: |-
    Built on feature/ise-520-graph-ghost-toggle — PR #444 to main (https://github.com/Steve-vine/ise/pull/444). Frontend only, no API change, no migration.

    Each node carries a ghost toggle (top-right, opposite the incident/alert icons). One click fades the entity AND every edge touching it into the background; the toggle stays legible and reversible on the ghosted node. Ghosting is a way of reading the graph, not a filter: the node keeps its place, its edges and its position, so nothing reflows and nothing goes silently missing. A ghosted node stops taking clicks (panning across one no longer re-roots the graph onto it) and its edges drop their relationship pill. A "N ghosted / Show all" panel on the canvas restores everything at once.

    Decisions: state is session-scoped and deliberately NOT persisted like spacing/drag positions (a node still faded next week with no memory of having done it reads as a bug); keyed by entity id, not root, so walking away and back does not un-hide it; the severity glow survives ghosting, faded with the rest; the root is ghostable too, no special case.

    Smoke test on staging: Estate → any asset → Dependency graph (also the pop-out and Estate Explorer). Ghost a busy neighbour, check its lines fade with it, check "Show all" brings everything back.
assignee: steve
priority: medium
task_status: done
---
On the graph, add a toggle on to each entity to make it less visible so it disappears into the background along with its lines.  Make it so that it’s still visible enough to click the toggle to re-enable it but effectively ghosted out.