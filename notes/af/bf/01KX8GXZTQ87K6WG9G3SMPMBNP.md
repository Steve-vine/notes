---
id: 01KX8GXZTQ87K6WG9G3SMPMBNP
created: 2026-07-11T12:02:45.20770782Z
updated: 2026-07-11T14:16:45.937293808Z
type: task
title: Kubernetes connector — read-state + detect (native client)
assignee: steve
task_status: active
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 23
blocked_by:
- 01KX8GXMA1PVAJ7111FK38PATV
sprint: sdm5e08
---
Native official Python client (connectors brief). read-state: namespaces, workloads, nodes, non-secret config, resource usage. detect: warning events, unhealthy workloads, pending pods. Health check (cheap authenticated call). Credential spec: kubeconfig / in-cluster, read-only. Contract tests against recorded/fake fixtures (ADR 0016). Credential shapes added to the redaction list.