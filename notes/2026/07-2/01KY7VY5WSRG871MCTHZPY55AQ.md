---
id: 01KY7VY5WSRG871MCTHZPY55AQ
created: 2026-07-23T16:11:33.145153Z
updated: 2026-07-23T18:34:24.474782Z
type: task
title: Dependancy graph enhancements
project: 01KX671DATY39VW6GWK3M2T3DN
number: 231
sprint: s5khymf
comments:
- id: 01KY7XZZ0HYRVZ4QVMR91E0N75
  author: Steve Vine
  at: 2026-07-23T16:47:28.785802Z
  text: |-
    Done — PR #213 (feature/ise-231-graph-edge-labels → main).

    - Edge-type is now a pill (Badge) with the human label ("Depends on", not "depends-on"), coloured by edge kind — matching the provenance pill.
    - Labels stack vertically over the line: relationship on top, provenance beneath.
    - Directional arrowhead at each connector's target end (own per-edge SVG marker so it matches the edge stroke colour) → reads "A —(depends on)→ B".
    - Stale edges keep the drift signal: relationship pill turns red, "… · stale".

    Build green (tsc -b + vite), eslint 0 errors, prettier clean, graph model tests pass. Visuals verified on the staging build (jsdom can't render @xyflow edges).

    Moving to Review; deploying to staging alongside ISE-232.
- id: 01KY843MXKB4XZXBTRVCY6ZNXA
  author: Steve Vine
  at: 2026-07-23T18:34:20.979309Z
  text: 'RELEASED to main 2026-07-23. PR #213 merged (57604ee). Main CI green after re-running one job (initial api-types failure was a transient PyPI DNS blip during venv setup — `Temporary failure in name resolution`, not a code issue). Staging reset to main; branch deleted.'
assignee: steve
priority: medium
task_status: done
---
Stack the connector information vertically rather than horizontally. E.g.
Currently on a connector it might say “depends on (Asserted)”
Change that to 
Depends on
(Asserted)

Also make the depends on (and anything else that goes in here) a pill, like Asserted.
Make all connector labels on top of the connector line.

Add an arrow to the end of the connectors to explain the relationship E.g.
Asset-A —— (Depends on)——>Asset-B