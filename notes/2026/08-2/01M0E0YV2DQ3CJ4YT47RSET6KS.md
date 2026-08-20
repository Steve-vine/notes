---
id: 01M0E0YV2DQ3CJ4YT47RSET6KS
created: 2026-08-19T22:06:07.949335Z
updated: 2026-08-20T14:51:23.599508Z
type: task
title: Graph canvas foundation — React Flow ported from ISE
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 304
order: 2.75
sprint: sar11t4
blocked_by:
- 01M0E0Y94T0VVD9MABB9VDQ7NF
comments:
- id: 01M0F6TP48V46YQ4B8CKBBB8W3
  author: Steve Vine
  at: 2026-08-20T09:07:57.704484Z
  text: |-
    Done — PR #297 merged to main (squash 2872afc), CI green (frontend suite; backend jobs path-skipped on a frontend-only diff).

    The reusable canvas layer landed under src/access/graph/, ported from ISE with its load-bearing split preserved:

    - graphLayout.ts — the DOM-free model layer, zero @xyflow imports: buildElements with radial seed positions by depth, client-side edge-type filtering with subtree cascade, per-ring cap (12) folding overflow into a clickable "+N more" node with dashed arrowhead-less hint edges, path-highlight dimming, warmStartPositions, and keepCanvasState (ISE's documented unmeasured-node gotcha — without the merge React Flow hides every rebuilt node). One Compass-specific addition: parentsOf derives each node's spanning-tree parent from the real edge list, since our leaner API response carries depth but no parent pointer.
    - graphMeta.ts — the vocabulary named once: member_of/owner_of/grants colours + dash styles, node-kind glyphs and shapes (user pills, squarer groups per the collection convention, role nodes visually third in teal), labelScale.
    - DirectoryGraphView.tsx — the canvas: split click targets (body re-roots, kind icon opens detail, stopPropagation + nodrag/nopan), custom edge with floating endpoints, per-edge arrowhead coloured to its stroke and an EdgeLabelRenderer badge, two layout modes (synchronous rings + cancellation-guarded dynamically-imported ELK layered), per-root drag persistence, text hard-pinned dark on the light node fills (the dark-mode trap).
    - src/test/reactflow.ts — the jsdom geometry stubs.

    @xyflow/react ^12.11.2 + elkjs ^0.9.3 added; elkjs stays out of the initial bundle. 17 tests: 14 model-layer off the DOM, 3 mounting the canvas.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
The reusable canvas layer, ported from ISE and adapted to the directory vocabulary — no page yet (that's the explorer task).

* **Dependencies**: `@xyflow/react` ^12 + `elkjs`; import `@xyflow/react/dist/style.css` once in the canvas component.
* **Model layer** (`lib/graphLayout.ts` equivalent) — port ISE's pure builder: `buildElements(graph, opts)` → `{nodes, edges}` with radial seed positions by depth, client-side filtering, per-ring cap folding overflow into a clickable **"+N more"** node (dashed, arrowhead-less hint edge so it never reads as a real relationship), and the warm-start merge helpers. **Zero `@xyflow` imports** so it's unit-tested without the DOM (Vitest).
* **Canvas + custom components**: user nodes as pills, group nodes squarer (ISE's collection convention), role-overlay nodes visually third; Tabler icon per kind; root marked by outline/weight, not hue. Custom edge with floating endpoints, per-edge arrowhead coloured to the stroke, and an `EdgeLabelRenderer` badge. Register node/edge types as module-level constants.
* **Edge metadata registry** (`lib/graph.ts` equivalent): `member_of` / `owner_of` / `grants` each named, coloured and dash-styled **once**, shared by canvas and any legend/table.
* **Layout**: two modes to start (simpler than ISE's four) — the synchronous radial seed, and ELK layered (`elkjs` dynamically imported, cancellation-guarded so a stale layout never lands). Port `keepCanvasState` — merging React Flow's `measured` dims onto rebuilt nodes; without it a rebuild hands RF unmeasured nodes and it hides them (ISE's documented gotcha).
* **Theming**: Mantine CSS vars via the `colourVar` pattern; node fills stay a light shade with text hard-pinned dark (`--mantine-color-black`) — ISE's documented dark-mode trap where `dimmed` flips light and vanishes.
* **Tests**: layout-module unit tests off the DOM; ISE's jsdom stubs (`test/reactflow.ts` — `DOMMatrixReadOnly`, `offsetWidth/Height`, `getBBox`) for the few tests that mount the canvas.

Refs: ADR 0048; ISE `EntityGraphView.tsx`, `lib/graphLayout.ts` (+ its test), `lib/graph.ts`, `test/reactflow.ts`.