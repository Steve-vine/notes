---
id: 01M0FW84DAM9Y3BE9YN6NMHDYW
created: 2026-08-20T15:22:18.410344Z
updated: 2026-08-20T15:25:00.605184Z
type: task
title: Reset dragged positions to the computed layout — and a rings layout that never overlaps
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 321
sprint: sar11t4
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 36 follow-up (graph improvements, 2026-08-20). ISE's canvas carries an icon — "Reset dragged positions to the computed layout" — whose real value is tidiness: one click clears every overlap and lays the graph out readably. Port the affordance, and fix the reason our reset doesn't achieve that today.

* **The icon moves onto the canvas** (React Flow `Panel`, ISE's placement): an `ActionIcon` with the ISE wording as its tooltip/aria-label. It clears the persisted drag positions for the current root (`resetGraphLayout`) and re-runs the active layout from scratch. The page-level "Reset layout" button is replaced by it — one affordance, where the mess is.
* **Rings must compute a readable layout to reset to.** Today a full ring overlaps by construction: up to 13 slots × `NODE_W` 156px on a ring of radius `depth × 210` (circumference ~1300px at depth 1) cannot fit side by side. Grow each ring's radius to fit its occupancy — `max(RING_GAP × depth, slots × (NODE_W + gap) / 2π)`, kept monotonic so deeper rings stay outside shallower ones — in the model layer (`graphLayout.ts`), so it's unit-tested off the DOM: assert no two same-ring nodes closer than NODE_W, and ring ordering preserved.
* elk mode already computes overlap-free positions; reset there just re-runs it (existing `resetNonce` path — compose an internal nonce in the canvas with the prop so both still work).
* Tests: model-layer radius/no-overlap tests; a canvas test that the icon exists and that reset clears the persisted drag for the current root.

Refs: ADR 0048 §1; ISE `EntityGraphView.tsx` (reset affordance), `src/access/graph/graphLayout.ts`, `DirectoryGraphView.tsx`, `graphPersistence.ts`, `AccessGraphPage.tsx`.