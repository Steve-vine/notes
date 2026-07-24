---
id: 01KY9FNNAFFCH1JYHC0C1QXT18
created: 2026-07-24T07:15:39.983155Z
updated: 2026-07-24T08:44:37.657417Z
type: task
title: Graph node type icon links to the entity's Estate detail page on every graph surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 243
sprint: s5khymf
assignee: steve
label: null
priority: medium
task_status: review
---
Request (Steve, 2026-07-24): make the type icon on each graph node a link that opens the Estate detail screen for that asset — including on the graph shown on the entity detail page itself.

Context: since ISE-232, clicking a node's body re-roots the graph in place — which removed the direct path from a node to its detail page. The node's entity-type icon (`EntityGraphView.tsx`, `TYPE_ICon`/`typeIcon` rendered in `EntityNode`) becomes that path back: icon = "open this asset", body = "explore from here".

Scope:
- **Icon click navigates to `/estate/{entity_id}`** on every graph surface: the estate explorer (in-page card, expanded modal, ISE-228 popout), the entity detail page's own graph, the Estate Explorer route (ISE-241) once it exists, and the impact/incident graphs.
- `stopPropagation` so the icon click never also triggers the node-body activate (re-root / proposal routing) — same pattern as the ISE-229 signal/incident icons on the node, which already have per-icon click handlers.
- Root node included (harmless self-link on the detail page's own graph; genuinely useful in the explorer/popout when re-rooted).
- Unconfirmed (ai_proposed) nodes: body click keeps routing to the proposal queue (ISE-226); the icon still opens the entity detail page — the entity exists regardless of the unconfirmed edge.
- Affordance: cursor/hover state + tooltip ("Open {name} in Estate") + aria-label, so the split between icon and body is discoverable.
- Frontend-only; handler plumbed through `buildElements` node data like the existing onOpen/signal handlers.

Sequencing: graph chain (touches `EntityGraphView`/`buildElements`) — after ISE-232-era click plumbing, naturally alongside ISE-240/241 at the tail of the batch.

Tests: off-DOM `buildElements`/node-data assertions — every entity node carries the detail-page handler with the right id; unconfirmed node keeps proposal routing on body + detail link on icon. Click-splitting verified in component test (icon click fires navigate, not activate).

Done when: on any graph, clicking a node's type icon opens that asset's Estate detail page, while clicking the node body still re-roots (or routes to proposals for unconfirmed nodes) as today.