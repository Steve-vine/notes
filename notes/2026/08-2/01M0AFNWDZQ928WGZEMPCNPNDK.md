---
id: 01M0AFNWDZQ928WGZEMPCNPNDK
created: 2026-08-18T13:06:25.343674Z
updated: 2026-08-18T13:11:38.965596Z
type: task
title: SSO & SCIM inception + ADR 0046
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 247
sprint: s5thbzy
assignee: steve
label:
- brief
priority: high
task_status: active
---
The auth-domain ADR that realises ADR 0007's "SSO-ready" promise and supersedes the COM-72 candidate. Settles:

* **Vocabulary.** Third population of "users" now in play: Compass app users (ADR 0007), the ADR 0045 directory mirror's *directory users*, and now **SCIM-provisioned app users** (a subset of the first, sourced from Entra). SCIM provisions app users; the mirror governs tenant objects — same tenant, two pipelines, never conflated in schema or UI.
* **Sign-in flow.** OIDC authorization-code + PKCE against a new dedicated Enterprise App (delegated `openid profile email`); ID-token validation via the tenant JWKS (`state` + `nonce`, issuer/audience checks); on success, resolve to an existing user by `entra_object_id` (fallback UPN→email match on first link), stamp `auth_provider="entra"`, and mint the same Redis session as today. **Deny unprovisioned** — no JIT creation; the failure screen explains the Enterprise-App-assignment route.
* **Provisioning.** Compass implements a **SCIM 2.0 server** consumed by Entra's provisioning service, secured by a rotatable bearer token. Entra assignment = the access gate; `active=false` / unassignment = deactivation, never deletion (ActorMixin FKs and the audit trail outlive people).
* **Roles.** Entra group membership drives Compass roles **through a Compass-defined, audited mapping table** (e.g. `compass-vendor` → vendor_manager + vendor_owner); effective roles = union across synced groups. Decide precedence details here: unmapped-group users (no roles vs default viewer — lean no roles + visible "unmapped" state), whether manual per-user roles survive for Entra users (lean: derived-only for Entra users, manual for local), and recompute triggers (SCIM group change + defensive refresh at sign-in).
* **Break-glass.** Local password login survives only for accounts flagged `local`; SCIM users never hold a password (null hash, reset flow refuses them). Document the lockout-recovery runbook (Entra down / app reg broken → local admin path).
* **App registration.** One new Enterprise App carries both OIDC and SCIM (ADR 0045's one-registration-per-capability rule; the app-only Access Control registration is not widened). Redirect URIs per environment; secret in the settings singleton via `core/secretbox`.

Decisions settled at planning (2026-08-18) are on the sprint description — carry them in, don't re-open. Refs: ADR 0007, 0026, 0045; COM-72.