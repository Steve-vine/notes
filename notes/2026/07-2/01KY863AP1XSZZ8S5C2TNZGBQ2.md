---
id: 01KY863AP1XSZZ8S5C2TNZGBQ2
created: 2026-07-23T19:09:07.649306Z
updated: 2026-07-23T20:05:18.915024Z
type: task
title: Ring-cap truncation not topology-aware — expanding a 30+ ring yields a circle of edge-less nodes
project: 01KX671DATY39VW6GWK3M2T3DN
number: 238
sprint: s5khymf
comments:
- id: 01KY89A6EFGPKN8GSQWYQP8R1C
  author: Steve Vine
  at: 2026-07-23T20:05:18.415044Z
  text: |-
    Done on feature/ise-238-ringcap-topology (PR #218, stacked on #217).

    Two defects fixed in buildElements' ring-cap machinery:
    1. `present` was built from all VISIBLE nodes (including capped-hidden ones), so a depth-d node whose parent sat behind a shallower "+N more" drew an edge to a node React Flow never mounts → silently dropped → orphans. Now rings lay shallowest-first and `rendered` (root + every shown node) grows as each ring builds; a node whose parent wasn't rendered — capped OR filtered — folds away with its parent (cascade), and addEdge + the placeholder both gate on `rendered`. No rendered node ever hangs off an absent one. (Bonus: filter-drops now cascade too, which is what ISE-236 wants.)
    2. EntityGraphView had no .catch on the elk/d3 layout promise — a failed async layout silently left the seed concentric circle. Now logs and keeps the seed deliberately.

    Frontend-only. Tests: capped parent folds its child (no orphan); expanding re-admits both with the edge intact; and the invariant "no built edge references a node absent from the built node list" — which would have caught both this and ISE-235's phantom. Full suite (373) + build + lint green.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Repro (Steve, 2026-07-23): expanding a large ring (30+ nodes) arranges them all in a circle around the outside and most have no edges at all.

Two defects compounding in `buildElements` (`graphLayout.ts`), same ring-cap machinery as ISE-235:

1. **Edges silently dropped when they reference a capped-hidden node.** `present` — the set `addEdge` checks before drawing — is built from all *visible* (filter-surviving) nodes, not the nodes actually rendered after ring-capping. A depth-d node whose parent sits behind depth-(d-1)'s "+N more" cap gets an edge whose source is never rendered, and React Flow silently discards edges referencing nonexistent nodes. A 30+ child ring usually means the parent ring is also over the 12-cap, so expanding the child ring reveals nodes whose parents are still folded away → edges dropped en masse. Cap selection is alphabetical (`ordered.slice(0, RING_CAP)`), so whether a child's parent is shown is luck of the naming.
2. **The circle is the seed layout with nothing to correct it.** Nodes seed onto concentric rings (depth × RING_GAP, spread by angle) — in Blast mode that's final, so an expanded 30+ ring is a big circle. In Flow/Explore the async elk/d3 pass would reorganise, but edge-less orphans give it nothing to organise by, and `EntityGraphView.tsx` has no `.catch` on the layout promise — if elk fails on a large graph the seed circle stays, silently.

Fix:
- **Topology-aware truncation**: a node folded into "+N more" folds its shown descendants with it (cascade, exactly as group-collapse already does), and/or ring slicing prefers nodes whose parent is rendered over alphabetical order. No rendered node should ever hang off an unrendered parent.
- **`present` computed from rendered nodes**, not visible ones — restoring `addEdge`'s honest-skip contract.
- **Invariant test** (off-DOM `buildElements`, jsdom can't render @xyflow edges): no built edge references a node absent from the built node list — this single assertion would have caught both this bug and ISE-235's phantom edge.
- **`.catch`/fallback on the async layout** (`elkLayout`/`forceLayout`): log and keep seed positions deliberately rather than accidentally.

Relationship to the batch: same `hidden > 0` branch as ISE-235 — candidate for one branch, tracked separately to keep repros clean. Stack with ISE-234/235/233/236/237 (all touch `buildElements`/`EstateGraphPanel`).

Done when: expanding any ring never reveals a node without a visible connection (its parent is shown, folded with it, or the edge attaches to the placeholder per ISE-235), and a failed async layout logs rather than silently leaving the seed circle.