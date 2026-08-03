---
id: 01KZ3YSH9VVGZD3JMDTJ2YTJCT
created: 2026-08-03T14:00:10.811484Z
updated: 2026-08-03T15:00:16.850929Z
type: task
title: 'Graph explorer: only one edge drawn per node — shared hosts lose their runs-on links'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 516
order: 5.0
sprint: skxht3g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found in Sprint 46 Estate testing. In the graph explorer, the 8 chinwag-v2-test workloads all have runs-on edges in the DB (verified), but only 2 show a runs-on link to a host on the canvas.

**Cause:** `traverse()` (estate.py) returns each reached node once with a single `via_source_id` — the first/shallowest edge that reached it (`SELECT DISTINCT ON (id)`). The `/entities/{id}/graph` endpoint passes exactly that to the canvas, so the graph renders a spanning tree, not the actual subgraph. Any node reachable by several paths (a host shared by several workloads, also reachable via the cluster's part-of path) keeps one arbitrary parent edge; all its other edges to nodes already on the canvas are silently missing. Reads as "these workloads have no runs-on link" when they do.

**Fix direction:** after traversal, fetch all edges whose two endpoints are both in the returned node set and draw them all — keep the traversal for node discovery/depth only. (via_edge_type/provenance stays useful for the direct ring.)