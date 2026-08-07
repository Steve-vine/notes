---
id: 01KYB20CWYKYFWTZWNRX08YMDH
created: 2026-07-24T21:55:20.606237Z
updated: 2026-08-07T10:35:25.697441Z
type: task
title: Remove the embedded impact graph from the incident Affects panel
project: 01KX671DATY39VW6GWK3M2T3DN
number: 272
sprint: s5khymf
comments:
- id: 01KYB4KEHVTH9SPNMQ4N5KAVVS
  author: Steve Vine
  at: 2026-07-24T22:40:42.043829Z
  text: |-
    Done on feature/ise-272-remove-embedded-impact-graph (PR #248 → main).

    Deleted the ImpactGraph component + its "show impact graph" expander from the compact variant (nothing else referenced it) and removed the now-unused imports. The panel keeps the DependentRow list and the unconfirmed-proposals alert. Where the expander was, added a "View in estate graph →" link to /estate/{entityId} — the affected entity's page carries the full-size graph panel (ISE-233) and the Estate Explorer pop-out (ISE-244).

    Test updated: the old lazy-expander test is replaced by one asserting the compact variant has no expander, links out to the entity's estate graph (href=/estate/ent-db), and draws no inline canvas. All 6 ImpactPanel tests pass; tsc/prettier/eslint green.
assignee: steve
priority: medium
task_status: done
---
The incident "Affects" panel (`ImpactPanel` `variant="compact"` on `IssueDetailPage.tsx:1373`) embeds a full `EntityGraphView` behind an expander (`ImpactGraph`, `ImpactPanel.tsx:174` — upstream, depth 3). At panel size it's unusable (Steve, 2026-07-24) — the React Flow canvas is too small to read or navigate once a real blast radius renders.

Remove the embedded graph from the compact variant (delete `ImpactGraph` and its expander if nothing else uses it). The panel keeps the `DependentRow` list — the readable answer to "what does this hit" — and the unconfirmed-proposals alert. For the visual view, link out instead of embedding: the affected entity's page already has the full-size graph panel with the upstream mode (ISE-233), and the Estate Explorer pop-out (ISE-244) exists precisely for "this needs a real canvas" — e.g. a "View in estate graph →" link where the expander was.

Note: the entity-page (full) variant already dropped its graph for exactly this duplication reason (comment at ImpactPanel.tsx:161-163) — this finishes the thought for the compact variant.