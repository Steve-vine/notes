---
id: 01M65WNXX5SKV73ZF6HTHPF07E
created: 2026-10-30T07:51:37.125043Z
updated: 2026-10-30T07:51:39.701223Z
type: task
title: Anyone who manages incident settings can set a rule's "client affected" condition — the client picker lists the company's clients without needing View contracts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1464
sprint: s2v7d6y
assignee: steve
label:
- follow_up
priority: low
task_status: todo
---
Sprint 98, Contract Review (ADR 0134). Gap found while building COM-1444.

## What people see

- In **Incidents ▸ Settings**, a notification rule can carry the condition **Applies only when: client affected is …**. Its client picker lists clients from Contracts, so someone with *Manage incident settings* but not *View contracts* sees an empty list and can't set or change it.
- A rule created from a contract already has its client, so this only bites when someone adds or edits the condition by hand.
- After this, the picker lists the company's clients (names only) for anyone who can manage incident settings. The incident's **Clients affected** picker on Impact behaves the same for anyone who can edit the incident.

## Who can do what

- Seeing client **names** for these pickers: *Manage incident settings*, or editing the incident.
- Nothing else about clients (contracts, commitments, positions) becomes visible.

## Notes (technical)

- `GET /companies/{id}/contracts/clients` (`api/v1/contracts_clients.py:92`) requires `require_contracts_view`. Add a slim names-only list (id, name) open to incident settings and incident editors, or widen the existing route's dependency to accept those permissions with a reduced response.
- Frontend: `incidents/ConditionControl.tsx` and the Clients affected picker switch to it.

**Chain:** on the chain if a new route is added (OpenAPI change); otherwise independent.

**Done when:** on staging, a user with Manage incident settings but not View contracts adds a "client affected is ACME Ltd" condition to a rule.