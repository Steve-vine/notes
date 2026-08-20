---
id: 01M0E0YV2DQ3CJ4YT47RSET6KS
created: 2026-08-19T22:06:07.949335Z
updated: 2026-08-20T08:32:34.577706Z
type: task
title: Graph canvas foundation — React Flow ported from ISE
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 304
order: 2.75
sprint: sar11t4
blocked_by:
- 01M0E0Y94T0VVD9MABB9VDQ7NF
assignee: steve
label:
- feature
priority: medium
task_status: active
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