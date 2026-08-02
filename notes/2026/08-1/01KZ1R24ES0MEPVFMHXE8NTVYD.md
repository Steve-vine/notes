---
id: 01KZ1R24ES0MEPVFMHXE8NTVYD
created: 2026-08-02T17:24:03.673427Z
updated: 2026-08-02T17:24:08.380213Z
type: task
title: Kubernetes integration states its external cluster name — direct AWS↔k8s cluster join
project: 01KX671DATY39VW6GWK3M2T3DN
number: 491
sprint: s7j0986
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Joining a Kubernetes cluster entity to its AWS EKS view currently routes through DataDog (the ISE-255 cluster link emits only `datadog:cluster:{name}`, and DataDog's cluster view is the bridge to AWS's `k8s:cluster:{name}` cross-key). That is fragile: it fails when DataDog is disabled or monitors the estate differently — verified live 2026-08-02 (env-staging-uk/us each split into a k8s view and a tagged AWS view, so infrastructure-environment inheritance stayed dark).

**Change:** generalise the "DataDog cluster name" field on the Kubernetes integration settings page into a single **external cluster name** field that emits BOTH cross-keys on the cluster entity: `k8s:cluster:{name}` (joins AWS's EKS entity directly) and `datadog:cluster:{name}` (keeps the existing DataDog join unchanged). One value serves both — the DD agent reports the EKS cluster name anyway.

- Backend: `connectors/kubernetes.py` adds `k8s:cluster:{name}` to the cluster's cross_keys from the config field; config stays in `System.config` (no migration).
- UI: rename/relabel the field on the Kubernetes integration settings page.
- Done when: with DataDog off, setting the field on a cluster integration merges the k8s and AWS cluster entities on the next sync, AWS `project`/`env` tags land on the containment root, and infrastructure environment is inherited beneath it.