---
id: 01KYSSN42K1D6H33R6AX3A0RPR
created: 2026-07-30T15:17:58.995657Z
updated: 2026-08-07T10:55:56.995354Z
type: task
title: EC2 lifecycle actions — reboot / start / stop
project: 01KX671DATY39VW6GWK3M2T3DN
number: 374
order: 2.0
sprint: sv6hnwj
blocked_by:
- 01KYSSMCE2P50V2H1JMPVD2JHN
comments:
- id: 01KYSV56Y2VXCY0G8XS3MC6AM3
  author: Steve Vine
  at: 2026-07-30T15:44:14.7868Z
  text: |-
    Built on feature/ise-374-ec2-lifecycle-actions (stacked on ISE-373), PR #349 → #348's branch (retarget to main at release, per the stacked-chain release pattern).

    - Catalogue: reboot_instance (T1), start_instance (T1), stop_instance (T2) per ADR 0060 §2 — shared _instance_action_schema (instance-id pattern gate, optional region override, additionalProperties false), target_fields=["instance_id"].
    - One handler shape (_instance_lifecycle): region resolution (explicit param → configured list → credential default → build_client fallback) → describe-first before-capture → refuse missing target → exactly one state change. before = {instance_id, instance_state, region}.
    - Failure semantics: InvalidInstanceID.* → clean not-found failed result; other AWS errors contained by the dispatch (never raises).
    - Tests: new test_aws_actions.py (10 tests through the real act() gates: schema refusal, protected-target deny-list, before-capture, region rungs, error containment); connector test now pins the ADR 0060 tier table verbatim; generic action-validation sweep picks the catalogue up automatically.

    Gates: ruff + format + mypy strict clean; full suite 1590 passed locally. ISE-373 PR CI (#348) confirmed green.
assignee: steve
priority: medium
task_status: done
---
First real AWS actions: `reboot_instance` (T1), `start_instance` (T1), `stop_instance` (T2).

- Catalogue specs per `ActionSpec` (`connectors/base.py:101`): JSON Schema params (`instance_id`, optional `region`; `additionalProperties: false`), `target_fields=["instance_id"]`, `expected_effect` / `reversible` / `rollback_note` per action. Copy the shared-schema-helper pattern from `kubernetes.py:698-772`.
- `_execute` handlers: describe first to capture `before` (prior instance state name), then reboot/start/stop; refuse if instance not found; region resolved via `aws_config.regions_for` (needs ISE-373 executor fix).
- Tests per the connector DoD (`integration-connectors.md`): execution-path tests for every operation against stubbed boto3 (`test_aws_actions.py`, following `test_github_pr_action.py`); change-executor integration coverage that `stop_instance` (T2) is approval-gated and that no `write_credential_ref` ⇒ hard refusal (`test_change_executor.py` precedent).