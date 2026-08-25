---
id: 01M0AFQBJ0PZY5RBQX5H9W60T1
created: 2026-08-18T13:07:13.600725Z
updated: 2026-08-25T18:43:03.020129Z
type: task
title: SSO & SCIM frontend — login, admin panels, Users section provenance
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 251
sprint: s5thbzy
blocked_by:
- 01M0AFP85ZQ60MHNYSA68EW8KV
- 01M0AFQ2069BENM00JXHE5121S
comments:
- id: 01M0AN2MZTAPZR6XTTVA913F8S
  author: Steve Vine
  at: 2026-08-18T14:40:46.586753Z
  text: |-
    Merged to main (PR #249, full suite green — one fix-up commit for a Prettier check miss). What shipped:

    - **Login page**: "Sign in with Microsoft" as the primary action when SSO is enabled (public `/auth/sso/status`); the password form sits behind a "Sign in with a local account" link — break-glass present but not competing; a "Sign in with Microsoft instead" link leads back. `?sso_error=<code>` renders safe wording only — deny-unprovisioned reads "Your Microsoft account hasn't been assigned to Compass yet — ask your administrator to assign you to the Compass app in Entra ID." SSO disabled → exactly today's form.
    - **Admin ▸ Integrations ▸ "Entra ID sign-in & provisioning"** (below M365/Entra access, same panel model): credentials form with masked write-only secret + inline test; **enable switch separate from configured** ("Configured — sign-in off" badge while staged); redirect-URI field for copy-paste; SCIM **Tenant URL + token generate/rotate/revoke with the view-once orange reveal + Copy**; provisioning heartbeat (last SCIM activity, Entra-user/group counts).
    - **Users section**: new **Source** column (Local / Entra / System — the synthetic provisioning actor shows as System), `entra_object_id` under the email; Entra users get a **read-only derived-roles display with "via *group*" tooltips** and an orange **"No mapped roles"** badge when unmapped; local users keep the editable MultiSelect. The **group→role Mappings panel** sits directly below the users table (zero clicks from the list): blast-radius counts, "Not syncing" warnings, inline role editing, and the **privileged-mapping confirmation modal** driven by the API's `confirmation_required` refusal.
    - Backend enablers: `entra_object_id` on `UserOut`, admin `GET /sso/group-role-mappings/user-sources` provenance endpoint.

    That completes all five sprint tasks — deploying to staging next for smoke test.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The user-facing half of the sprint, three surfaces:

* **Login page**: "Sign in with Microsoft" as the primary action when SSO is enabled; the password form moves behind a secondary "Sign in with a local account" link (break-glass — present but not competing). Clean error states for the deny-unprovisioned case ("your account hasn't been assigned — contact your admin") and for OIDC failures (surfacing the safe error, not the raw exchange). SSO disabled → today's form unchanged.
* **Admin ▸ Integrations — "Entra ID sign-in & provisioning" panel** (beside M365 / Email / Entra access; `IntegrationsSection.tsx` model): OIDC credentials form (tenant/client/secret, masked, test-connection inline), redirect-URI display for copy-paste into the app registration, the **SCIM base URL + bearer-token management** (generate/rotate with view-once reveal — reuse the one-time-secret affordance from the Access sprint), and provisioning status (last SCIM activity, user/group counts).
* **Users section** (`admin/UsersSection.tsx`): provenance column/badge (Local vs Entra), active/deactivated state from SCIM, `entra_object_id` on detail; for Entra users the role editor becomes a read-only derived-roles display with "via *group*" provenance chips linking to the Mappings panel; "no mapped roles" surfaced as a warning state. Local users keep today's role editing. The **Mappings panel** itself (from COM-250) lands wherever this task decides it reads best — keep it one click from the Users list.

House patterns as ever: TanStack Query, Mantine forms, central MutationCache toasts, `StatusPill`, skeletons/empty states (ADR 0022). Refs: ADR 0046, 0026, 0022, 0017.