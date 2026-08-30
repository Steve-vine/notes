---
id: 01M19GPNMQDTN2HVNZ3K6Q5614
created: 2026-08-30T14:20:47.127724Z
updated: 2026-08-30T16:01:04.065712Z
type: task
title: Two relationships between the same pair draw on top of each other in the graph
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 535
sprint: sz42uhw
comments:
- id: 01M19PE9J15C81RZ0ZAAPXX2NA
  author: Steve Vine
  at: 2026-08-30T16:01:04.06551Z
  text: |-
    Done — PR #543, merged to main.

    Decision taken: **fan the parallel edges apart**, not stack the labels only. The two lines were coincident too, so one relationship was drawn entirely underneath the other — a reader could not see there were two edges at all, only that the pill was illegible. Bowing each edge gives it its own path and its own midpoint, and the labels separate as a consequence rather than as a special case.

    How:
    - `fanParallelEdges` stamps each edge with its index among the edges sharing its pair, keyed on the **unordered** pair — A→B and B→A are drawn between the same two border points and collide exactly as two A→B edges do. It runs last, over the finished edge list, because a pair's edges are pushed from two different loops (the "+N more" hints, then the real subgraph).
    - Kind-agnostic, as the brief asked: owner/member is the reported case, but grants, holds and can_activate are all drawn the same way. The dashed "+N more" hints fan with everything else.
    - `parallelOffset` centres the fan on the straight line, so two edges sit symmetrically either side of where the one edge would have been.
    - `bowedPath` replaces `getStraightPath`. At offset 0 it returns the same straight line and plain midpoint, so **nothing outside a genuine parallel pair changes**. Where it bows, the control point is twice the offset out (a quadratic at t=0.5 only reaches halfway to its control point), so the curve and the pill riding it sit exactly `offset` off the line.
    - The offset's sign comes from the canonical pair order rather than the edge's own direction, so an A→B and a B→A land on opposite sides instead of both bowing "left of their own arrow" into each other.

    Arrowheads keep `orient="auto-start-reverse"`, which follows the curve's tangent, so a bowed edge still points at its target.

    Verified: graphLayout.test.ts covers the stamping (a pair with two edges gets index/count, a pair with one is untouched and still draws straight), direction-agnostic pairing, offset centring, and bowedPath — straight at 0, the doubled control point, the mirrored offset, coincident ends. 51 tests green across src/access/graph/.

    **Worth a look on the canvas**: a root who both owns and is a member of one group should now show two readable pills *and* two visible lines.
assignee: steve
company:
- moneypenny
label:
- bug
priority: medium
task_status: active
---
Somebody who both owns a group and is in it has two relationships to it, and the Access Graph draws them in the same place: the **Owner of** and **Member of** pills land exactly on top of one another, unreadable.

Where there are two, they should sit one above the other.

## Why it happens

Both edges are drawn independently, and both compute the same geometry. The endpoints float — each end anchors on the point of its node's border facing the other node (`floatingEdgeParams`), which is right and is what stops a group with many members stacking every edge on one handle. But for two edges between the *same pair*, "the border point facing the other node" is the same point at both ends. Same endpoints → same straight path → same midpoint → both pills translate to identical coordinates.

`DirectoryGraphView.tsx`, `AccessEdgeComponent`: the label is placed at `getStraightPath()`'s midpoint with `translate(-50%, -50%)`, and nothing knows another edge is already there.

## The thing worth deciding alongside

It is not only the labels. The two **lines** are coincident too, so one relationship is drawn entirely underneath the other — a reader cannot see there are two edges at all, only that the pill is illegible. Stacking the pills fixes what was reported; it leaves a graph that still draws one line where there are two.

So either:

- **stack the labels only** — cheap, fixes the report, and the doubled line stays invisible; or
- **fan the parallel edges apart** — bow each of the N edges between a pair by a small perpendicular offset, so each gets its own path and its own midpoint, and the labels separate as a consequence rather than as a special case. The relationship count becomes visible, which is the thing a graph is for.

The second is the better answer and is not much more work, but it changes how a familiar picture reads, so it is a call rather than an assumption.

## Notes

- Edge ids already carry the type (`e-${edge_type}-${source_id}-${target_id}`, `graphLayout.ts:442`), so edges sharing a pair are identifiable without a new key — group by `${source_id}-${target_id}` and hand each its index and the total.
- Any pair of kinds can collide, not just owner/member: `grants`, `holds` and `can_activate` are all drawn the same way. Whatever is done should be per-pair and kind-agnostic rather than a rule about ownership.
- The `+N more` hint edges carry no pill (`edgeType` is empty), so they need no offset for labels — but they would want one if the lines are fanned.
- Not to be confused with the case `graphLayout.ts:434` already handles: one group nested under three *different* parents is three edges between three different pairs, which draw apart correctly today.

## Verifying

A root who both owns and is a member of one group: two pills, both readable, one above the other — and, if the edges are fanned, two visible lines rather than one.
