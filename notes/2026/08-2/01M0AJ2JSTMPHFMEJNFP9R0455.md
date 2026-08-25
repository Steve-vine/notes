---
id: 01M0AJ2JSTMPHFMEJNFP9R0455
created: 2026-08-18T13:48:18.618186Z
updated: 2026-08-25T18:43:22.194345Z
type: task
title: Users browse backend — widened user mirror, PIM assignments, apps, licenses
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 254
order: 2.9375
sprint: s5gwx0s
blocked_by:
- 01M0AH2AG3TCTJ223ZXN26Q9Y0
comments:
- id: 01M0BGYB6DSW0GNMNXEWBKJ4B1
  author: Steve Vine
  at: 2026-08-18T22:47:45.613151Z
  text: |-
    Built and merged to main (PR #257, CI green; migration 0073).

    List side: directory_users gained user_type (Member/Guest, nullable = not yet observed) and created_datetime; GET /directory/users is now a paginated {items, total} inventory with q / enabled / user_type filters — still the mover/leaver picker's feed.

    Detail side kept the split strategy: GET /directory/users/{id} assembles the modal live rather than mirroring the heavy set. Groups come free from the mirror rows; active + eligible PIM assignments ride the COM-252 RoleManagement.Read.Directory grant (eligible is P2 — a refusal surfaces as that panel's stated reason); applications via appRoleAssignments ride the already-granted Directory.Read.All (the least-privilege answer to the grant question — no Application.Read.All, no scripts/health-check change needed); licenses map to SKU part numbers via subscribedSkus. Cache decision (as the task asked to settle in the PR): in-process per-user cache of the assembled panels, 5-minute TTL; role-definition and SKU maps cached process-wide for an hour. Every panel degrades independently and visibly ({available, reason, items}) — never silently empty — and a vanished account short-circuits with an explicit gone state and zero Graph calls.

    The response shape leaves room for an azure_role_assignments panel later without a breaking change (COM-256 candidate, as deferred).
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
Foundation for the **View Users** screen, the user-side twin of COM-252 — but with a split strategy, because the modal's detail set is too heavy to mirror for every user nightly:

* **List from the mirror**: widen `directory_users` with what the list and filters need — `account_enabled`, `user_type` (Member / Guest), `created_datetime` (UPN/display name already mirrored). `GET /api/v1/directory/users` — paginated; filters: `q` free-text on display name (trigram/ILIKE), `enabled`, `user_type`. Read-gated `require_access_read`.
* **Detail on demand**: `GET /directory/users/{id}` assembles the modal live from Graph with a short cache (minutes, per-user) rather than mirroring — decide the cache shape in the PR:
  * **Groups** — direct memberships from the existing mirror rows (free).
  * **Active + Eligible assignments** — PIM directory-role schedule instances (`roleManagement/directory/roleAssignmentScheduleInstances` / `roleEligibilityScheduleInstances` by principal, role-definition names resolved). Rides the `RoleManagement.Read.Directory` grant COM-252 adds; eligible assignments are an Entra P2 feature — degrade visibly if the API refuses.
  * **Applications** — enterprise-app assignments via `users/{id}/appRoleAssignments` (resource display names resolved). Check the read grant: needs `Directory.Read.All` or `Application.Read.All` on the Access registration — add whichever the ADR-0045 least-privilege review prefers, update `scripts/` + the grant health check.
  * **Licenses** — `assignedLicenses` mapped to friendly SKU names via `subscribedSkus` (cache the SKU map process-wide; the GUIDs are meaningless raw).

**Deferred (2026-08-18, Steve): Azure role assignments** — Azure RBAC lives on the ARM plane, a genuinely new credential surface; parked as the COM-256 candidate with the design notes preserved. The detail response shape should leave room for an `azure_role_assignments` panel later without a breaking change.

Refs: ADR 0045, 0044 (verify-the-grant); COM-252 (grant + health-check work this stacks on), `core/graph.py`.