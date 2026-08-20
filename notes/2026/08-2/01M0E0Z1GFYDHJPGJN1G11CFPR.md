---
id: 01M0E0Z1GFYDHJPGJN1G11CFPR
created: 2026-08-19T22:06:14.543238Z
updated: 2026-08-20T09:08:23.064529Z
type: task
title: Access Graph explorer — page, controls and entry points
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 305
order: 2.0
sprint: sar11t4
blocked_by:
- 01M0E0YHDQEF56K51BVVG79MEK
- 01M0E0YV2DQ3CJ4YT47RSET6KS
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The user-facing surface: `/access/graph` joins the role-gated Access route group + sidebar (ADR 0048's IA amendment), wiring the canvas foundation to the backend endpoint.

* **Root picker**: debounced search over mirrored users + groups (existing directory endpoints); root also arrives via URL (`/access/graph?root=<object_id>`) so links deep-link.
* **Controls** (ISE's panel pattern, trimmed): direction (up/down/both), depth, edge-type filter chips (`member_of` / `owner_of`), a **business-role overlay toggle** (company from `useCompany()`), layout mode, fit/reset. Preferences persisted.
* **Interactivity**: click a node body → **re-root in place**; click the type icon → open the existing `UserDetailModal` / `GroupDetailModal` (`stopPropagation`); "+N more" expands its ring. Built-ins: `Background`, `Controls`, `MiniMap`, `fitView`.
* **Path highlight** — the "how does user X reach group Y" answer: pick a user and a target group on the canvas → highlight the membership chain(s) through nested groups (computed client-side over the returned edges), dimming the rest (ISE's ghosting opacities).
* **Entry points**: a "View in graph" affordance on `GroupDetailModal` and `UserDetailModal` → `/access/graph?root=…`.
* react-query hooks in `src/access/hooks.ts` convention (`enabled` on root); empty state (no root picked / mirror not yet synced), error state, loading skeleton; page tests.

Refs: ADR 0048, 0045 §10; `src/access/` (hooks + modals), `App.tsx` route group; ISE `EstateGraphPanel.tsx`, `EstateExplorerPage.tsx`.