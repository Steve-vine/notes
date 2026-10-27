---
id: 01M5YA8JFC9Q3C8QJV0SC6J8GZ
created: 2026-10-27T09:15:04.044042Z
updated: 2026-10-27T09:18:58.935292Z
type: task
title: A technology asset's page shows its open vulnerabilities, and an owner without an internal role sees and works theirs in the User Portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1372
sprint: s6wypy5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1367 and COM-1368.

## What people see

- **Inventory ▸ a technology asset:** a **Vulnerabilities** card.
  - It shows open counts by severity, the overdue count, and the five most severe, each a link.
  - "See all" opens the Register filtered to that system.
  - Shown to anyone who can view the asset *and* view vulnerabilities.
  - Until sprint 93 it sits beside the existing Findings card; sprint 93 folds that one in.
- **User Portal ▸ Inventory** (owners without an internal role, ADR 0072 §10):
  - each of their assets shows its open vulnerabilities;
  - a **Vulnerabilities** list shows those assigned to them, with the fix-by date and state.
  - Opening one shows its details, where it is, a recommendation and the timeline.
  - They can:
    - **comment**;
    - **mark fixed** (hand-recorded and pen-test only, as inside);
    - **ask for it to be accepted**, which leaves a comment and an action for the people who can accept.
  - They can't accept, change severity or reassign.

## Who can do what

- Inside: view vulnerabilities, plus the asset's own visibility.
- Portal: the vulnerability's owner only.

## Notes (technical)

- Portal endpoints under `/api/v1/portal`.
- **Add the new portal write routes to the exact-set test** in `tests/test_portal.py`. It runs as an integration test, so a miss only shows red on CI.
- Owner-only checks on every portal route.

**Chain:** on the chain (API).

**Done when:**
- the asset card shows true counts;
- a portal-only owner can find, comment on and mark fixed their vulnerability, and ask for acceptance;
- nobody else's vulnerabilities are reachable from the portal.