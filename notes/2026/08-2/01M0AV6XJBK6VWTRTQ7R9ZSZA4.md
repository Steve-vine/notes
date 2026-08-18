---
id: 01M0AV6XJBK6VWTRTQ7R9ZSZA4
created: 2026-08-18T16:27:57.899657Z
updated: 2026-08-18T16:30:33.310331Z
type: task
title: Mirror-based role resolution, role-gated JIT sign-in, SCIM retirement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 266
sprint: s5thbzy
blocked_by:
- 01M0AV4W305B8KD7M3G4YN3XJ8
assignee: steve
label:
- feature
priority: high
task_status: active
---
The backend rewire for the ADR 0046 amendment (COM-265). The mapping table and OIDC flow survive unchanged; the membership source and the gate change.

* **Resolution** (`core/role_resolution.py`): derive roles from the **directory mirror** — `users.entra_object_id` → mirror memberships → `sso_group_role_mappings.group_object_id`; drop the `scim_groups` join. `users_mapped_to_group` / `user-sources` provenance re-source the same way.
* **Sign-in** (`api/v1/auth_sso.py`): no Compass user for the oid → look up the mirror's directory user, derive roles; **≥1 role → JIT-create** (`auth_provider="entra"`, no password, derived roles, email/name from claims) and mint the session; zero roles → deny (`sso_error=unprovisioned`). Existing Entra users: defensive refresh from the mirror, and **deny when derived roles are empty** — no role-less sessions.
* **Leaver hygiene** (`tasks/directory_sync.py`): after each sync pass, recompute persisted roles for all Entra users; revoke sessions of users whose roles drop to empty. Worker convention: actorless, silent in the activity log (mapping edits remain the audited policy surface).
* **SCIM retirement**: remove `api/scim.py`, the scim-token endpoints, and the SCIM fields from `SsoSettingsOut`; migration 0070 drops `scim_groups`, `scim_group_members` and the two `sso_settings` SCIM columns (new migration — 0068 stays untouched, append-only). Remove `scripts/entra/sso-scim.md`'s provisioning section (rewrite for the mirror prerequisite + note the app must be created via "Create your own application" only if provisioning were ever wanted; OIDC needs a plain registration). Includes the mechanical frontend edits (drop the SCIM panel from `IntegrationsSection.tsx`) so the tree stays green — the UX pass is COM-267.
* **Prerequisite surfacing**: `/auth/sso/status` (or the settings read) reports whether the Entra access connection + mirror are available, so the login/admin surfaces can warn rather than fail obscurely.
* **Tests**: rewrite `test_scim.py` → `test_mirror_provisioning.py` — JIT happy path (mirror member of mapped group), zero-role deny (member of nothing / unmapped groups), existing-user role refresh + empty-roles deny, sync-pass recompute + session revocation, provenance endpoint from mirror.

Refs: ADR 0046 amendment, ADR 0045 §3; COM-249 (retired), COM-250, COM-265.