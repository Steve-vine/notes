---
id: 01KYT7EVHAEG8JKWPK6Q0NCKMN
created: 2026-07-30T19:19:13.70639Z
updated: 2026-08-07T11:55:13.735626Z
type: task
title: VM + App Service lifecycle actions — restart / start / deallocate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 378
sprint: sh8mf3h
blocked_by:
- 01KYT7EFWTQRHT7K12RFEB0J69
comments:
- id: 01KYT91YZ1KGPN4YHAKM27WP3X
  author: Steve Vine
  at: 2026-07-30T19:47:08.385789Z
  text: |-
    Built on feature/ise-378-vm-appservice-lifecycle (stacked on ISE-377), PR #353 → #352's branch (retarget to main at release, per the stacked-chain release pattern); merged to staging (e300a0b).

    - Catalogue per ADR 0061 §2: restart_vm (T1), start_vm (T1), deallocate_vm (T2 — expected_effect spells out billing ends / dynamic public IP may release / disks kept), restart_app_service (T1; covers Function Apps, same Microsoft.Web/sites type).
    - Targets = full ARM resource ids in native-key spelling: schemas refuse mixed case (portal paste) so the ADR 0021 protected-targets exact match holds, and each pattern pins its resource type — a VM action cannot be pointed at a site.
    - One handler shape: describe-first before-capture (instanceView power state / site state as the rollback substrate), refuse missing target with a clean failed result, exactly one state change via run_action; Failed operations carry Azure's error, an expired poll window carries the operation URL — acceptance never reported as success.
    - Tests: new test_azure_actions.py (12 tests through the real act() gates: before-capture, LRO failure/timeout, error containment, mixed-case + wrong-type schema refusal, protected-target deny-list); connector test pins the ADR 0061 tier table verbatim. Executor guarantees (T2 approval-gated, no write_credential_ref ⇒ refusal) already pinned generically in test_change_executor.py.

    Gates: ruff + format + mypy strict clean; full suite 1617 passed locally. ISE-377 PR CI (#352) green through backend-lint/api-types at last check.
assignee: steve
priority: medium
task_status: done
---
First real Azure actions: `restart_vm` (T1), `start_vm` (T1), `deallocate_vm` (T2), `restart_app_service` (T1).

- Catalogue specs per `ActionSpec` (`connectors/base.py`): JSON Schema params (`resource_id` — full ARM ID, `additionalProperties: false`), `target_fields=["resource_id"]`, `expected_effect` / `reversible` / `rollback_note` per action. `deallocate_vm` expected_effect spells out: compute billing stops, dynamic public IP may be released, disks retained. Shared-schema-helper pattern from ISE-374 (`kubernetes.py` / `aws.py` precedent).
- VM handlers: describe-first before-capture (power state via instanceView/statusOnly), then POST `restart`/`start`/`deallocate`; 202 → poll to completion via the ISE-377 LRO helper; refuse missing target with a clean failed result.
- `restart_app_service`: POST `Microsoft.Web/sites/{name}/restart` — synchronous; covers Function Apps too (same `Microsoft.Web/sites` resource type). Before-capture = site state.
- Tests per the connector DoD: execution-path tests for every operation against a stubbed ArmClient (`test_azure_actions.py`, following `test_aws_actions.py` — schema refusal, protected-target deny-list, before-capture, LRO poll outcomes, error containment); change-executor coverage that `deallocate_vm` (T2) is approval-gated and no `write_credential_ref` ⇒ hard refusal.
- Acceptance: operations visible and proposable in the System-detail ActionsPanel (ISE-376, connector-generic — should light up with no frontend change).