---
id: 01M0AJ5BCRBN5FAWNAMPMS5920
created: 2026-08-18T13:49:49.336894Z
updated: 2026-09-01T13:55:51.383504Z
type: task
title: 'Candidate: Azure role assignments in View Users — the ARM plane'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 256
assignee: steve
label:
- feature
- follow_up
priority: low
task_status: cancelled
---
**Candidate — deferred from COM-254/COM-255 at Steve's call (2026-08-18); not yet committed.**

Add an **Azure role assignments** panel to the View Users detail modal (role + scope, e.g. *Reader on subscription X*). Deferred because it opens a genuinely new plane, not because it's hard to render.

Design notes preserved from the COM-254 planning:

* Azure RBAC lives on **ARM** (`management.azure.com`), not Microsoft Graph — a second token audience acquired with the same client credentials of the Access app registration.
* Read path: enumerate accessible subscriptions → `Microsoft.Authorization/roleAssignments` filtered `assignedTo` the user → resolve role-definition names and scope display names.
* Prerequisite: a **Reader role assignment for the app's service principal on each subscription in scope** — an Azure-side operation to document in `scripts/` and verify in the ADR 0044-style grant health check. Absent access renders as "not connected to Azure subscriptions", never a silently empty panel.
* Implementation discipline: ARM calls live beside the Graph client with the same bounds (explicit timeouts, `http_transport` test hook) — one client dialect, two audiences. COM-254's detail response was shaped to accept an `azure_role_assignments` panel without a breaking change.

Also worth deciding when picked up: whether group-based Azure role assignments (roles granted via the View Groups inventory's groups) should surface on the group modal too.