---
id: 01KYT7EVHAEG8JKWPK6Q0NCKMN
created: 2026-07-30T19:19:13.70639Z
updated: 2026-07-30T19:20:46.360865Z
type: task
title: VM + App Service lifecycle actions — restart / start / deallocate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 378
sprint: sh8mf3h
blocked_by:
- 01KYT7EFWTQRHT7K12RFEB0J69
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
First real Azure actions: `restart_vm` (T1), `start_vm` (T1), `deallocate_vm` (T2), `restart_app_service` (T1).

- Catalogue specs per `ActionSpec` (`connectors/base.py`): JSON Schema params (`resource_id` — full ARM ID, `additionalProperties: false`), `target_fields=["resource_id"]`, `expected_effect` / `reversible` / `rollback_note` per action. `deallocate_vm` expected_effect spells out: compute billing stops, dynamic public IP may be released, disks retained. Shared-schema-helper pattern from ISE-374 (`kubernetes.py` / `aws.py` precedent).
- VM handlers: describe-first before-capture (power state via instanceView/statusOnly), then POST `restart`/`start`/`deallocate`; 202 → poll to completion via the ISE-377 LRO helper; refuse missing target with a clean failed result.
- `restart_app_service`: POST `Microsoft.Web/sites/{name}/restart` — synchronous; covers Function Apps too (same `Microsoft.Web/sites` resource type). Before-capture = site state.
- Tests per the connector DoD: execution-path tests for every operation against a stubbed ArmClient (`test_azure_actions.py`, following `test_aws_actions.py` — schema refusal, protected-target deny-list, before-capture, LRO poll outcomes, error containment); change-executor coverage that `deallocate_vm` (T2) is approval-gated and no `write_credential_ref` ⇒ hard refusal.
- Acceptance: operations visible and proposable in the System-detail ActionsPanel (ISE-376, connector-generic — should light up with no frontend change).