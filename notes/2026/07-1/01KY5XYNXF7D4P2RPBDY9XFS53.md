---
id: 01KY5XYNXF7D4P2RPBDY9XFS53
created: 2026-07-22T22:08:17.83929Z
updated: 2026-07-22T22:08:17.83929Z
type: task
title: React Flow graph foundation — interactive canvas replacing the radial SVG
assignee: steve
priority: high
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 223
---
Replace the hand-rolled radial SVG (`EntityGraphView.tsx`, ISE-132) with an interactive graph canvas — the current view saturates now that real dependency data exists (Chinwag-v2 alone carries 14 `depends-on` spokes post-ISE-220/222, plus harvested `routes-to`/`runs-on` from ISE-215).

- Add `@xyflow/react` (MIT, npm-bundled — no CSP concern; ~50KB gz).
- **Custom ISE node component** (React/Mantine all the way down): entity type icon + name, group entities keep their distinct shape/colour treatment (rounded violet vs blue circles — the ADR 0037 §4 shape distinction must survive the port), click navigates to the entity.
- **Custom edge component**: colour by edge type, provenance rendered visibly (asserted / discovered / rule badges per ISE-217's pattern), **dashed for unconfirmed proposals**, stale-edge drift flagging carried over from the old view (ISE-143).
- Built-ins on: zoom/pan, minimap, drag-to-rearrange, selection. Initial layout mirrors today's radial rings (positions computed from hop distance) so the swap is familiar; fancier layouts are the follow-on task.
- Honest truncation preserved: the RING_CAP idea becomes a "+N more" expander node, never silent clipping.
- Replaces the graph panel on entity detail (`EntityDetailPage.tsx`). Old component deleted, tests ported (Vitest — note @xyflow needs jsdom ResizeObserver stubs).