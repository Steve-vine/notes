---
id: 01KYVNYVDB165MQPH6Q0RABDCE
created: 2026-07-31T08:51:52.363951Z
updated: 2026-08-05T12:34:31.240767Z
type: task
title: EntraID surface — tenant summary card + live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 393
order: 1.03125
sprint: setdxf2
blocked_by:
- 01KYVNXV67JWEJ5P3SP2893CTS
- 01KYVNY07N3X03ESHJG5C6V9CZ
- 01KYVNYDJEHB3N1DW6V3N5VVGY
- 01KYVNYNC6J0GHPF0F3XH8DZKQ
comments:
- id: 01KYVTQXACZEPWS1XX3Y67KC72
  author: Steve Vine
  at: 2026-07-31T10:15:27.820399Z
  text: |-
    Built and pushed — PR #370 (feature/ise-393-entraid-surface, top of the stacked chain #364-#370).

    Delivered: entraid-summary endpoint (ISE tables only — tenant id off the alias prefix, per-type counts, at-risk users, firing alerts) + EntraIDSummary schema + api-types regen; EntraTenantCard on System detail with the honest-absence copy; ENTITY_TYPES mirrors (EstatePage, TagDictionaryCard) + graph icons for the four identity types; integration-connectors.md row → Built. No nav entry (Cloudflare precedent); EntityDetailPage group branch untouched by design.

    Tests: real-Postgres summary rollup test; frontend build/format/lint/vitest green.

    REMAINING for this task (needs you): the live smoke on staging — register the read + write SPs (permission sets in ADR 0063 §2 / 0064 §5, admin-consented), add the tenant, sync, verify estate/alert/evidence, run one full T3 propose→approve→execute, and try a role-assignable-group membership write to confirm Graph 403s (result to be recorded in ADR 0064). Task stays in Review until the smoke passes.
- id: 01KYVXFQM8W8S0QF1X4Q9EWBET
  author: Steve Vine
  at: 2026-07-31T11:03:25.576699Z
  text: 'Live smoke passed (Steve, 2026-07-31) — SPs registered, sync + T3 round-trip verified on staging. RELEASED to main 2026-07-31: PRs #364-#370 merged in order, main fa73375, staging reset to main, feature branches deleted.'
assignee: steve
priority: medium
task_status: done
---
The DoD slice. Backend: `get_entraid_summary` in api/v1/systems.py (get_cloudflare_summary pattern — reads ONLY ISE tables: tenant id off alias `entra:` prefix, entity counts per new type, at-risk-user count, firing alerts) + response schema; **api-types regen** (dump_openapi + npm run generate:api — the sprint's only API change lands here). Frontend: `EntraSummaryCard` in SystemDetailPage.tsx gated `connector_type === 'entraid'`; ENTITY_TYPES mirrors (EstatePage.tsx, TagDictionaryCard.tsx); TYPE_ICON entries in EntityGraphView.tsx (user/identity-group/application/policy); no nav entry (Cloudflare precedent); NO change to the EntityDetailPage type==='group' branch (that's the point of `identity-group`). Docs: integration-connectors.md EntraID row → Built, ADR 0063/0064. **Live smoke with Steve on staging**: add tenant, sync (entities on Estate with icons/labels), risky-user alert fires, evidence pull, one full T3 propose→approve→execute through ActionsPanel, and verify Graph 403s a role-assignable-group membership write (record result in ADR 0064). Prereq: Steve registers read + write SPs with the ADR permission sets, admin-consented.