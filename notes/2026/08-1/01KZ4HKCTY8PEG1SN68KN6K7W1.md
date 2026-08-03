---
id: 01KZ4HKCTY8PEG1SN68KN6K7W1
created: 2026-08-03T19:28:52.574501Z
updated: 2026-08-03T19:28:55.744405Z
type: task
title: Azure resource groups as estate entities — the Azure connector emits exactly one edge
project: 01KX671DATY39VW6GWK3M2T3DN
number: 522
sprint: skxht3g
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Sibling to ISE-521 (AWS VPCs). Found by the same functional test of the Estate graph. Azure is the worse of the two.

## What's actually there today

`connectors/azure.py` discovers six entity types and emits **exactly one edge in the whole connector**:

- load-balancer → VM `routes-to` (line ~1426), via `_nic_vm_map`, backend-pool NICs only.

Everything else is `edges=[]`:

| Resource | Type | Edges today |
|---|---|---|
| VM | `host` | none (only as an LB target) |
| AKS cluster | `cluster` | **none** |
| SQL / database | `database` | **none** |
| Application Gateway | `load-balancer` | **none** — deliberate, backend pools address IPs/FQDNs not NICs (documented, line ~1474) |
| Storage account | `bucket` | **none** |
| App Service / Functions | `workload` | **none** |

Azure has no equivalent of the AWS EC2 → EKS `part-of` edge, so it is strictly behind the AWS connector, not level with it.

## Why resource group is the cheap fix

`_resource_group()` (line ~1201) already parses the RG out of every ARM resource id, and it is already set as an attribute on **all six** discovery paths (lines ~1285, 1323, 1369, 1439, 1467, 1504, 1540). So:

- **Zero extra API calls** — it's derived from the resource id we already hold, not a new provider list.
- **Universal coverage** — every ARM resource has exactly one RG, by construction. Unlike the AWS VPC case, there is no resource that falls outside it (S3 buckets have no VPC; every Azure resource has an RG).
- It is the boundary Azure operators actually navigate and the lifecycle/RBAC boundary.

Native key would need minting rather than reading — an RG has an ARM id (`/subscriptions/{sub}/resourceGroups/{name}`), so `azure:{sub}:{rg-id}` fits ADR 0045 unchanged.

## Decisions to make in plan mode

- **Entity vs. tag vs. group — settle this first.** ISE already has a tag pool (ADR 0037) and a reserved `group` entity type. `group` is heavily special-cased (never retired — `estate_lifecycle.py:54`; excluded from proposals, learning, impact, data reset, tag compliance), so reusing it would drag in semantics that don't fit a discovered container. A new type, or leaving RG as the attribute it is and making it a first-class tag instead, are both live options. **This may be the answer that makes the task unnecessary** — worth deciding before building.
- **RG is a *management* grouping, not a topology one.** It tells you lifecycle and ownership co-location, not "traffic flows here". It will connect the graph, but the edges carry weaker meaning than the AWS VPC ones. Be honest about that in the ADR rather than implying dependency.
- **VNet is the true VPC analogue and is not read at all** — no `Microsoft.Network/virtualNetworks` call anywhere in the connector. VM → VNet would route through the NIC, and `_nic_vm_map` already exists for the LB path, so the plumbing is half-built. Possibly the better slice, at the cost of a real API call and non-universal coverage. Decide RG vs. VNet vs. both.
- Needs an ADR extending 0059 (append-only — supersede, never rewrite). Coordinate with whatever ISE-521 lands so AWS and Azure don't invent two different container models.

## Adjacent gap found, deliberately out of scope

The connector never lists `Microsoft.Compute/virtualMachineScaleSets` (grepped — no VMSS handling at all), and AKS node VMs are VMSS instances in the managed `MC_*` resource group, not `Microsoft.Compute/virtualMachines`. So **an Azure AKS cluster appears in the estate with no nodes under it**. Different bug, own task if confirmed against the live estate — noting it here so it isn't lost.

## Definition of done

An operator can select any Azure resource on the estate graph — a database, a storage account, an App Service — and see it connected to its container, with the container's other members reachable from there.
