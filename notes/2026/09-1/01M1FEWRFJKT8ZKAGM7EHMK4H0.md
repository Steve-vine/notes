---
id: 01M1FEWRFJKT8ZKAGM7EHMK4H0
created: 2026-09-01T21:44:36.082829Z
updated: 2026-09-02T20:30:49.867596Z
type: task
title: 'Business Applications: capabilities, criticality and the detail page'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 765
sprint: s7nj09w
assignee: steve
label:
- feature
priority: medium
task_status: backlog
tech: null
---
Build what ADR 0108 and ADR 0109 define. The screen is designed — see UI brief §14 and the mockup.

**A Business Application detail page**, which does not exist today (the list has only an inline rules cell). Sections follow the incident-page shell: fixed titles, present when empty, one fixed colour each.

**In scope:**
- Business Application Context as the page's lede — a first-class column, editable in place.
- **Capabilities**: a named need plus an ordered list of providers. Authoring is search-the-estate, add, reorder, remove; the modal ends by stating what ISE will conclude from the list just built.
- Derived state, never entered: service state (healthy / degraded / down) and resilience (protected / unprotected / no fallback) shown as separate facts.
- The **direct-entity rule** from ADR 0108, and a missing named member holding its row struck through.
- **Members** with the Role column, Entity Context editable inline, and the graded / explainable / unknown totals.
- **Business Criticality** on the Business Service, inherited by the Business Application as the highest of the services it composes into, overridable. Unset raises an Observation rather than defaulting.

**Schema note:** ADR 0109 requires giving Business Service a table — it is only an asserted entity type today, and criticality decides who gets woken.

**Watch:** 198 proposals sit unworked, and they are the mechanism that would populate any of this. An editor nobody uses reproduces the current state; the path from proposal to definition belongs in the design.

**Blocked by** nothing further — ADRs 0108 and 0109 are accepted.