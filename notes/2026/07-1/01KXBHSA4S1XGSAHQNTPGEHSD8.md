---
id: 01KXBHSA4S1XGSAHQNTPGEHSD8
created: 2026-07-12T16:15:23.801426546Z
updated: 2026-07-21T18:31:24.765609Z
type: task
title: act() — the execution seam + write credentials
project: 01KX671DATY39VW6GWK3M2T3DN
number: 46
sprint: sdcd2jr
assignee: steve
priority: high
task_status: done
---
Add act(ctx, action, params) -> ActionResult to the Connector ABC (connectors/base.py) — there is NO execute method anywhere in the codebase today. Implement it on both connectors for the FULL catalogue (Steve's decision): kubernetes restart_rollout T1, scale_workload T1, edit_resource T2, delete_resource T3; datadog ack_event T0, mute_monitor T1, unmute_monitor T1, edit_monitor T2.

Populate ActionSpec.parameters with real JSON Schemas (every one is {} today) + add the small `jsonschema` dep. Shared validate_action_params(spec, params) used at PROPOSAL time (an approver only ever sees valid parameters) AND again at EXECUTION time (defence in depth — never trust stored params).

ActionResult: status, detail, before — `before` is the rollback substrate (prior replica count, prior monitor definition). Fake-connector act() for tests (tests/conftest_connectors.py).

STEVE PROVISIONS: a write-scoped g5 ServiceAccount/kubeconfig and a DataDog write key, stored via the existing credential API (ADR 0018). Rotating read-only creds to write is the single most sensitive step in the sprint — ISE has never held a write credential.

Tests mock act() at the SDK boundary. NO live mutation in CI, ever.