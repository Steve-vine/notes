---
id: 01KY9FDGX9N915SX3BJNZBX0BF
created: 2026-07-24T07:11:13.321743Z
updated: 2026-07-24T10:23:48.184814Z
type: task
title: Graph layout stability — warm-start layout on depth change instead of redrawing from scratch
project: 01KX671DATY39VW6GWK3M2T3DN
number: 242
sprint: s5khymf
assignee: steve
label: null
priority: medium
task_status: done
---
Request (Steve, 2026-07-23): changing the graph depth redraws everything and moves all nodes around — keep the layout stable when changing depth.

Cause (`EntityGraphView.tsx`, layout effect): a depth change is a new query → new `built` graph → every node reset to its seeded ring position, then the async elk/d3 pass lays out the *entire* new node set with no memory of prior positions. Aggravators: Blast-mode ring angles depend on ring occupancy (`i / slots`), so revealing a ring reshuffles every angle; and the viewport refits whenever node count changes (`fitSignature` includes `nodes.length`), so the camera jumps too. Only hand-dragged positions (persisted) survive.

Fix — warm-start the layout, place only the delta:
- **Deepening**: existing nodes keep their current on-canvas positions; only newly revealed nodes are laid out around the existing frame. Per engine: d3-force seeds the simulation at current coordinates (or pins existing nodes); ELK layered has interactive modes that respect prior coordinates; Blast mode allocates stable per-node angles instead of recomputing from ring occupancy.
- **Shallowing**: remove the outer nodes, touch nothing else.
- **Camera**: don't refit on depth change — fit only on root/mode change (or ease to include the new ring without recentring).
- The same warm-start path should soften all rebuild-triggered jumps (filters, "+N more" expansion) since they flow through the same effect — verify, don't special-case depth only.
- Interaction with drag persistence unchanged: dragged positions still win over warmed/laid-out ones.

Sequencing: end of the graph chain — ISE-238 touches this exact effect (layout `.catch`), and ISE-233/236 change what triggers rebuilds; land those first.

Tests: layout warm-start is mostly geometry — unit-test the position-merge logic off-DOM (existing node id keeps prior position on deepen; removed on shallow; new node gets a position); Blast-mode stable-angle allocation unit-testable pure. Visual smoothness verified on staging smoke.

Done when: changing depth (either direction) leaves every already-visible node where it was (unless dragged), only adds/removes the delta, and the camera doesn't jump.