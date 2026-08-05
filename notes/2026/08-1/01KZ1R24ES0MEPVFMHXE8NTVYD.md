---
id: 01KZ1R24ES0MEPVFMHXE8NTVYD
created: 2026-08-02T17:24:03.673427Z
updated: 2026-08-05T19:02:22.733256Z
type: task
title: Kubernetes integration states its external cluster name — direct AWS↔k8s cluster join
project: 01KX671DATY39VW6GWK3M2T3DN
number: 491
sprint: s7j0986
comments:
- id: 01KZ1W9AMT2HZMTP13QDX1JV2R
  author: Steve Vine
  at: 2026-08-02T18:37:53.690836Z
  text: |-
    Built on feature/ise-491-external-cluster-name, PR #430 to main — CI fully green (backend, frontend, lint, api-types) and deployed to staging.

    The ISE-255 "DataDog cluster name" field is generalised to an external cluster name: the k8s cluster entity now emits both k8s:cluster:{name} (joins AWS EKS's cross-key directly) and datadog:cluster:{name} (existing DataDog join unchanged). Config key renamed to external_cluster_name with the legacy key still read as a fallback; API field + settings card copy renamed to match. No migration.

    New integration test reproduces the live failure case: with DataDog off, a declared name merges the tagged AWS EKS view onto the k8s containment root — k8s keeps naming rights, AWS project/env tags land on the root, and infrastructure-environment inheritance lights up beneath it.

    Smoke test on staging: open a cluster integration, set External cluster name to its EKS name (e.g. cluster-envstaginguk-ekscluster), sync, and confirm the two cluster entities collapse into one carrying the AWS tags.
- id: 01KZ25EBRJTB3QFF95G4WY4163
  author: Steve Vine
  at: 2026-08-02T21:17:55.85828Z
  text: 'Smoke passed (all three staging cluster pairs merged directly via the external cluster name with DataDog off; AWS project/env tags on the containment roots). RELEASED to main 2026-08-02: PR #430 merged (main 9df0f74), staging reset to main, branch deleted.'
assignee: steve
label: null
priority: medium
task_status: done
---
Joining a Kubernetes cluster entity to its AWS EKS view currently routes through DataDog (the ISE-255 cluster link emits only `datadog:cluster:{name}`, and DataDog's cluster view is the bridge to AWS's `k8s:cluster:{name}` cross-key). That is fragile: it fails when DataDog is disabled or monitors the estate differently — verified live 2026-08-02 (env-staging-uk/us each split into a k8s view and a tagged AWS view, so infrastructure-environment inheritance stayed dark).

**Change:** generalise the "DataDog cluster name" field on the Kubernetes integration settings page into a single **external cluster name** field that emits BOTH cross-keys on the cluster entity: `k8s:cluster:{name}` (joins AWS's EKS entity directly) and `datadog:cluster:{name}` (keeps the existing DataDog join unchanged). One value serves both — the DD agent reports the EKS cluster name anyway.

- Backend: `connectors/kubernetes.py` adds `k8s:cluster:{name}` to the cluster's cross_keys from the config field; config stays in `System.config` (no migration).
- UI: rename/relabel the field on the Kubernetes integration settings page.
- Done when: with DataDog off, setting the field on a cluster integration merges the k8s and AWS cluster entities on the next sync, AWS `project`/`env` tags land on the containment root, and infrastructure environment is inherited beneath it.