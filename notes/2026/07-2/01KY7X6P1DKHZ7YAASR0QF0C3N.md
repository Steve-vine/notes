---
id: 01KY7X6P1DKHZ7YAASR0QF0C3N
created: 2026-07-23T16:33:40.397409Z
updated: 2026-07-24T16:07:42.982685Z
type: task
title: Dependancy graph exploring
project: 01KX671DATY39VW6GWK3M2T3DN
number: 232
sprint: s5khymf
comments:
- id: 01KY7Y8QZFQXXSKVK4BT5Z17TM
  author: Steve Vine
  at: 2026-07-23T16:52:16.495325Z
  text: |-
    Done — PR #214 (feature/ise-232-graph-reroot → main).

    Clicking a node now re-centres the graph on that node and stays in the graph, instead of navigating to the detail page.

    - Found and fixed the inconsistency at the source: the root node used to navigate away directly while neighbours honoured onActivate — so a click "sometimes left". The root now routes through the same `activate` path as every other node (graphLayout).
    - EstateGraphPanel tracks the centred entity (rootId) as state; node clicks re-root via the existing onNodeActivate hook. Graph query, drag-persistence key, layout reset and pop-out all follow rootId; it resets when the page opens a different entity.
    - Breadcrumb ("← Back to {entity}" + "Focused on {current}") gives the one way out of a re-rooted graph.
    - With no onActivate override, a click still opens the detail page, so other graph surfaces (impact panel) are unchanged.

    New graphLayout unit tests cover both behaviours. Full frontend suite green (366), build green, eslint 0 errors, prettier clean. Disjoint files from ISE-231.

    Moving to Review; deploying both to staging now.
- id: 01KY843QBZR7CWRW0Y8T2V6PFE
  author: Steve Vine
  at: 2026-07-23T18:34:23.487059Z
  text: 'RELEASED to main 2026-07-23. PR #214 merged (8586cb6). Main CI green (re-ran one transient PyPI-DNS failure). Staging reset to main; branch deleted.'
assignee: steve
label: null
priority: medium
task_status: done
---
When clicking on a node in the dependancy graph, rather than navigating to that asset in the estate, and showing the detail page, stay within the graph and switch to that node.  It should be possible to navigate around without leaving the graph.

This doesn’t always happen, sometimes you can click on other nodes and stay in the graph but then some times it will leave the graph and navigate to the detail screen of the item I clicked on.