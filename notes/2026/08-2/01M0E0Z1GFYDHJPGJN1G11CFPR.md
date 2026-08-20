---
id: 01M0E0Z1GFYDHJPGJN1G11CFPR
created: 2026-08-19T22:06:14.543238Z
updated: 2026-08-20T14:51:24.135455Z
type: task
title: Access Graph explorer — page, controls and entry points
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 305
order: 2.0
sprint: sar11t4
blocked_by:
- 01M0E0YHDQEF56K51BVVG79MEK
- 01M0E0YV2DQ3CJ4YT47RSET6KS
comments:
- id: 01M0F9M3QJKN3Q7BG8Z4NJVQNM
  author: Steve Vine
  at: 2026-08-20T09:56:47.986447Z
  text: |-
    Done — PR #299 merged to main (squash d0388ed), CI green (rebased over COM-300's merge first; the one conflict was adjacent type aliases in api/client.ts).

    /access/graph is live in the role-gated Access section, with an "Access Graph" sidebar entry between Recertification and View Groups:

    - Root picker: debounced search over the mirrored user + group inventories; the root lives in the URL (?root=<object_id>) so links deep-link, and re-rooting is a URL change — back button walks your exploration history.
    - Controls: direction (up/down/both), depth 1–6, member_of/owner_of chips (grants is governed by the business-role overlay toggle instead, so the chips never show a kind the server didn't send), rings/layered layout, reset layout. Reading preferences persist in localStorage.
    - Interactivity: node body re-roots in place; the kind icon opens the existing UserDetailModal / GroupDetailModal; role nodes open their matrix page (a role is not a directory object, so it never pretends to be a root); "+N more" expands its ring.
    - Path highlight: pick a user and a target group on the canvas → every membership chain between them lights up (forward/backward reachability intersection over the returned member_of edges — parallel chains all lit), the rest dimmed at the ghosting opacities. No chain → nothing dims, and the page says so.
    - Entry points: "View in graph" on both detail modals → /access/graph?root=…; server truncation surfaces as a warning; empty/error/loading states.

    Tests: 8 page tests (deep-link, re-root, modal-not-re-root, overlay opt-in, dimming with opacity assertions, truncation, honest 404, empty state) + 7 path-highlight unit tests. Note: the full-suite run tripped the known CPU-load flake (PortalRouting.test — passes in isolation), unrelated to this diff.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The user-facing surface: `/access/graph` joins the role-gated Access route group + sidebar (ADR 0048's IA amendment), wiring the canvas foundation to the backend endpoint.

* **Root picker**: debounced search over mirrored users + groups (existing directory endpoints); root also arrives via URL (`/access/graph?root=<object_id>`) so links deep-link.
* **Controls** (ISE's panel pattern, trimmed): direction (up/down/both), depth, edge-type filter chips (`member_of` / `owner_of`), a **business-role overlay toggle** (company from `useCompany()`), layout mode, fit/reset. Preferences persisted.
* **Interactivity**: click a node body → **re-root in place**; click the type icon → open the existing `UserDetailModal` / `GroupDetailModal` (`stopPropagation`); "+N more" expands its ring. Built-ins: `Background`, `Controls`, `MiniMap`, `fitView`.
* **Path highlight** — the "how does user X reach group Y" answer: pick a user and a target group on the canvas → highlight the membership chain(s) through nested groups (computed client-side over the returned edges), dimming the rest (ISE's ghosting opacities).
* **Entry points**: a "View in graph" affordance on `GroupDetailModal` and `UserDetailModal` → `/access/graph?root=…`.
* react-query hooks in `src/access/hooks.ts` convention (`enabled` on root); empty state (no root picked / mirror not yet synced), error state, loading skeleton; page tests.

Refs: ADR 0048, 0045 §10; `src/access/` (hooks + modals), `App.tsx` route group; ISE `EstateGraphPanel.tsx`, `EstateExplorerPage.tsx`.