---
id: 01KYSSMCE2P50V2H1JMPVD2JHN
created: 2026-07-30T15:17:34.78693Z
updated: 2026-08-07T10:09:35.098376Z
type: task
title: AWS actions foundation — ADR 0060, actions capability, executor config fix
project: 01KX671DATY39VW6GWK3M2T3DN
number: 373
order: 1.0
sprint: sv6hnwj
comments:
- id: 01KYSTHHBAT8AMWJ80QJAQSB1W
  author: Steve Vine
  at: 2026-07-30T15:33:30.08994Z
  text: |-
    Built on feature/ise-373-aws-actions-foundation, PR #348 → main.

    - ADR 0060 written (docs/decisions/0060-aws-actions.md): second IAM identity on write_credential_ref (ADR 0051 §7 pattern, credential_spec stays read-only), K8s-parity tiers (reboot/start/tags T1; stop/RDS-reboot T2), AWS-native target identifiers (instance id / DB identifier / ARN) for the protected-targets deny-list, explicitly no IAM actions (§4 — self-escalation rationale recorded).
    - Executor now merges System.config into ctx.config (spread first, reserved keys system_name/risk_policy win) — the connector-agnostic fix that lets aws_config.regions_for() resolve regions on the write path. New executor test pins passthrough + reserved-key precedence; FakeConnector records ctx.config.
    - AWSConnector: capabilities now {alerts, entities, evidence, actions}; _execute is an _act_{name} dispatch with ClientError/BotoCoreError containment → failed ActionResult (never raises). Catalogue deliberately still empty — operations land with their handlers in ISE-374/375.
    - Brief connector matrix: AWS row → Built (Sprints 33+35, ADRs 0058/0060).

    Gates: ruff + format + mypy strict clean; full backend suite 1580 passed locally. PR CI running.
assignee: steve
label: null
priority: medium
task_status: done
---
Foundation for the AWS write path (ADR 0058 §4 deferred).

- **ADR 0060 — AWS action catalogue & second IAM identity**: K8s-parity tiering (reboot_instance T1, start_instance T1, set_resource_tags T1; stop_instance T2, reboot_db_instance T2; no IAM actions — those are T3 and out of scope this sprint). Write identity is a second IAM user/credential on the existing `System.write_credential_ref` Grant-write flow (GitHub ADR 0051 §7 precedent, no `credential_spec` change); document the minimum write IAM scopes. State the target naming convention (instance-id / db-identifier / ARN) so ADR 0021 `protected_targets` exact-match deny-listing is usable.
- **Executor context fix** (connector-agnostic): `run_execution` builds `ctx.config` with only `system_name` + `risk_policy` (`tasks/actions/execute.py:98-101`) — merge in `system.config` so `aws_config.regions_for()` resolves regions on the write path.
- `AWSConnector.capabilities()` += `"actions"`; `_execute` dispatch skeleton replacing the `NotImplementedError` stub (`connectors/aws.py:1161`) with ClientError/BotoCoreError containment → `ActionResult(status="failed")`, never raise.
- Update `test_aws_connector.py` capability/catalogue assertions; update the AWS row + DoD checklist in `docs/briefs/integration-connectors.md`.