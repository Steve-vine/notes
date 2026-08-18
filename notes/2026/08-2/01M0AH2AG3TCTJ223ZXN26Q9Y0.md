---
id: 01M0AH2AG3TCTJ223ZXN26Q9Y0
created: 2026-08-18T13:30:41.539427Z
updated: 2026-08-18T22:14:42.622808Z
type: task
title: Groups browse backend — widen the mirror to all groups, capture attributes, detect directory roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 252
sprint: s5gwx0s
comments:
- id: 01M0BF1T1DT5RA7G9QYPJ0HY1F
  author: Steve Vine
  at: 2026-08-18T22:14:41.964911Z
  text: |-
    Built and merged to main (PR #256, CI green; migration 0072).

    The mirror now syncs every group object, with kind replaced by the derived trio — group_type (Security / Microsoft 365 / Distribution / Mail-enabled security), membership_type (Assigned/Dynamic, membershipRule kept for display), source (Cloud / Synced from on-premises) — plus the raw Graph facts, mail and createdDateTime. Owners land in directory_group_owners; group-in-group nesting in directory_group_group_members. Directory-role detection resolves the actual role names via roleManagement assignments + definitions and stores them per group; the RoleManagement.Read.Directory grant was added to REQUIRED_ENTRA_APP_ROLES (health check verifies it) and to scripts/entra/README.md (portal + az CLI ids). Without the grant the roles column reads null = "unknown — grant missing", never a silent empty list.

    The trap, handled: governance did not widen. The matrix, JML writes, recert and SSO mappings are now gated on DirectoryGroup.governable (plain assigned security) — which also correctly refuses mail-enabled security groups Graph could never write anyway; out-of-band membership detection keeps its managed-groups-only guard; and creation detection now checks the tenant-side createdDateTime, so old groups that merely became visible on this deploy are not flagged as out-of-band creations.

    API: GET /directory/groups is the paginated inventory (q / group_type / membership_type / source / grants_directory_roles filters; mappable=true is the picker feed), plus /groups/{id} detail (owners, nesting, roles — vanished groups still resolve) and /groups/{id}/members paginated. schema.d.ts regenerated; the picker hook consumes the new envelope.

    One follow-up worth knowing: after deploy, the Entra card's health check will flag the missing RoleManagement.Read.Directory consent until it's granted in the portal (README has the id).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Foundation for the **View Groups** screen. The COM-237 mirror deliberately synced security groups only, with a minimal attribute set — browsing needs the whole picture.

* **Widen the sync scope to all group objects** — security, Microsoft 365, distribution, mail-enabled security. Non-security groups are **browse-only inventory**: the role matrix, JML and recert stay scoped to managed security groups, and the COM-244 out-of-band detection keeps its managed-groups-only guard — widening the mirror must not widen the validation-queue noise. State this in the task's PR, it's the trap.
* **New attributes on `directory_groups`** (migration — coordinate numbering: the SSO sprint is claiming migration numbers concurrently in another session): `description`, `mail`, `created_datetime`, raw `group_types` + `security_enabled`/`mail_enabled` plus derived **`group_type`** (Security / Microsoft 365 / Distribution / Mail-enabled security), **`membership_type`** (Assigned / Dynamic — from `groupTypes: DynamicMembership`; keep `membershipRule` for display), **`source`** (Cloud / Synced from on-premises — `onPremisesSyncEnabled`), `is_assignable_to_role`. Owners into a `directory_group_owners` mirror table; nested membership (group **memberOf** group) captured alongside the existing member rows.
* **Directory-role detection** — the headline: flag groups that grant Entra directory roles. `isAssignableToRole` marks the capability; resolve the **actual roles** via the group's directory-role assignments (`roleManagement/directory/roleAssignments` by principal, unified role definitions for display names) and store them (group → role display names). Needs **`RoleManagement.Read.Directory`** on the Access app registration — update the `scripts/` Entra setup doc **and** the ADR 0044-style health check so the grant is verified, not assumed; degrade visibly (roles column "unknown — grant missing"), never silently.
* **API**: `GET /api/v1/directory/groups` — paginated, filters: `q` (name, trigram/ILIKE), `group_type`, `membership_type`, `source`, `grants_directory_roles`; `GET /directory/groups/{id}` detail with description, object id, created, owners, members (paginated), memberOf, directory roles. Read-gated `require_access_read`; mirrors stay un-audited (ADR 0045 convention — they're inventory, not governance entities).

Refs: ADR 0045; COM-237 (sync task being widened), COM-244 (the scope guard to preserve), `core/graph.py` paged-GET helper.