---
id: 01M0AH2AG3TCTJ223ZXN26Q9Y0
created: 2026-08-18T13:30:41.539427Z
updated: 2026-08-18T21:29:11.391629Z
type: task
title: Groups browse backend — widen the mirror to all groups, capture attributes, detect directory roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 252
sprint: s5gwx0s
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Foundation for the **View Groups** screen. The COM-237 mirror deliberately synced security groups only, with a minimal attribute set — browsing needs the whole picture.

* **Widen the sync scope to all group objects** — security, Microsoft 365, distribution, mail-enabled security. Non-security groups are **browse-only inventory**: the role matrix, JML and recert stay scoped to managed security groups, and the COM-244 out-of-band detection keeps its managed-groups-only guard — widening the mirror must not widen the validation-queue noise. State this in the task's PR, it's the trap.
* **New attributes on `directory_groups`** (migration — coordinate numbering: the SSO sprint is claiming migration numbers concurrently in another session): `description`, `mail`, `created_datetime`, raw `group_types` + `security_enabled`/`mail_enabled` plus derived **`group_type`** (Security / Microsoft 365 / Distribution / Mail-enabled security), **`membership_type`** (Assigned / Dynamic — from `groupTypes: DynamicMembership`; keep `membershipRule` for display), **`source`** (Cloud / Synced from on-premises — `onPremisesSyncEnabled`), `is_assignable_to_role`. Owners into a `directory_group_owners` mirror table; nested membership (group **memberOf** group) captured alongside the existing member rows.
* **Directory-role detection** — the headline: flag groups that grant Entra directory roles. `isAssignableToRole` marks the capability; resolve the **actual roles** via the group's directory-role assignments (`roleManagement/directory/roleAssignments` by principal, unified role definitions for display names) and store them (group → role display names). Needs **`RoleManagement.Read.Directory`** on the Access app registration — update the `scripts/` Entra setup doc **and** the ADR 0044-style health check so the grant is verified, not assumed; degrade visibly (roles column "unknown — grant missing"), never silently.
* **API**: `GET /api/v1/directory/groups` — paginated, filters: `q` (name, trigram/ILIKE), `group_type`, `membership_type`, `source`, `grants_directory_roles`; `GET /directory/groups/{id}` detail with description, object id, created, owners, members (paginated), memberOf, directory roles. Read-gated `require_access_read`; mirrors stay un-audited (ADR 0045 convention — they're inventory, not governance entities).

Refs: ADR 0045; COM-237 (sync task being widened), COM-244 (the scope guard to preserve), `core/graph.py` paged-GET helper.