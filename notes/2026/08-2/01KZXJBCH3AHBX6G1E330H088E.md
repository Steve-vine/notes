---
id: 01KZXJBCH3AHBX6G1E330H088E
created: 2026-08-13T12:42:59.491513Z
updated: 2026-08-13T12:43:09.292328Z
type: task
title: A denied metrics read says "no permission", not "install metrics-server"
project: 01KX671DATY39VW6GWK3M2T3DN
number: 685
sprint: sevhjex
assignee: steve
label:
- bug
priority: medium
task_status: backlog
---
`_ev_pod_resource_usage` (`app/backend/src/ISE_api/connectors/kubernetes.py:2913`) catches every `ApiException` from the `metrics.k8s.io` call and renders one verdict:

```
metrics-server unavailable (403): install it to answer live-usage questions
```

A 403 is RBAC. Only a 404 (or a missing APIService) means metrics-server is genuinely absent. Today the connector confidently sends the operator to install a component that is already running — verified on g5, where `v1beta1.metrics.k8s.io` reports `Available=True` while the ISE credential is denied `list pods.metrics.k8s.io`. The message is not a near-miss; it names the wrong system and the wrong fix, and this is the third time a confidently-wrong error has cost real diagnosis time (the gitleaks-license/DNS case, the timeout-cluster case).

**Scope**
- Branch on `exc.status`: 403 → name the permission the credential lacks and point at the cluster credential, not at metrics-server; 404 → the existing "install it" wording; anything else → the status and reason as themselves.
- The evidence result stays `ok=False` in every branch — a fact about the cluster, per ADR 0031. This is about which fact.
- Sweep the connector's other broad `except` blocks for the same conflation before closing: `count_objects` swallows a 403 into `-1`, so "34 objects are invisible" and "you cannot see whether any objects exist" read identically to the operator.

This is user-facing text — it lands in evidence results during an investigation and, via the Platform Log, on a screen. It carries this sprint's UI deliverable.

Independent of ISE-684: the wildcard grant makes a metrics 403 unlikely, but the message would still be wrong on any cluster whose credential predates the re-run, and the status-code conflation is the actual defect.