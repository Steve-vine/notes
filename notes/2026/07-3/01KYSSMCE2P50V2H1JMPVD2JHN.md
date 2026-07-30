---
id: 01KYSSMCE2P50V2H1JMPVD2JHN
created: 2026-07-30T15:17:34.78693Z
updated: 2026-07-30T15:18:26.071985Z
type: task
title: AWS actions foundation — ADR 0060, actions capability, executor config fix
project: 01KX671DATY39VW6GWK3M2T3DN
number: 373
sprint: sv6hnwj
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Foundation for the AWS write path (ADR 0058 §4 deferred).

- **ADR 0060 — AWS action catalogue & second IAM identity**: K8s-parity tiering (reboot_instance T1, start_instance T1, set_resource_tags T1; stop_instance T2, reboot_db_instance T2; no IAM actions — those are T3 and out of scope this sprint). Write identity is a second IAM user/credential on the existing `System.write_credential_ref` Grant-write flow (GitHub ADR 0051 §7 precedent, no `credential_spec` change); document the minimum write IAM scopes. State the target naming convention (instance-id / db-identifier / ARN) so ADR 0021 `protected_targets` exact-match deny-listing is usable.
- **Executor context fix** (connector-agnostic): `run_execution` builds `ctx.config` with only `system_name` + `risk_policy` (`tasks/actions/execute.py:98-101`) — merge in `system.config` so `aws_config.regions_for()` resolves regions on the write path.
- `AWSConnector.capabilities()` += `"actions"`; `_execute` dispatch skeleton replacing the `NotImplementedError` stub (`connectors/aws.py:1161`) with ClientError/BotoCoreError containment → `ActionResult(status="failed")`, never raise.
- Update `test_aws_connector.py` capability/catalogue assertions; update the AWS row + DoD checklist in `docs/briefs/integration-connectors.md`.