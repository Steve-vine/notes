---
id: 01KYB19YS87SKSP4QG0D5A1MJH
created: 2026-07-24T21:43:05.256549Z
updated: 2026-08-06T08:14:54.678783Z
type: task
title: Impact panel empty state links to the page it is on
project: 01KX671DATY39VW6GWK3M2T3DN
number: 270
sprint: s5khymf
comments:
- id: 01KYB4QR6PZVQ565Z4KQY3CH00
  author: Steve Vine
  at: 2026-07-24T22:43:02.998122Z
  text: |-
    Fixed on feature/ise-270-impact-empty-state-context (PR #249 → main).

    Made the thin-graph empty state context-aware on the existing `variant` prop:
    - compact (incident mount): unchanged — cross-links to /estate/{entityId} ("add what you know on the entity page"), which is correct because the affected entity is a different page.
    - full (entity mount): drops the self-link; text now "record what depends on this in the Relationships card below", and clicking scrolls to the Relationships card on the same page. RelationshipsCard gained id="relationships"; the scrollIntoView is guarded for jsdom.

    Honesty principle intact in both variants — still "may simply be incomplete", never "nothing depends on this".

    Tests: entity-mount shows the Relationships-card CTA and no self-link; incident-mount keeps the /estate cross-link. All 8 ImpactPanel tests pass; tsc/prettier/eslint green.

    Note: ISE-270 and ISE-272 both touch ImpactPanel.tsx but in different regions (270 = empty-state block; 272 = graph mount), so they should merge to staging cleanly.
assignee: steve
priority: medium
task_status: done
---
`ImpactPanel` (ISE-216) is mounted on two screens, and its thin-graph empty state — "No known dependents. The estate graph may simply be incomplete — *add what you know* on the entity page." (`ImpactPanel.tsx:122-125`) — was written for the incident "Affects" mount, where the link to `/estate/{entityId}` correctly takes the operator to the affected entity's Relationships card to assert the missing edges. On the entity detail page's "Impact preview" mount, the same link points at the page the operator is already standing on.

Fix: make the empty state context-aware (prop or variant, matching the existing `variant="compact"` pattern):

- **Incident mount**: keep the current text and cross-link to the entity page.
- **Entity mount**: drop the self-link; direct to the Relationships card on the same page — e.g. "No known dependents. The estate graph may simply be incomplete — record what depends on this in the Relationships card below", ideally anchored/scrolling to the card.

Keep the honesty principle intact in both variants (the comment above the empty state: an empty dependents list must never read as "nothing depends on this").