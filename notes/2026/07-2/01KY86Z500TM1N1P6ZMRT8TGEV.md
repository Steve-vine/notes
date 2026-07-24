---
id: 01KY86Z500TM1N1P6ZMRT8TGEV
created: 2026-07-23T19:24:19.328902Z
updated: 2026-07-24T12:07:57.651689Z
type: task
title: 'Graph breadcrumb: "Focused on" first and always shown, name links to centre the node'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 240
sprint: s5khymf
comments:
- id: 01KY8ABZH2C3T0RG72GM9E6QDB
  author: Steve Vine
  at: 2026-07-23T20:23:45.442687Z
  text: |-
    Done on feature/ise-240-graph-breadcrumb (PR #221, stacked on #220).

    - "Focused on Y" now comes first and shows always — on the initial view Y is the page's own entity; "Back to X" follows only when re-rooted away from it (ISE-232).
    - Y is a link that pans/zooms the canvas onto that node without re-fetching or re-rooting: EntityGraphView gained a centerNonce prop; a bump calls setCenter on the root node's live position (respecting drags/layout). Works on all three surfaces — card, expanded, popout.

    Pulled the breadcrumb out as a pure GraphBreadcrumb component so its render logic is unit-testable off the canvas: initial view names the entity with no Back link; re-rooted names the new root then Back; the focused name calls onCentre never onBack. Actual pan/zoom is staging smoke (jsdom can't measure @xyflow panes).

    Frontend-only. Also updated one EntityDetailPage test whose findByText(name) began matching both the heading and the new always-on breadcrumb — scoped it to the heading. Full frontend suite (378) + build + lint green.
assignee: steve
priority: medium
task_status: done
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