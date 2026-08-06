---
id: 01KZB1A3RH9KEKEMJ9RX8CWX3T
created: 2026-08-06T07:58:52.177624Z
updated: 2026-08-06T09:18:30.846708Z
type: task
title: Migrate Kubernetes rate guards to threshold_specs
project: 01KX671DATY39VW6GWK3M2T3DN
number: 582
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
assignee: steve
label: null
priority: medium
task_status: active
---
Declare the currently hard-coded, no-config-channel rate guards (`kubernetes.py:150-160`) as `ThresholdSpec`s: `_NODE_FLAP_MIN_COUNT = 3`, `_PLACEMENT_CHURN_MIN_COUNT = 10`, `_RATE_GUARD_WINDOW = 30min`. ADR 0030 explicitly flagged these as provisional ("shape-based, no staging churn baseline yet; refine against telemetry") — declaring them makes them tunable per cluster for the first time, which is exactly the refinement channel that note asked for.

Behaviour unchanged at defaults (churn escalation at `kubernetes.py:1988` still fires at the same counts). The categorical severities (Pending/CrashLoopBackOff/OOMKilled etc.) are NOT thresholds and stay as they are.

Acceptance: the three guards are visible/editable per k8s System in the generic card; existing rate-guard tests pass unmodified at defaults.