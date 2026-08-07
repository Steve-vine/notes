---
id: 01KZ4SYSZFCTNHP2AREDHXGFSY
created: 2026-08-03T21:54:55.087922Z
updated: 2026-08-07T09:40:31.498285Z
type: task
title: 'EntraID: discover application objects, flag SP-less registrations, and split ours from third-party'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 526
sprint: skxht3g
comments:
- id: 01KZ4Y9NAFANHPYXE4P6R1XTS4
  author: Steve Vine
  at: 2026-08-03T23:10:45.071233Z
  text: |-
    Built — PR #449, branch feature/ise-526-entraid-app-registrations. ADR 0076 (extends 0063). No migration, no new Graph permission — Application.Read.All already covers /applications, as you verified.

    ALL FOUR SCOPE ITEMS
    1. `appOwnerOrganizationId` in the existing $select, no extra call. Principals carry `tenant_owned`, `app_owner_tenant_id`, `has_registration`.
    2. `/applications` read and joined by appId. A registration WITH a principal enriches that principal (`has_registration: true`) — no second entity for one logical app.
    3. A registration WITHOUT one is an Observation, per your lean. It stays out of the estate exactly as ADR 0063 §3 ruled, and it is signal-shaped because it recovers on its own when a principal appears or the registration is deleted — the presence contract entities do not have. No entity_key: the whole finding is that no entity exists for it (the M365 licence-signal shape). This is the connector's first `observations` capability.
    4. UI: entity page shows Ours / Third-party plus the principal type; the SP-less findings land in Signals.

    ONE JUDGEMENT YOU LEFT OPEN
    Severity splits on credentials rather than being flat. Your own rationale is why — "the app object can still hold secrets, and creating an SP later silently re-arms it" — so medium where an idle registration still holds one, low where it is empty tidy-up. `passwordCredentials`/`keyCredentials` come from the same call and carry metadata only; Graph never returns secret values to anyone, ISE included. Confidence 0.9: the join is exact, the judgement is not.

    TRAPS, EACH WITH A TEST
    - appId join, never name — and the duplicate-name case is a real test: two registrations sharing `teamsbot-uat-callingbot-aadapp` stay two findings.
    - Stable source_key `obs/app-no-sp/{appId}` so a re-enable reinforces rather than duplicates.
    - The one that would have hurt most: if /servicePrincipals cannot be read, EVERY registration looks uninstantiated. The detector stands down entirely — 373 false findings is worse than none. Tested.
    - A failed /applications read costs the join, not the principals. Tested.

    REUSED RATHER THAN INVENTED
    A principal the tenant does not own is also marked `operated_by: external` — ADR 0073's existing statement about who runs a thing, the same one the status-page register makes. The entity page's badge lights up with no new rendering, and one concept keeps one name.

    THE HONEST LIMIT
    This makes ours-vs-third-party visible PER ENTITY, not filterable across the list. Your DoD offered the OR ("filterable in the Estate list / visible on the entity page or Signals list") so this meets it — but nobody wants to click through 1,781 principals. A real filter needs a new query parameter on /entities, which is bigger than this ticket. Say the word and it is a small follow-up.

    VERIFICATION
    Full backend suite 2183 passed; frontend 574 passed; ruff, mypy, eslint, prettier, npm run build clean. OpenAPI unchanged.

    FOR YOU on staging: the 39 should appear as Observations on the first obs run, and the counts should reconcile — tenant-owned principals + SP-less findings = the portal's 373.
assignee: steve
label: null
priority: medium
task_status: done
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
