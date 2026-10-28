---
id: 01M61ZEMEQ4KVPYD4DJ5YE033C
created: 2026-10-28T19:23:06.071603Z
updated: 2026-10-28T19:24:40.884967Z
type: task
title: A business function says what it depends on, and its recovery targets reach those systems — each system shows how fast the business needs it back, and is flagged where IT's own targets fall short
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1409
sprint: stqs5r1
blocked_by:
- 01M61ZE32CHKVH2PC0F8S7B6KR
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 95, Business Continuity (ADR 0131, COM-1407). Builds on COM-1408 (the BIA).

## What people see

- **In the BIA**, each function gains **Depends on**:
  - systems (technology assets), data assets and vendors, picked from the company's registers;
  - people and sites, as free text ("payroll team, 2 people", "Wrexham office").
- **Inventory ▸ a system** gains a **Continuity** card, from the latest approved BIA:
  - **Needed back within 4 hours** and **Data loss tolerated: 1 hour**, with the function(s) that set them ("Payroll, Customer support line — BIA RA-12");
  - reached directly, or through the system's existing dependencies (a database the CRM depends on inherits the CRM's target), saying which;
  - beside them, the system's own RTO / RPO (what IT says it can do), unchanged;
  - flagged **Can't meet the business need** where its RTO or RPO is longer, and **No recovery target** where the business needs it but it has none.
- **Inventory ▸ technology assets list** gains a filter **Continuity flagged** and a **Needed back within** column (sortable).
- **A vendor** a function depends on shows "Payroll depends on this vendor — needed back within 4 hours" on its page.
- A system with no approved BIA behind it shows nothing new.

## Who can do what

Editing dependencies is part of working the BIA (its assessors). Anyone who can see the system sees its Continuity card.

## Notes (technical)

- Function → asset / data asset / vendor link tables, frozen with the BIA at approval.
- Target derivation: walk `container_dependencies` (cycle-safe), min RTO / RPO, read from the latest approved, non-superseded BIA per company. One function in `core/` used by the card, the list filter, the Continuity view and Polaris.
- Nothing writes the system's own `rto_minutes` / `rpo_minutes`.

**Chain:** on the chain (migration + API).

**Done when:** on staging, an approved BIA with Payroll depending on a system sets that system's Continuity card; a system with a longer RTO is flagged; a database it depends on inherits the target.