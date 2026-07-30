---
id: 01KYSSN42K1D6H33R6AX3A0RPR
created: 2026-07-30T15:17:58.995657Z
updated: 2026-07-30T15:21:05.490623Z
type: task
title: EC2 lifecycle actions — reboot / start / stop
project: 01KX671DATY39VW6GWK3M2T3DN
number: 374
order: 2.0
sprint: sv6hnwj
blocked_by:
- 01KYSSMCE2P50V2H1JMPVD2JHN
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
First real AWS actions: `reboot_instance` (T1), `start_instance` (T1), `stop_instance` (T2).

- Catalogue specs per `ActionSpec` (`connectors/base.py:101`): JSON Schema params (`instance_id`, optional `region`; `additionalProperties: false`), `target_fields=["instance_id"]`, `expected_effect` / `reversible` / `rollback_note` per action. Copy the shared-schema-helper pattern from `kubernetes.py:698-772`.
- `_execute` handlers: describe first to capture `before` (prior instance state name), then reboot/start/stop; refuse if instance not found; region resolved via `aws_config.regions_for` (needs ISE-373 executor fix).
- Tests per the connector DoD (`integration-connectors.md`): execution-path tests for every operation against stubbed boto3 (`test_aws_actions.py`, following `test_github_pr_action.py`); change-executor integration coverage that `stop_instance` (T2) is approval-gated and that no `write_credential_ref` ⇒ hard refusal (`test_change_executor.py` precedent).