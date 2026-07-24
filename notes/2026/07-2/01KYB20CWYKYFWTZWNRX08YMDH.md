---
id: 01KYB20CWYKYFWTZWNRX08YMDH
created: 2026-07-24T21:55:20.606237Z
updated: 2026-07-24T22:38:13.102083Z
type: task
title: Remove the embedded impact graph from the incident Affects panel
project: 01KX671DATY39VW6GWK3M2T3DN
number: 272
sprint: s5khymf
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The incident "Affects" panel (`ImpactPanel` `variant="compact"` on `IssueDetailPage.tsx:1373`) embeds a full `EntityGraphView` behind an expander (`ImpactGraph`, `ImpactPanel.tsx:174` — upstream, depth 3). At panel size it's unusable (Steve, 2026-07-24) — the React Flow canvas is too small to read or navigate once a real blast radius renders.

Remove the embedded graph from the compact variant (delete `ImpactGraph` and its expander if nothing else uses it). The panel keeps the `DependentRow` list — the readable answer to "what does this hit" — and the unconfirmed-proposals alert. For the visual view, link out instead of embedding: the affected entity's page already has the full-size graph panel with the upstream mode (ISE-233), and the Estate Explorer pop-out (ISE-244) exists precisely for "this needs a real canvas" — e.g. a "View in estate graph →" link where the expander was.

Note: the entity-page (full) variant already dropped its graph for exactly this duplication reason (comment at ImpactPanel.tsx:161-163) — this finishes the thought for the compact variant.