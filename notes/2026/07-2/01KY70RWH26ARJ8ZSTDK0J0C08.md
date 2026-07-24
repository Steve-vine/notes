---
id: 01KY70RWH26ARJ8ZSTDK0J0C08
created: 2026-07-23T08:16:48.162261Z
updated: 2026-07-24T12:07:55.225989Z
type: task
title: React Flow graph improvements
project: 01KX671DATY39VW6GWK3M2T3DN
number: 228
sprint: s5khymf
comments:
- id: 01KY72C8HEC44RKJXX9GDJ309Z
  author: Steve Vine
  at: 2026-07-23T08:44:51.630126Z
  text: |-
    Implemented and in review — PR #210 (feature/ise-228-react-flow-graph-improvements → main). Frontend-only; no API/backend change.

    All three points addressed:
    - Floating edges: each edge end now anchors on the point of its node's border facing the neighbour (computed from measured node geometry via useInternalNode), so a hub like Chinwag (~14 deps) fans its connectors around the perimeter instead of stacking them all on one bottom/top handle and running lines over the node. Pure geometry helper (borderIntersection/floatingEdgeParams) in graphLayout.ts, unit-tested off the DOM; falls back to handle coords for the frame before nodes are measured.
    - Colours: node fill is always a light shade regardless of theme, so the label read light-grey-on-light-blue in dark mode. Node text + icon are now black; the env / "+N folded" sub-labels a fixed mid-grey. Legible on both themes.
    - Expand + pop-out: header gains an expand-to-fullscreen toggle (fullscreen modal, minimize control, Esc closes) and a pop-out icon that opens the graph in a bare, separately-resizable window via a chromeless authenticated /estate/:entityId/graph route (no app nav). Canvas height flexes to fill in both.

    Tests: new pure geometry unit tests; frontend eslint/build/vitest (358) all green.

    Smoke-test notes: (1) floating edges + dark-mode black text are the visual bits to eyeball; (2) the pop-out opens a real browser window — check the popup isn't blocked and that it renders authenticated (rides the shared session cookie).
assignee: steve
priority: medium
task_status: done
---
### Dependancy graph section
Can this section be given an expand icon to expand the section's height up to the full screen size.
Also add a pop-out icon that opens the section in a new window that can be resized separately.

### Colours
In dark mode the text on the graph elements is light grey on light blue.  Change the text/icon colour to black.

### Nodes
Node connections are a little difficult to read due to 2 things.
- On a node connected to multiple other nodes, all the connections come out of the same point, so on something like Chinwag which currently has about 14 dependancies, there are a lot of overlapping lines coming out of the same single point and running over the top of the Chinwag node.
- Where multiple nodes are connected to the same node, e.g. Chinwag again, the connectors for every node come out of the top of the node, so in a radial view for instance, nodes that are placed above the connecting node have a line coming out of the  top, then curving down, and running back to the next node.

I think the fix for this would be ‘floating edges’ where the handle isn’t at a fixed point.