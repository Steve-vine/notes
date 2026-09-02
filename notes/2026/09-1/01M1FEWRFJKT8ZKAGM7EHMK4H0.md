---
id: 01M1FEWRFJKT8ZKAGM7EHMK4H0
created: 2026-09-01T21:44:36.082829Z
updated: 2026-09-02T22:35:38.828142Z
type: task
title: 'Business Applications: capabilities, criticality and the detail page'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 765
sprint: s7nj09w
comments:
- id: 01M1J46QW9KYWDETF3X746GPZ5
  author: Steve Vine
  at: 2026-09-02T22:35:32.105522Z
  text: |-
    Built — PR #705 (feature/ise-765-business-application-capabilities), migration 0146.

    WHAT SHIPPED
    - Capabilities: a named need + an ordered list of providers, best first. Authored as STRUCTURE; the state is derived at read time and never stored. Two channels reported side by side and never collapsed — service state (healthy/degraded/down) and resilience (protected/unprotected/no fallback). A single-provider capability is never degraded and reports "no fallback", so the single point of failure is visible before the day it matters.
    - The capability modal ends by stating what ISE WILL CONCLUDE from the list just built, against the providers actually chosen.
    - Business Criticality on the Business Application and nowhere else. A Business Service displays the highest among its applications (`criticality_rollup`), derived at read time — presentation, not authority. Unset raises an Observation; the roll-up returns null rather than inventing Low.
    - Business Application Context as the page's lede, editable in place.
    - ADR 0108 §2 entity rule (`{"id":…, "type":"entity", "entity_id":…}`, carrying nothing else — the API REFUSES one that carries more rather than dropping half). A named member that is retired holds its row, struck through and dated.
    - Members table with How / Role / Entity Context, the graded–explainable–unknown gradient totalled in the header, and the unassessed count on the member it landed on next to its empty context prompt.
    - Prune exemption widened to directly-named entities AND capability providers (ADR 0039 §4 + ADR 0108 §3).
    - Confirming a proposal now navigates to the new page — the 198 sat unworked because saying yes led nowhere.

    TWO TRAPS FOUND WHILE BUILDING
    1. Both estate Observations (faulty rule, ungraded criticality) MUST reconcile in ONE `reconcile_findings` call. Its recovery sweep closes any open observation of the estate System the batch did not report, so two calls would have each pass recover the other's findings — every Business Application observation would flap on every sync tick. There is a test for this.
    2. `parse_rules` must read a rule with no `type` as a PREDICATE. Every rule written before this has none, and reading them as anything else would empty every Business Application in the estate at once.

    Migration 0146: `business_application.context` + `.criticality` (nullable, no server default — unset is a real state), plus `business_capability` / `capability_provider`. `capability_provider.entity_id` is SET NULL with an `entity_name` snapshot beside it, so a provider whose entity is pruned still reads. No table for the Business Service.

    Tests: `tests/test_business_capabilities.py` (state derivation, pure — the ADR's own answering-service and call-routing cases), `tests/integration/test_business_application_detail.py`, new cases in `test_business_applications.py`, and `BusinessApplicationDetail.test.tsx`.
assignee: steve
label:
- feature
priority: medium
task_status: review
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
- **Business Criticality** (Low / Medium / High / Critical) authored here on the Business Application, and nowhere else. Unset raises an Observation rather than defaulting. A Business Service displays a roll-up — the highest among its applications — which is derived for the dashboard, never authored.

**No schema change for Business Service.** Criticality lands on `business_application`, which already has a table; the roll-up is computed at read time.

**Watch:** 198 proposals sit unworked, and they are the mechanism that would populate any of this. An editor nobody uses reproduces the current state; the path from proposal to definition belongs in the design.

**Blocked by** nothing further — ADRs 0108 and 0109 are accepted.