---
id: 01KYT7EFWTQRHT7K12RFEB0J69
created: 2026-07-30T19:19:01.786674Z
updated: 2026-08-05T12:02:48.399338Z
type: task
title: Azure actions foundation — ADR 0061, actions capability, ARM LRO helper
project: 01KX671DATY39VW6GWK3M2T3DN
number: 377
sprint: sh8mf3h
comments:
- id: 01KYT8F09W5GAEYZRBZSP6WT2S
  author: Steve Vine
  at: 2026-07-30T19:36:47.163982Z
  text: |-
    Built on feature/ise-377-azure-actions-foundation, PR #352 → main; merged to staging (0742294).

    - ADR 0061 written (docs/decisions/0061-azure-actions.md): second service principal on write_credential_ref (ADR 0051 §7 pattern, credential_spec stays Reader-only), K8s-parity tiers (restart/start VM, restart App Service, set tag T1; deallocate VM, PG flexible-server restart T2), targets = full ARM resource ids (lower-cased, matching the ADR 0059 native-key normalisation) for the protected-targets deny-list, explicitly no RBAC actions (§4, self-escalation refusal), Azure SQL out of v1 (no ARM restart primitive; failover deferred), minimum write RBAC recorded as a custom role definition.
    - ArmClient.run_action (ADR 0061 §5): POSTs the ARM action, then follows Azure-AsyncOperation (status document) or Location (202-while-running) to Succeeded/Failed/Canceled inside a bounded 300s window honouring Retry-After. Timeout → failed change carrying the operation URL. New ArmOperation outcome type; _sleep seam so tests poll instantly.
    - AzureConnector: capabilities now {alerts, entities, evidence, actions}; _execute is the _act_{name} dispatch with httpx/AzureApiError containment → failed ActionResult (never raises). Catalogue deliberately still empty — operations land with their handlers in ISE-378/379.
    - No executor change needed: ctx.config merge shipped in ISE-373; ARM is global (no regions).
    - Brief connector matrix: Azure row → Built (Sprints 34+36, ADRs 0059/0061) — it was stale at "Deferred" (the read-only sprint missed it).

    Gates: ruff + format + mypy strict clean; full backend suite 1606 passed locally. PR CI running.
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation for the Azure write path (follow-on to ADR 0059; mirrors the AWS pattern, ADR 0060).

- **ADR 0061 — Azure action catalogue & second service principal**: cites ADR 0060 for the pattern — write SP (tenant_id/client_id/client_secret) on the existing `System.write_credential_ref` Grant-write flow (ADR 0051 §7 precedent, no `credential_spec` change). K8s-parity tiering: `restart_vm` T1, `start_vm` T1, `restart_app_service` T1, `set_resource_tag` T1; `deallocate_vm` T2 (billing stops, public IP may release — spelled out in expected_effect), `restart_pg_flexible_server` T2. No RBAC/identity actions — T3, out of scope. Azure SQL explicitly out of v1 (no ARM restart operation; nearest is database/pool failover — heavier, deferred; noted in the ADR). Document minimum RBAC role assignments for the write SP. Target naming = full ARM resource ID (matches `azure:{subscription_id}:{resource_id}` native keys) so ADR 0021 `protected_targets` exact-match deny-listing works.
- **ARM long-running-operation helper**: lifecycle POSTs return 202 with `Azure-AsyncOperation`/`Location` headers — add a bounded poll helper to `ArmClient` so `ActionResult` reports actual completion (succeeded/failed), not just acceptance. Bounded wall-clock wait; timeout → failed result with the operation URL in the payload.
- `AzureConnector.capabilities()` += `"actions"`; `_act_{name}` dispatch skeleton replacing the `NotImplementedError` stub, with HTTP-error containment → `ActionResult(status="failed")`, never raise (AWS `_execute` precedent, `connectors/aws.py`).
- No executor fix needed: the `ctx.config` merge shipped in ISE-373, and ARM is global (no region resolution).
- Update `test_azure_connector.py` capability/catalogue assertions; update the Azure row + DoD checklist in `docs/briefs/integration-connectors.md`.

Depends on the AWS Actions release (PRs #348–#351) being in main — branch from main after that release.