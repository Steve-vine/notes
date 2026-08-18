---
id: 01M0AJ2JSTMPHFMEJNFP9R0455
created: 2026-08-18T13:48:18.618186Z
updated: 2026-08-18T13:48:18.618186Z
type: task
title: Users browse backend — widened user mirror, PIM assignments, apps, licenses, Azure RBAC
task_status: todo
label: feature
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 254
---
Foundation for the **View Users** screen, the user-side twin of COM-252 — but with a split strategy, because the modal's detail set is too heavy to mirror for every user nightly:

* **List from the mirror**: widen `directory_users` with what the list and filters need — `account_enabled`, `user_type` (Member / Guest), `created_datetime` (UPN/display name already mirrored). `GET /api/v1/directory/users` — paginated; filters: `q` free-text on display name (trigram/ILIKE), `enabled`, `user_type`. Read-gated `require_access_read`.
* **Detail on demand**: `GET /directory/users/{id}` assembles the modal live from Graph/ARM with a short cache (minutes, per-user) rather than mirroring — decide the cache shape in the PR:
  * **Groups** — direct memberships from the existing mirror rows (free).
  * **Active + Eligible assignments** — PIM directory-role schedule instances (`roleManagement/directory/roleAssignmentScheduleInstances` / `roleEligibilityScheduleInstances` by principal, role-definition names resolved). Rides the `RoleManagement.Read.Directory` grant COM-252 adds; eligible assignments are an Entra P2 feature — degrade visibly if the API refuses.
  * **Applications** — enterprise-app assignments via `users/{id}/appRoleAssignments` (resource display names resolved). Check the read grant: needs `Directory.Read.All` or `Application.Read.All` on the Access registration — add whichever the ADR-0045 least-privilege review prefers, update `scripts/` + the grant health check.
  * **Licenses** — `assignedLicenses` mapped to friendly SKU names via `subscribedSkus` (cache the SKU map process-wide; the GUIDs are meaningless raw).
  * **Azure role assignments** — **a new plane**: Azure RBAC via ARM (`management.azure.com`), not Graph. Token against the ARM audience with the same client credentials; enumerate accessible subscriptions, `Microsoft.Authorization/roleAssignments` filtered `assignedTo`, role-definition + scope names resolved. Requires a **Reader role assignment for the app's service principal on each subscription** — document in `scripts/`, verify in the health check, and show "not connected to Azure subscriptions" in the modal when absent rather than an empty list that reads as "no access". Keep ARM calls inside `core/graph.py`'s bounds discipline (explicit timeouts, `http_transport` hook) even though it's a second base URL — one client dialect, two audiences.

Refs: ADR 0045, 0044 (verify-the-grant); COM-252 (grant + health-check work this stacks on), `core/graph.py`.