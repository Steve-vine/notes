---
id: 01KY84C419M3E5DYXVNMT9G0RF
created: 2026-07-23T18:38:58.601167Z
updated: 2026-07-23T19:46:02.048224Z
type: task
title: Graph edges drawn in traversal order — depends-on arrows flip when walked against the grain
project: 01KX671DATY39VW6GWK3M2T3DN
number: 234
sprint: s5khymf
assignee: steve
priority: medium
task_status: todo
---
Repro (Steve, 2026-07-23): Chinwag group depends-on Gemini. Rooted at Chinwag the arrow reads correctly (Chinwag → Gemini, "depends on"); re-root at Gemini (ISE-232) and the same edge renders *Gemini → Chinwag "depends on"* — the claim is inverted.

Cause: the canvas draws every edge in **traversal order**, not the edge's true direction.

- `traverse()` (`estate.py`) returns `via_source_id` = the traversal parent (`f.id` in the CTE), not the edge's actual `source_id`. In `both` mode (the estate explorer) an edge reached target→source has its true orientation discarded before it leaves the backend.
- `buildElements`/`addEdge` (`graphLayout.ts`) then draws `source: via_source_id → target: node` and labels it `via_edge_type`, so the ISE-231 directional arrow always points root-outward.

Blast radius of the bug itself:
- Estate explorer (`direction: 'both'`): any hop walked against the grain is flipped — which edges are wrong depends on which node is the root.
- **Impact preview graph is wrong on every edge** (`direction: 'upstream'` — every hop is against the grain); it reads naturally as "root → things it affects" but the depends-on arrows are semantically inverted.
- The dependents *list* is unaffected (phrasing computed separately).

Fix (backend-led — orientation is unrecoverable client-side in `both` mode):
- `traverse()` CTE additionally returns the last hop's true orientation (e.g. a `via_reversed` bool, or the edge's real `source_id`/`target_id` — the LATERAL already has them).
- Plumb through `ReachedEntity` → `GraphNode` (additive API field, regenerate frontend types).
- `addEdge` swaps source/target when the hop was walked in reverse.
- No migration. Tests: traversal unit test asserting orientation in upstream/both modes; `buildElements` off-DOM test (jsdom can't render @xyflow edges) asserting a reversed hop draws true-source → true-target.

Done when: the Chinwag/Gemini arrow reads "Chinwag depends on Gemini" from either root, and the Impact preview graph's arrows point dependent → dependency.