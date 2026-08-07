---
id: 01KYJK1N1BHXMFBCSNKNH6037S
created: 2026-07-27T20:07:48.523266Z
updated: 2026-08-07T10:57:12.180549Z
type: task
title: 'Evidence gaps from live MCP use: DataDog search_logs datetime crash + pods/log RBAC missing'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 340
sprint: sohzsw2
assignee: steve
label: null
priority: high
task_status: done
---
Reported by Claude mid-investigation (2026-07-27, noted on the ticket): two evidence pulls failed while chasing a crash error.

**1. DataDog `search_logs`: `'datetime.datetime' object has no attribute '_composed_schemas'`.** Root cause in `datadog.py::_plain`: it passes primitives through and feeds everything else to the SDK's `model_to_dict` — but a log entry's `timestamp` arrives as a real `datetime`, which is neither. Fix: `_plain` now isoformats datetimes and degrades any other non-model object to `str()` instead of letting an unexpected SDK type kill the pull. Regression tests added (latent since ISE-150; only surfaced when the MCP surface made log evidence easy to reach).

**2. Kubernetes `pod_logs`: 403.** The `ise-connector-read` ClusterRole grants `pods` but not the separate **`pods/log` subresource** — the ISE-333 evidence catalogue promised logs the read principal couldn't fetch. Fix: `scripts/infra/k8s-readonly-rbac.example.yaml` adds `pods/log: [get]` (get only — a tail is a point read). Applied to **g5** and verified end-to-end (MCP fetch_evidence pod_logs returns a real tail).

**Remaining rollout (Steve):** apply the updated manifest to the other monitored clusters — `env-staging-us` and `env-staging-uk` still 403 (confirmed live):

    kubectl apply -f scripts/infra/k8s-readonly-rbac.example.yaml

(idempotent; only the ClusterRole changes — the stored kubeconfig credential keeps working, no token rotation needed).