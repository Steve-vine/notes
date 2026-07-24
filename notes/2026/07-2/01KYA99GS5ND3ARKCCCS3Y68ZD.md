---
id: 01KYA99GS5ND3ARKCCCS3Y68ZD
created: 2026-07-24T14:43:25.093838Z
updated: 2026-07-24T16:12:51.258187Z
type: task
title: 'Cluster entity split: DataDog and Kubernetes views never join'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 255
sprint: s5khymf
assignee: steve
priority: medium
task_status: todo
---
Pre-existing dead join (predates ISE-246, visible now the estate is clean). The same physical cluster exists as **two entities**: the Kubernetes System's cluster entity (e.g. `env-staging-us`, native key now `k8s:{system_id}:cluster`, previously the literal `k8s:cluster`) and the DataDog-discovered one (`cluster-envstagingus`, native key `datadog:cluster:{name}` from host cluster tags, `connectors/datadog.py:712`).

DataDog emits cross-key `k8s:cluster:{name}` — which has **never matched either format** of the K8s cluster key, so the join has never resolved. The two views are bridged only indirectly through shared host entities (host is part-of both cluster entities), which double-counts clusters in the estate (17 cluster entities today for 16 physical clusters + 1 duplicate) and splits blast-radius traversal at the cluster level.

Fix direction: same cluster-name→System mapping problem as ISE-254 (the two should share a resolution mechanism) — a K8s System knows its own cluster's DataDog-visible name (or an operator asserts it), then either side can emit a matching cross-key, or the alias is human-asserted (`resolution="asserted"`, ADR 0028 §4) via the existing alias-proposal flow. Reconcile's multi-match merge then heals the split automatically on the next sync.