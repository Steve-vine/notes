---
id: 01KZ4HKCTY8PEG1SN68KN6K7W1
created: 2026-08-03T19:28:52.574501Z
updated: 2026-08-03T19:38:11.709191Z
type: task
title: Azure VNets as estate entities + VMSS instance discovery
project: 01KX671DATY39VW6GWK3M2T3DN
number: 522
sprint: skxht3g
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Sibling to ISE-521 (AWS VPCs) — the VNet is the direct VPC equivalent, so Azure gets the same container model rather than a second one. Found by the same functional test of the Estate graph.

Resource groups were considered and **dropped**: an RG is a management/lifecycle grouping, not a topology one, and edges to it would carry weaker meaning than they appear to.

## What's actually there today

`connectors/azure.py` discovers six entity types and emits **exactly one edge in the whole connector**:

- load-balancer → VM `routes-to` (line ~1426), via `_nic_vm_map`, backend-pool NICs only.

Everything else is `edges=[]`: VM (`host`), AKS cluster (`cluster`), SQL/Postgres/MySQL (`database`), Application Gateway (`load-balancer` — deliberate, backend pools address IPs/FQDNs not NICs, documented line ~1474), storage account (`bucket`), App Service/Functions (`workload`).

There is no Azure equivalent of the AWS EC2 → EKS `part-of` edge, so Azure is behind the AWS connector, not level with it.

Neither `Microsoft.Network/virtualNetworks` nor `Microsoft.Compute/virtualMachineScaleSets` is listed anywhere in the connector (grepped — no handling at all).

## Read this before accepting: VNet will not connect everything

Unlike AWS — where EC2, RDS and ELB all sit inside a VPC — Azure PaaS is **not VNet-resident by default**. Expected coverage:

| Resource | In a VNet? |
|---|---|
| VM | yes, always (via its NIC) |
| VMSS instance | yes, always |
| AKS cluster | yes — `agentPoolProfiles[].vnetSubnetID` |
| Application Gateway | yes, always subnet-deployed |
| Internal load balancer | yes — `frontendIPConfigurations[].properties.subnet.id` |
| Public load balancer | no — fronted by a public IP, no subnet |
| **SQL / Postgres / MySQL** | **no** — public-endpoint PaaS |
| **Storage account** | **no** |
| **App Service / Functions** | **no** (unless VNet integration is configured) |

So this task connects the **compute and network** half of the Azure estate and leaves databases, storage and App Services exactly as orphaned as they are now. That is the accepted trade for topological honesty over an RG grouping that would have connected everything but meant less.

**Private endpoints are the thing that would close the remaining half**, and they carry real meaning ("this database is reached from this VNet"): `Microsoft.Network/privateEndpoints` sit in a subnet and carry `privateLinkServiceConnections[].properties.privateLinkServiceId` pointing at the SQL server or storage account. Decide in plan mode whether that lands here or as a follow-on — it is the higher-value half of the graph, so consider pulling it in.

## Scope

**1. VNet entities.** New provider `Microsoft.Network/virtualNetworks` in `_API_VERSIONS` (use `2024-01-01`, matching the other `Microsoft.Network/*` entries). Same network container entity type as ISE-521 — coordinate so AWS and Azure do not invent two models. Native key `azure:{sub}:{vnet-resource-id}` per ADR 0045, unchanged. Attributes: location, address space, subnet count, resource group.

**2. `part-of` edges into the VNet** from VM, VMSS instance, AKS cluster, App Gateway and internal LB. Subnet ids truncate at `/subnets/` to give the VNet id.

**3. VMSS + instances.** `Microsoft.Compute/virtualMachineScaleSets`, then the per-scale-set instance list. **This is the real prize**: AKS nodes are VMSS instances in the managed `MC_*` resource group, not `Microsoft.Compute/virtualMachines`, which is why an Azure AKS cluster currently appears in the estate **with no nodes under it at all**. Instances get `part-of` → AKS cluster (mirroring EC2 → EKS) and a `k8s:node:{computerName}` cross-key — an AKS node's Kubernetes node name *is* the VMSS instance computer name (e.g. `aks-nodepool1-12345678-vmss000000`), so this joins straight onto the Kubernetes connector's node entities, exactly the AWS EC2 pattern.

**4. UI.** Distinct `TYPE_ICON` glyph in `EntityGraphView.tsx` for the new type — and per the ISE-515 lesson, assert on what the eye perceives, not on component identity. Confirm the graph reads well with a VNet hub present.

## Traps to plan around

- **The NIC sweep must be hoisted.** `_nic_vm_map` is called *inside* `_discover_load_balancers`. VM → VNet needs the same sweep (NIC → `ipConfigurations[].properties.subnet.id`), so lift it into `discover_entities` and pass it down, or the connector pays for two full NIC listings per sync. Done right, VM → VNet costs **no new API call** beyond the VNet list itself.
- **VMSS instances are an N+1 fan-out** — there is no subscription-wide list of scale-set instances, so it is one call per scale set. Bounded by scale-set count (small), but this is the same shape as the per-bucket tag fan-out ISE-359 refused to pay; confirm the count on the live estate before committing.
- **Naming — apply ISE-511 directly.** A scale set stamps one name pattern across its whole fleet, exactly like a Karpenter pool. Name instances by computer name / k8s node name (the same string emitted as the `k8s:node:` cross-key) so both owners propose the same name and the ISE-471 first-discovery race stops mattering.
- **Churn and retirement.** VMSS instances come and go like Karpenter nodes. Check this against ISE-514's `retire_confirmed_gone` and its >50%-of-a-type stand-down guard before the first live sync.
- **`$expand=instanceView`** blew up subscription-wide on VMs (HTTP 400, live-found on staging — see `_vm_power_states`). The error text said it is *"only supported when Virtual Machine Scale Set resource filter is applied"*, which hints the VMSS-scoped query does support it. Verify against the live estate; do not assume.
- Needs an ADR extending 0059 (append-only — supersede, never rewrite).

## Definition of done

An operator can select an Azure VM or an AKS node on the estate graph and see it connected to its VNet and its cluster, with the VNet's other members reachable from there — and an AKS cluster shows its nodes instead of standing empty.
