---
id: 01KZ4SYSZFCTNHP2AREDHXGFSY
created: 2026-08-03T21:54:55.087922Z
updated: 2026-08-03T22:32:44.126149Z
type: task
title: 'EntraID: discover application objects, flag SP-less registrations, and split ours from third-party'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 526
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
---
From functional testing 2026-08-03: Steve counted 373 app registrations in the portal while ISE showed 1,781 `app-registration` entities. Root cause is not a bug — the connector discovers `/servicePrincipals` only (`_discover_service_principals`, `entraid.py:545`, per ADR 0063 §3: the SP is the tenant-local object that holds credentials and app-role assignments). But the investigation exposed two real gaps and a legibility problem.

## Live-verified numbers (read-only Graph probe, 2026-08-03)

- 373 application objects (`/applications`) — matches the portal
- 1,781 service principals — matches ISE's estate exactly
- 334 SPs tenant-owned (`appOwnerOrganizationId == tenant`) + **39 registrations with NO SP** = 373 ✓
- 1,447 SPs are third-party/Microsoft/managed-identity

## Gap 1 — 39 of the tenant's own registrations are invisible to ISE

An app registration with no home-tenant SP has never been instantiated and cannot sign in to the tenant — but the app object can still hold secrets, and creating an SP later silently re-arms it. The live 39 are almost all provisioning residue, which is exactly the point — nobody knew:

- ~12 `teamsbot-{uat,prd}-*-aadapp` with literal duplicates (`teamsbot-uat-callingbot-aadapp` ×3, `-storage-` ×3, `-notification-` ×3) — a script re-run leaving orphans
- ~10 Commvault `CVAzureHypervisorApp<timestamp>` — same pattern
- Vendor leftovers (Jamf ×3, Mimecast ×2, Veeam ×2), a CrowdStrike **trial**, Copilot Studio agents, a "Dummy Consent Test App"

These are latent misconfigurations the estate should surface — the single-pane-of-glass case.

## Gap 2 — no ours-vs-third-party distinction

1,583 `Application`-type SPs mix the tenant's own 334 with ~1,250 consented SaaS/Microsoft apps, indistinguishably. The connector's `$select` doesn't fetch `appOwnerOrganizationId`, which is the one field that answers it.

## Scope

1. **Fetch `appOwnerOrganizationId`** in the SP `$select`; store `tenant_owned: bool` in attributes. Cheap, no new call.
2. **Read `/applications`** (`$select=id,appId,displayName`) alongside SPs. Join to SPs by `appId` in-connector:
   - Registration **with** an SP → enrich the existing SP entity (e.g. `has_registration: true`) — do NOT mint a second entity for the same logical app.
   - Registration **without** an SP → this is the finding. Decide in plan mode: an entity with a distinguishing attribute (`sp_exists: false`), or better, an **Observation signal** per SP-less registration — "registered but never instantiated" is signal-shaped (it can recover when an SP appears or the registration is deleted), and signals are already the surface operators triage. Lean signal.
3. **UI**: whatever form lands must be visible — filterable in the Estate list / visible on the entity page or Signals list. Consider surfacing `sp_type` + ours/third-party as secondary labels (same pattern as `azure_service` for App Services vs Functions) — this is also the answer to the type-name confusion that started this investigation.
4. **Scopes**: `Application.Read.All` already covers `/applications` — no new grant (verified live; the probe used the existing credential).

## Traps

- **appId join, not object id** — the application object and its SP have different object ids; `appId` is the shared key.
- **Duplicate displayNames are real** (three registrations named `teamsbot-uat-callingbot-aadapp` with distinct appIds) — anything keyed or deduped by name will fold them; key by appId/object id everywhere.
- The estate wipe keeps signals out but a re-enable re-fires them — make the Observation's `source_key` stable (`app-no-sp/{appId}`) so re-detection reinforces rather than duplicates.
- ISE's own probe scripts live in the session scratchpad (`entra_app_sp_probe.py`) — the numbers above are reproducible.

## Definition of done

An operator can see, in the app, which of the tenant's own app registrations have no service principal (the 39 today), and can tell ISE-discovered identity applications apart: ours vs third-party, and SP type.
