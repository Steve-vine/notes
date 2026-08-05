---
id: 01KZ3YSH9VVGZD3JMDTJ2YTJCT
created: 2026-08-03T14:00:10.811484Z
updated: 2026-08-05T12:02:51.602719Z
type: task
title: 'Graph explorer: only one edge drawn per node — shared hosts lose their runs-on links'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 516
order: 5.0
sprint: skxht3g
comments:
- id: 01KZ44SD9S7NWPYBVHPKV6D8SG
  author: Steve Vine
  at: 2026-08-03T15:44:58.169284Z
  text: |-
    Fixed in PR #439 (feature/ise-516-graph-all-edges). Root cause confirmed exactly as you diagnosed.

    Took the fix direction you suggested: the traversal keeps doing node discovery and depth, and drawing now comes from a real edge list. `/entities/{id}/graph` gains an `edges` array — every edge whose both endpoints are among the returned nodes — and the canvas draws that instead of one edge per node.

    Details worth knowing:
    - Edges are filtered by the same `edge_type` set as the walk, so a kind you excluded can't reappear as a line between two nodes the walk reached by other means.
    - The honest-skip rule (ISE-238/ISE-235) is kept and now applies to BOTH ends: an edge to a node filtered out or capped behind a "+N more" is dropped, because React Flow silently drops such edges and leaves a line to nowhere. The ring cap is the sharp case and has its own test.
    - Two things fall out for free. Each edge carries its own provenance, so a deeper edge can finally show how it came to exist — `via_resolution` could only speak for direct spokes off the root. And `via_reversed` is no longer needed for drawing, since the server's endpoints are already the true direction; it still describes the walk, so the ISE-234 behaviour is preserved (test rewritten to the new contract).
    - Node selection, depth, rings, group-collapse and the ring cap are untouched. Only the drawing changed.

    One known limitation I did not solve here: two entities joined by two different edge kinds now draw two edges, which overlap visually since the floating edges take the straight path between the same two borders (their pills stack). Both are drawn with distinct ids and neither is lost — it's a legibility issue, not a correctness one, and edge bundling felt like a separate piece of work. Happy to raise a follow-up if you see it in the wild.

    Tests: 4 backend API tests, 6 frontend (shared-host fan-out, capped ring 12-of-20 and expanded 20, folded-away endpoint, two kinds between one pair, deep-edge provenance, stale flagging). Full frontend suite green (544), backend entities suite green (30), ruff/format/mypy strict clean, API types regenerated.
- id: 01KZ46ZPTPZQ8NNK0M7NN7XZWF
  author: Steve Vine
  at: 2026-08-03T16:23:21.685972Z
  text: |-
    RELEASED to main 2026-08-03 (PR #439 merged, main 7dfff2c, no migration). Staging smoke passed and staging reset to main.

    The 8 chinwag-v2-test workloads should each show their runs-on link to the shared host on the next look at the graph explorer — no sync or data repair needed, since this was purely a read/render change.
assignee: steve
label: null
priority: high
task_status: done
---
Found in Sprint 46 Estate testing. In the graph explorer, the 8 chinwag-v2-test workloads all have runs-on edges in the DB (verified), but only 2 show a runs-on link to a host on the canvas.

**Cause:** `traverse()` (estate.py) returns each reached node once with a single `via_source_id` — the first/shallowest edge that reached it (`SELECT DISTINCT ON (id)`). The `/entities/{id}/graph` endpoint passes exactly that to the canvas, so the graph renders a spanning tree, not the actual subgraph. Any node reachable by several paths (a host shared by several workloads, also reachable via the cluster's part-of path) keeps one arbitrary parent edge; all its other edges to nodes already on the canvas are silently missing. Reads as "these workloads have no runs-on link" when they do.

**Fix direction:** after traversal, fetch all edges whose two endpoints are both in the returned node set and draw them all — keep the traversal for node discovery/depth only. (via_edge_type/provenance stays useful for the direct ring.)