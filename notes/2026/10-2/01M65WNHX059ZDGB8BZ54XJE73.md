---
id: 01M65WNHX059ZDGB8BZ54XJE73
created: 2026-10-30T07:51:24.83226Z
updated: 2026-10-30T07:51:28.300441Z
type: task
title: Someone named on a review sees its commitments in Contracts ▸ Commitments, not only one at a time — the list shows the commitments from reviews they're on, even without View contracts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1463
sprint: s2v7d6y
assignee: steve
label:
- follow_up
priority: low
task_status: todo
---
Sprint 98, Contract Review (ADR 0134). Gap found while building COM-1443.

## What people see

- Someone named on a review (an owner or a reviewer) but without *View contracts* can already open each of that review's commitments, from the review or from an Action. **Contracts ▸ Commitments** shows them nothing.
- After this, the list shows them the commitments from reviews they're named on, with the same filters. Anyone with *View contracts* still sees every commitment.
- The client filter offers only the clients those commitments belong to.

## Who can do what

Unchanged: reading a commitment needs *View contracts* or a place on its review. Recording a check is still for the commitment's owner.

## Notes (technical)

- `GET /companies/{id}/contracts/commitments` (`api/v1/contracts_commitments.py:257`) depends on `require_contracts_view`. Drop that to the review-access rule the detail route uses, then filter by review membership when the user lacks *View contracts*.
- Clients list for the filter: the same rule (`contracts_clients.py:92`), or derive the options from the commitments returned.
- Add the menu entry for a reviewer without View contracts if the Contracts section is hidden from them.

**Chain:** independent (no migration; no OpenAPI shape change).

**Done when:** on staging, a reviewer without View contracts sees the commitments from their review in Contracts ▸ Commitments, and none from other reviews.