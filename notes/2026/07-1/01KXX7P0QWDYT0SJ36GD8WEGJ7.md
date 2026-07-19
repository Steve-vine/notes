---
id: 01KXX7P0QWDYT0SJ36GD8WEGJ7
created: 2026-07-19T13:05:09.884566533Z
updated: 2026-07-19T13:23:32.587202891Z
type: task
title: Per-integration capability display (System detail)
priority: medium
assignee: steve
task_status: backlog
label:
- feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 147
tech: null
sprint: sehghhk
blocked_by:
- 01KXX7NQ54DS82RCM7PQ0HVD84
---
**Sprint 15 (vertical slice: backend + UI).** Make "degrade gracefully by capability" visible — an operator should see what each integration can and cannot do.

- **Backend**: surface each `System`'s declared capabilities (from its connector's `capabilities()`).
- **UI**: **System detail** shows capability badges (**Alerts / Observations / Entities / Evidence / Actions**), and the screen degrades accordingly — a source with no Actions shows no action affordances; one with no Entities explains why it isn't in the estate graph.

**DoD**: every system shows its declared capabilities, and the affordances on its detail page match them (no action buttons for an Actions-less integration). Not done until the badges + degradation render.

Depends on ADR 0031.