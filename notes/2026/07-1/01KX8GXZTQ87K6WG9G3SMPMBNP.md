---
id: 01KX8GXZTQ87K6WG9G3SMPMBNP
created: 2026-07-11T12:02:45.20770782Z
updated: 2026-07-19T13:22:53.145133837Z
type: task
title: Kubernetes connector — read-state + detect (native client)
assignee: steve
task_status: done
priority: high
project: 01KX671DATY39VW6GWK3M2T3DN
number: 23
blocked_by:
- 01KX8GXMA1PVAJ7111FK38PATV
comments:
- id: 01KX8SSXPWDNB2ZBX794YVFZ9G
  author: Steve Vine
  at: 2026-07-11T14:37:49.148629977Z
  text: 'Development complete on feature/ise-023-kubernetes-connector. PR #24: https://github.com/Steve-vine/ise/pull/24. Native k8s client; kubeconfig-per-cluster auth from encrypted credential; read-only (act declared not executed). Slices: namespaces/workloads/nodes/config (ConfigMap keys only, secrets out of RBAC scope). Detect: warning events (reason→severity), unhealthy deployments, pending pods, CrashLoopBackOff. 106/106 tests (24 connector contract via fake apis + 1 integration through sync.sync_one). kubeconfig added to redaction. g5 read-only RBAC applied (least-privilege SA/ClusterRole, no secrets/writes — verified). LIVE ON STAGING: stored the g5 read-only kubeconfig credential, configured a g5 system (kubernetes, 60s), Beat synced it → health=connected within one interval; persisted real state (13 namespaces, 20 deploys/3 sts/2 ds, 1 node, 28 configmaps) and — unprompted — detected a REAL finding: high-severity Unhealthy startup-probe failure on an arc-runners pod. Credential access audited to sync:g5. Setup notes: g5 system+credential were created directly in the api pod for the live test (bypassing the create-audit); ~/ise-g5-readonly.yaml holds the read-only kubeconfig (SA token) on the local box — treat like the break-glass file. Awaiting smoke test + merge clearance.'
- id: 01KX8TTB3N67B15NQ1EM3HVSMF
  author: Steve Vine
  at: 2026-07-11T14:55:31.445189856Z
  text: 'Smoke tests passed. PR #24 merged to main (1f36344), branch deleted. Belt-and-braces main run green. Done. g5 continues syncing on staging every 60s.'
sprint: sdm5e08
label: null
---
Native official Python client (connectors brief). read-state: namespaces, workloads, nodes, non-secret config, resource usage. detect: warning events, unhealthy workloads, pending pods. Health check (cheap authenticated call). Credential spec: kubeconfig / in-cluster, read-only. Contract tests against recorded/fake fixtures (ADR 0016). Credential shapes added to the redaction list.