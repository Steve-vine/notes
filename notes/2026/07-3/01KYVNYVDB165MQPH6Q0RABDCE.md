---
id: 01KYVNYVDB165MQPH6Q0RABDCE
created: 2026-07-31T08:51:52.363951Z
updated: 2026-07-31T08:51:52.363951Z
type: task
title: EntraID surface — tenant summary card + live smoke
assignee: steve
label: feature
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 393
---
The DoD slice. Backend: `get_entraid_summary` in api/v1/systems.py (get_cloudflare_summary pattern — reads ONLY ISE tables: tenant id off alias `entra:` prefix, entity counts per new type, at-risk-user count, firing alerts) + response schema; **api-types regen** (dump_openapi + npm run generate:api — the sprint's only API change lands here). Frontend: `EntraSummaryCard` in SystemDetailPage.tsx gated `connector_type === 'entraid'`; ENTITY_TYPES mirrors (EstatePage.tsx, TagDictionaryCard.tsx); TYPE_ICON entries in EntityGraphView.tsx (user/identity-group/application/policy); no nav entry (Cloudflare precedent); NO change to the EntityDetailPage type==='group' branch (that's the point of `identity-group`). Docs: integration-connectors.md EntraID row → Built, ADR 0063/0064. **Live smoke with Steve on staging**: add tenant, sync (entities on Estate with icons/labels), risky-user alert fires, evidence pull, one full T3 propose→approve→execute through ActionsPanel, and verify Graph 403s a role-assignable-group membership write (record result in ADR 0064). Prereq: Steve registers read + write SPs with the ADR permission sets, admin-consented.