---
id: 01KY5XYNXF7D4P2RPBDY9XFS53
created: 2026-07-22T22:08:17.83929Z
updated: 2026-07-23T18:34:27.742555Z
type: task
title: React Flow graph foundation — interactive canvas replacing the radial SVG
project: 01KX671DATY39VW6GWK3M2T3DN
number: 223
sprint: s5khymf
comments:
- id: 01KY5YZ1FTKZE65179QAMHXGJ8
  author: Steve Vine
  at: 2026-07-22T22:25:58.266875Z
  text: |-
    Done — PR #206 (feature/ise-223-react-flow-foundation → main).

    Replaced the radial SVG (ISE-132) with an interactive @xyflow/react canvas:
    - Custom Mantine nodes (type icon + name, click-to-navigate); groups keep the rounded-violet vs blue-circle shape distinction (ADR 0037 §4).
    - Custom edges coloured by type, provenance badge on direct hops (asserted/discovered/rule, ISE-217), dashed for unconfirmed proposals, red-dashed for stale drift (ISE-143).
    - Built-in zoom/pan/minimap/drag/selection; initial layout mirrors the old radial rings by hop distance.
    - RING_CAP is now an honest "+N more" expander node, never a silent clip.
    - New src/lib/graph.ts holds the shared edge-type + provenance vocabulary (RelationshipsCard refactored onto it).

    CI gates green locally: 346 tests pass, build (tsc strict + vite), ESLint, Prettier all clean. No backend change, so api-types stays clean.
- id: 01KY70GY4XJN1F0Q26YGTTRHVX
  author: Steve Vine
  at: 2026-07-23T08:12:27.677533Z
  text: 'RELEASED to main 2026-07-23 (PR #206, merge 83397a3). Smoke tests passed on staging; main CI green (tests + production image build). Feature branch deleted, staging reset to main.'
assignee: steve
priority: high
task_status: done
---
Replace the hand-rolled radial SVG (`EntityGraphView.tsx`, ISE-132) with an interactive graph canvas — the current view saturates now that real dependency data exists (Chinwag-v2 alone carries 14 `depends-on` spokes post-ISE-220/222, plus harvested `routes-to`/`runs-on` from ISE-215).

- Add `@xyflow/react` (MIT, npm-bundled — no CSP concern; ~50KB gz).
- **Custom ISE node component** (React/Mantine all the way down): entity type icon + name, group entities keep their distinct shape/colour treatment (rounded violet vs blue circles — the ADR 0037 §4 shape distinction must survive the port), click navigates to the entity.
- **Custom edge component**: colour by edge type, provenance rendered visibly (asserted / discovered / rule badges per ISE-217's pattern), **dashed for unconfirmed proposals**, stale-edge drift flagging carried over from the old view (ISE-143).
- Built-ins on: zoom/pan, minimap, drag-to-rearrange, selection. Initial layout mirrors today's radial rings (positions computed from hop distance) so the swap is familiar; fancier layouts are the follow-on task.
- Honest truncation preserved: the RING_CAP idea becomes a "+N more" expander node, never silent clipping.
- Replaces the graph panel on entity detail (`EntityDetailPage.tsx`). Old component deleted, tests ported (Vitest — note @xyflow needs jsdom ResizeObserver stubs).