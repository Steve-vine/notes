---
id: 01M0AV6XJBK6VWTRTQ7R9ZSZA4
created: 2026-08-18T16:27:57.899657Z
updated: 2026-08-25T18:43:00.16192Z
type: task
title: Mirror-based role resolution, role-gated JIT sign-in, SCIM retirement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 266
sprint: s5thbzy
blocked_by:
- 01M0AV4W305B8KD7M3G4YN3XJ8
comments:
- id: 01M0B048S9RNZ8Y9G2T5H5GX3E
  author: Steve Vine
  at: 2026-08-18T17:53:53.961183Z
  text: |-
    Merged to main (PR #251, full suite green — one flaky run was a zot 502 on the ryuk image, re-run passed). What shipped:

    - **Resolution from the mirror**: `core/role_resolution.py` derives roles via `users.entra_object_id` → `directory_group_members` → mappings; `recompute_all_entra_roles` is the leaver pass — every `sync_directory` run recomputes all Entra users and revokes the sessions of anyone whose derived roles drop to empty.
    - **Role-gated JIT at sign-in**: oid match → defensive refresh → **deny if roles are empty** (the stripping persists even when the sign-in is refused); email-link path is role-gated; otherwise JIT-create — identity preferred from the mirror record (mail/UPN/display name) over token claims, no password, and the joiner event lands in the activity log attributed to the account itself.
    - **Security groups only** are mappable (422 for m365/dynamic when the mirror knows the group); `group_synced`, display-name auto-fill, blast radius and the user-sources provenance all re-source from the mirror.
    - **SCIM fully retired**: `/scim/v2`, `scim_groups`/members, the bearer token, its admin endpoints and Integrations panel removed; migration 0070 drops the tables/columns (0068 untouched); `scripts/entra/sso-scim.md` → `scripts/entra/sso.md` (OIDC-only + prerequisites, with the "Create your own application" Entra quirk noted for posterity).
    - **Prerequisites on the settings read**: `entra_connection_configured` + `mirror_last_completed_at` (COM-267 renders the warnings).
    - Tests: `test_mirror_provisioning.py` (JIT happy path incl. audit attribution + mirror identity, zero-role deny with no account, real sync run against a stubbed emptied tenant revoking a leaver's sessions); `test_sso_mappings.py` reworked to mirror seeding; sign-in drift test now asserts strip-and-deny.

    Your Bob/Bill flow is live once this deploys: map `compass-admin` → Admin and `compass-vendor-management` → Vendor Manager + Vendor Assessor + Vendor Owner in Admin ▸ Users, and membership does the rest.
assignee: steve
company: null
label:
- feature
priority: high
task_status: done
---
The backend rewire for the ADR 0046 amendment (COM-265). The mapping table and OIDC flow survive unchanged; the membership source and the gate change.

* **Resolution** (`core/role_resolution.py`): derive roles from the **directory mirror** — `users.entra_object_id` → mirror memberships → `sso_group_role_mappings.group_object_id`; drop the `scim_groups` join. `users_mapped_to_group` / `user-sources` provenance re-source the same way.
* **Sign-in** (`api/v1/auth_sso.py`): no Compass user for the oid → look up the mirror's directory user, derive roles; **≥1 role → JIT-create** (`auth_provider="entra"`, no password, derived roles, email/name from claims) and mint the session; zero roles → deny (`sso_error=unprovisioned`). Existing Entra users: defensive refresh from the mirror, and **deny when derived roles are empty** — no role-less sessions.
* **Leaver hygiene** (`tasks/directory_sync.py`): after each sync pass, recompute persisted roles for all Entra users; revoke sessions of users whose roles drop to empty. Worker convention: actorless, silent in the activity log (mapping edits remain the audited policy surface).
* **SCIM retirement**: remove `api/scim.py`, the scim-token endpoints, and the SCIM fields from `SsoSettingsOut`; migration 0070 drops `scim_groups`, `scim_group_members` and the two `sso_settings` SCIM columns (new migration — 0068 stays untouched, append-only). Remove `scripts/entra/sso-scim.md`'s provisioning section (rewrite for the mirror prerequisite + note the app must be created via "Create your own application" only if provisioning were ever wanted; OIDC needs a plain registration). Includes the mechanical frontend edits (drop the SCIM panel from `IntegrationsSection.tsx`) so the tree stays green — the UX pass is COM-267.
* **Prerequisite surfacing**: `/auth/sso/status` (or the settings read) reports whether the Entra access connection + mirror are available, so the login/admin surfaces can warn rather than fail obscurely.
* **Tests**: rewrite `test_scim.py` → `test_mirror_provisioning.py` — JIT happy path (mirror member of mapped group), zero-role deny (member of nothing / unmapped groups), existing-user role refresh + empty-roles deny, sync-pass recompute + session revocation, provenance endpoint from mirror.

Refs: ADR 0046 amendment, ADR 0045 §3; COM-249 (retired), COM-250, COM-265.