---
id: 01M4XZJ5C4TKJRE1Y8VXNR3JN8
created: 2026-10-14T19:52:22.148081Z
updated: 2026-10-17T08:37:23.977051Z
type: task
title: Kubernetes versions are found — each EKS, AKS and GKE cluster and its node pools — and appear in Discovered ▸ Software
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 963
sprint: sbkelqe
blocked_by:
- 01M4XZGT1G67Z1HYZRG8MQ07BS
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959).

## What people see

- **Discovered ▸ Software lists the Kubernetes versions in use**, one row per provider and version: "Kubernetes 1.29 · Amazon EKS · on 3 technology assets". Each provider supports a version for a different length of time, so EKS 1.29 and AKS 1.29 are separate rows.
- **Node pools count too.** A cluster's nodes can lag behind its control plane, so a cluster with a 1.29 control plane and a 1.27 node pool shows on both rows. Opening a row shows which cluster and which pool.
- On AKS, the node pools' operating system (Ubuntu, Azure Linux, Windows) appears as an operating system on the cluster.
- Added to Software, it is the usual entry with support dates filled in (COM-962). EKS's own dates are used, including extended support.

## Notes (technical)

- **AWS:** the control plane version is already read (`kubernetes_version`, `aws/eks.py`). Node groups need `eks:ListNodegroups` and `eks:DescribeNodegroup` (`version`, `releaseVersion`, `amiType`); support dates come from `eks:DescribeClusterVersions`. Add the actions to the generated user/role template (`core/aws_policy.py` → `docs/aws/`).
- **Azure:** `orchestratorVersion`, `osSKU` and `nodeImageVersion` per agent pool are in the managed-cluster body already fetched (`azure/aks.py`), so no new action is needed. Still unproven against real data (no AKS in Steve's subscription).
- **Google:** `currentMasterVersion` is read (`gcp/gke.py`). `nodePools[].version` is in the same cluster resource, so add it to `fields`.
- Keys are `k8s:eks:1.29`, `k8s:aks:1.29` and `k8s:gke:1.29`, at minor-version grain (Kubernetes' "major" here is 1.NN).
- Fakes: extend `tests/aws_fakes.py`, `tests/azure_fakes.py` and `tests/gcp_fakes.py`.

**Done when:** on staging, an EKS cluster under a technology asset shows its control-plane and node-group versions in Discovered ▸ Software with the right counts. If no AKS or GKE cluster exists to read, say so on the task.