---
id: 01KY9G1KET64VQP4JFDQ6EY0F0
created: 2026-07-24T07:22:11.290414Z
updated: 2026-07-24T08:30:34.799844Z
type: task
title: 'Estate Explorer: add "Open in a separate window" pop-out, matching the dependency graph''s'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 244
sprint: s5khymf
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Request (Steve, 2026-07-24): the Estate Explorer graph (ISE-241) should carry the same "Open in a separate window" button as the entity page's dependency graph.

Scope:
- Add the pop-out action to the Estate Explorer surface, reusing the existing affordance from `EstateGraphPanel` (ISE-228): named `window.open` so a second click focuses the existing window rather than spawning another, `resizable`, same icon/tooltip.
- Pop out **the currently focused root** — the ISE-232 pattern already used by the panel's `openPopout` (`/estate/{rootId}/graph`, named `ise-graph-{rootId}`), so exploring in the popout continues from where the explorer was, not from where it started.
- Before an asset is selected (ISE-241's search-first empty state) the button is hidden or disabled — there is nothing to pop out yet.
- If ISE-241 is implemented by reusing `EstateGraphPanel` wholesale this may be near-free — the task is then just "don't suppress the popout affordance on the explorer variant" plus the empty-state guard. If the explorer got its own chrome, lift `openPopout` into shared code rather than duplicating it.
- Frontend-only.

Depends on ISE-241 (the surface must exist) — stack directly after it on the graph chain.

Tests: button present and enabled once rooted, absent/disabled in the empty state; window.open called with the focused root's URL and stable window name (mock `window.open`).

Done when: from the Estate Explorer, an operator can pop the currently focused graph into its own window exactly as they can from the entity page's dependency graph.