---
id: 01KYB19YS87SKSP4QG0D5A1MJH
created: 2026-07-24T21:43:05.256549Z
updated: 2026-07-24T22:23:53.424269Z
type: task
title: Impact panel empty state links to the page it is on
project: 01KX671DATY39VW6GWK3M2T3DN
number: 270
sprint: s5khymf
assignee: steve
priority: medium
task_status: todo
---
`ImpactPanel` (ISE-216) is mounted on two screens, and its thin-graph empty state — "No known dependents. The estate graph may simply be incomplete — *add what you know* on the entity page." (`ImpactPanel.tsx:122-125`) — was written for the incident "Affects" mount, where the link to `/estate/{entityId}` correctly takes the operator to the affected entity's Relationships card to assert the missing edges. On the entity detail page's "Impact preview" mount, the same link points at the page the operator is already standing on.

Fix: make the empty state context-aware (prop or variant, matching the existing `variant="compact"` pattern):

- **Incident mount**: keep the current text and cross-link to the entity page.
- **Entity mount**: drop the self-link; direct to the Relationships card on the same page — e.g. "No known dependents. The estate graph may simply be incomplete — record what depends on this in the Relationships card below", ideally anchored/scrolling to the card.

Keep the honesty principle intact in both variants (the comment above the empty state: an empty dependents list must never read as "nothing depends on this").