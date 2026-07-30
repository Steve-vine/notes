---
id: 01KYT7EFWTQRHT7K12RFEB0J69
created: 2026-07-30T19:19:01.786674Z
updated: 2026-07-30T19:20:45.167946Z
type: task
title: Azure actions foundation — ADR 0061, actions capability, ARM LRO helper
project: 01KX671DATY39VW6GWK3M2T3DN
number: 377
sprint: sh8mf3h
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Foundation for the Azure write path (follow-on to ADR 0059; mirrors the AWS pattern, ADR 0060).

- **ADR 0061 — Azure action catalogue & second service principal**: cites ADR 0060 for the pattern — write SP (tenant_id/client_id/client_secret) on the existing `System.write_credential_ref` Grant-write flow (ADR 0051 §7 precedent, no `credential_spec` change). K8s-parity tiering: `restart_vm` T1, `start_vm` T1, `restart_app_service` T1, `set_resource_tag` T1; `deallocate_vm` T2 (billing stops, public IP may release — spelled out in expected_effect), `restart_pg_flexible_server` T2. No RBAC/identity actions — T3, out of scope. Azure SQL explicitly out of v1 (no ARM restart operation; nearest is database/pool failover — heavier, deferred; noted in the ADR). Document minimum RBAC role assignments for the write SP. Target naming = full ARM resource ID (matches `azure:{subscription_id}:{resource_id}` native keys) so ADR 0021 `protected_targets` exact-match deny-listing works.
- **ARM long-running-operation helper**: lifecycle POSTs return 202 with `Azure-AsyncOperation`/`Location` headers — add a bounded poll helper to `ArmClient` so `ActionResult` reports actual completion (succeeded/failed), not just acceptance. Bounded wall-clock wait; timeout → failed result with the operation URL in the payload.
- `AzureConnector.capabilities()` += `"actions"`; `_act_{name}` dispatch skeleton replacing the `NotImplementedError` stub, with HTTP-error containment → `ActionResult(status="failed")`, never raise (AWS `_execute` precedent, `connectors/aws.py`).
- No executor fix needed: the `ctx.config` merge shipped in ISE-373, and ARM is global (no region resolution).
- Update `test_azure_connector.py` capability/catalogue assertions; update the Azure row + DoD checklist in `docs/briefs/integration-connectors.md`.

Depends on the AWS Actions release (PRs #348–#351) being in main — branch from main after that release.