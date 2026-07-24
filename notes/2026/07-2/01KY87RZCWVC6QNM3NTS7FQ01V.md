---
id: 01KY87RZCWVC6QNM3NTS7FQ01V
created: 2026-07-23T19:38:25.564611Z
updated: 2026-07-24T14:48:47.827009Z
type: task
title: Estate Explorer — full-screen dependency graph with asset search, launched from the Estate list
project: 01KX671DATY39VW6GWK3M2T3DN
number: 241
sprint: s5khymf
comments:
- id: 01KY8AR6AKWY8CJT95D34P8AK4
  author: Steve Vine
  at: 2026-07-23T20:30:25.619514Z
  text: |-
    Done on feature/ise-241-estate-explorer (PR #222, stacked on #221).

    - "Estate Explorer" button on the Estate list header → dedicated chromeless route /estate/explorer, in the style of the ISE-228 pop-out (shareable URL ?root=<id>&name=<name>).
    - Search box up top reuses the estate list as the entity picker (GET /entities?q=), the same pattern the edge-assertion UI uses. Empty state before first pick is the box + "Search for an asset to explore." prompt, no canvas. Selecting roots the graph; searching again re-roots (the panel resets when entityId changes).
    - New EstateGraphPanel `explorer` variant: same bare, filling treatment as the pop-out but fills the parent container the page sizes below the search bar (ISE-237 flex height) rather than 100vh, and hides the now-meaningless expand/pop-out controls.

    DoD/nav decision (the brief flagged it for plan mode): button-only, NO nav entry. The Explorer is a focused full-screen MODE of the Estate — entered from the Estate page, exited with a back link — not a separate IA section, so adding a nav item that drops you out of the app shell would be odd. It reuses the existing Estate nav.

    Frontend-only, no API. Tests: search-first empty state (no canvas); selecting a result roots the graph on it; searching again replaces the root. Canvas internals stay covered off-DOM + staging smoke. Full frontend suite (381) + build + lint green.
assignee: steve
priority: medium
task_status: done
---
Request (Steve, 2026-07-23): add an "Estate Explorer" button to the Estate list page (`EstatePage.tsx`). Clicking it opens the dependency graph full screen with a search box at the top — search for an asset, then click through the graph as normal (re-rooting, ISE-232).

Shape:
- **Button on the Estate list page** header, "Estate Explorer".
- **Full-screen graph surface** — reuse `EstateGraphPanel`'s full-screen treatment (a dedicated route, e.g. `/estate/explorer`, in the style of the ISE-228 popout page, rather than a modal bolted to the list — gives it a shareable URL and plays with ISE-237's flex-height fix).
- **Search box at the top**: reuse the entity-picker pattern from the edge-assertion UI (`RelationshipsCard.tsx` — debounced `GET /api/v1/entities?q=`, "reuses the estate list as the entity picker rather than inventing a search"). Selecting a result roots the graph on that entity.
- **Empty state before first selection**: the search box with a short prompt ("Search for an asset to explore"), no canvas.
- After rooting, everything behaves as the normal explorer: modes, depth, filters, re-rooting, breadcrumb (ISE-240's "Focused on" applies here too — searching again just re-roots).
- No API changes; frontend-only.

DoD/pane-of-glass note: this is a new user-facing surface — check whether it warrants its own left-nav entry (`components/nav.ts`) vs. living behind the button only; decide in plan mode. UI brief (`docs/briefs/ui-brief.md`) conventions apply.

Sequencing: stacks on the graph batch (after ISE-233/240 — shares the panel and breadcrumb); benefits from ISE-237 (flex height) and ISE-236 (working filters) but is not blocked by them.

Tests: route renders search-first empty state; selecting a search result mounts the graph rooted on it; subsequent search replaces the root. Canvas behaviour itself is covered by the existing off-DOM tests + staging smoke.

Done when: an operator can go Estate list → Estate Explorer → search "kora" → land on the Kora graph full screen → click through the estate from there.