---
id: 01KY86Z500TM1N1P6ZMRT8TGEV
created: 2026-07-23T19:24:19.328902Z
updated: 2026-07-23T19:39:32.189157Z
type: task
title: 'Graph breadcrumb: "Focused on" first and always shown, name links to centre the node'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 240
sprint: s5khymf
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Request (Steve, 2026-07-23). The explorer's breadcrumb (`EstateGraphPanel.tsx`, shown only when re-rooted via ISE-232) currently reads "← Back to xxx&nbsp;&nbsp;Focused on yyy". Change:

1. **Swap the order**: "Focused on yyy" first, then "← Back to xxx".
2. **Always show "Focused on yyy"** — including the initial (un-re-rooted) view, where yyy is the page's own entity. The "Back to xxx" link still appears only when the operator has walked away from the page's entity (rootId ≠ entityId).
3. **Make yyy a link that centres that node on screen** in both cases — pan/zoom the canvas to the current root node, without re-fetching or re-rooting.

Implementation notes:
- Centring needs a canvas affordance: `EntityGraphView` wraps React Flow (`useReactFlow().setCenter`/`fitView` with the root node id) — expose it via a prop (e.g. a `centerNonce`/target) or imperative handle from `Canvas`; the root node's current position is in React Flow state, so centre on that, respecting dragged/laid-out positions.
- Applies to all three explorer surfaces: in-page card, expanded modal, popout (same component).
- Frontend-only; no API changes.
- Tests: breadcrumb render logic (initial view shows "Focused on {entity}" with no Back link; re-rooted shows "Focused on {new root}" then "Back to {entity}"); centring handler wiring — actual pan/zoom is a staging smoke check (jsdom can't measure @xyflow panes).

Touches the same panel as the graph batch (ISE-233..238) — stack on that chain, naturally after ISE-233.

Done when: the breadcrumb always names the focused asset first (linked, click centres it on screen), and the Back link follows it only when re-rooted.