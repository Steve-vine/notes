---
id: 01KY85G8R8YT2XWMHP2NKSVKC4
created: 2026-07-23T18:58:43.080051Z
updated: 2026-07-23T20:13:18.709559Z
type: task
title: 'Estate graph filters: re-query for reachability, cascade removal, scope provenance honestly'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 236
sprint: s5khymf
comments:
- id: 01KY89RTYPY86VHZTPZG2DN73V
  author: Steve Vine
  at: 2026-07-23T20:13:18.166015Z
  text: |-
    Done on feature/ise-236-graph-filters-requery (PR #219, stacked on #218).

    - Edge-type filter → server-side re-query: the panel passes the enabled kinds to /graph as edge_type, which re-walks the estate so reachability/depth/parent are recomputed by construction. buildElements no longer applies edgeTypes at all. A stable "seen-universe" (accumulated across re-queries, reset per root) keeps a filtered-out kind in the toolbar so it stays toggleable back on even after it leaves the response.
    - Entity-type + env filters now cascade: a node whose parent was filtered out folds away with it (no orphans) — this fell out of ISE-238's topology-aware ring loop, so no extra code was needed.
    - Provenance filter labelled "Direct connections only" — via_resolution is populated only for the root's direct edges, so it can only judge depth 1; the UI now says so rather than looking inert on deeper nodes.

    Tests: frontend — entity-type filter folds the subtree (no orphan); buildElements ignores edgeTypes (server's job). Backend — an edge_type restriction re-walks: a node reachable by a short excluded-type edge is recomputed to a longer allowed-type path with new depth/parent. Full frontend suite (374) + backend edge suite + build + lint + ruff green.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Report (Steve, 2026-07-23): explorer filters "either seem to do nothing or just remove the arrows or do things I can't quite understand". All three behaviours trace to one design flaw: `passesFilters` (`graphLayout.ts`) is a per-node predicate over *path-derived* attributes, applied client-side to a traversal that was computed without the filters — the graph is never re-walked and removal doesn't cascade.

Symptoms → causes:
- **"Removes the arrows"**: filtering out a mid-path node leaves its descendants visible (reached *through* it) while `addEdge` skips edges whose parent is absent → orphaned nodes floating on their rings with no edges. Group-collapse cascades removal for exactly this reason ("so nothing orphans"); the filter path never got the cascade. Survivors also keep their original ring depth.
- **"Does nothing" (provenance)**: `via_resolution` is only populated for direct neighbours (backend: a deeper hop's provenance is a path's, not an edge's) and null-resolution nodes always pass — so the provenance filter can never hide anything beyond depth 1.
- **"Does nothing" (env)**: nodes with no `env:` tag always pass; in an estate where most entities are untagged, selecting env:prod appears inert.
- **"Can't quite understand" (edge type)**: filters *nodes* by the type of the last hop on the shallowest path, not edges. Keeps a node whose final hop matches even when the whole path was other types (intermediates vanish → orphans); hides a node that genuinely has the wanted edge but was reached first via a shorter path of another type. Which edge "represents" a node is an accident of graph shape.

Fix:
- **Edge-type filter → server-side re-query.** `traverse()` already takes `edge_types` and `/api/v1/entities/{id}/graph` already exposes `edge_type` — the explorer just never passes it. Re-querying recomputes reachability, depths and parents correctly by construction. Wire into the same query-params change as ISE-233's direction filter (land 233's plumbing first, or stack on it).
- **Entity-type + env filters stay client-side but cascade** like group-collapse: removing a node removes its subtree, so nothing orphans. (They don't change which edges exist, so no re-query needed.)
- **Provenance filter**: scope it honestly in the UI ("direct connections only") or drop it.
- Keep `filterOptions` consistent with wherever each filter is now evaluated.

Tests: off-DOM `buildElements` (jsdom can't render @xyflow edges) — filtered mid-path node removes its subtree, no orphan nodes/danging rings; explorer query includes edge_type when set. Backend: traversal with edge_types restriction returns recomputed depths/parents.

Sequencing: after ISE-233 (shares the toolbar + query plumbing); independent of ISE-234/235 but all touch `buildElements` — stack branches.

Done when: every filter toggle produces a visibly explicable result — nodes disappear with their subtrees, edges never silently vanish while their nodes stay, edge-type filtering re-walks the graph, and no filter silently applies to only part of the graph without saying so.