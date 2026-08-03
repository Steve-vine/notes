---
id: 01KZ4HKCTY8PEG1SN68KN6K7W1
created: 2026-08-03T19:28:52.574501Z
updated: 2026-08-03T20:40:55.651995Z
type: task
title: Azure VNets + private endpoints + VMSS instance discovery
project: 01KX671DATY39VW6GWK3M2T3DN
number: 522
sprint: skxht3g
assignee: steve
priority: medium
task_status: todo
---
Sibling to ISE-521 (AWS VPCs) — the VNet is the direct VPC equivalent, so Azure gets the same container model rather than a second one. Found by the same functional test of the Estate graph.

Resource groups were considered and **dropped**: an RG is a management/lifecycle grouping, not a topology one, and edges to it would carry weaker meaning than they appear to.

## What's actually there today

`connectors/azure.py` discovers six entity types and emits **exactly one edge in the whole connector**:

- load-balancer → VM `routes-to` (line ~1426), via `_nic_vm_map`, backend-pool NICs only.

Everything else is `edges=[]`: VM (`host`), AKS cluster (`cluster`), SQL/Postgres/MySQL (`database`), Application Gateway (`load-balancer` — deliberate, backend pools address IPs/FQDNs not NICs, documented line ~1474), storage account (`bucket`), App Service/Functions (`workload`).

There is no Azure equivalent of the AWS EC2 → EKS `part-of` edge, so Azure is behind the AWS connector, not level with it.

None of `Microsoft.Network/virtualNetworks`, `Microsoft.Network/privateEndpoints` or `Microsoft.Compute/virtualMachineScaleSets` is listed anywhere in the connector (grepped — no handling at all).

## Why VNet alone is not enough — and why private endpoints are in scope

Unlike AWS, where EC2/RDS/ELB all sit inside a VPC, Azure PaaS is **not VNet-resident**:

| Resource | Reached by |
|---|---|
| VM, VMSS instance | in the VNet, via NIC |
| AKS cluster | in the VNet — `agentPoolProfiles[].vnetSubnetID` |
| Application Gateway | in the VNet, always subnet-deployed |
| Internal load balancer | in the VNet — `frontendIPConfigurations[].properties.subnet.id` |
| Public load balancer | neither — public IP, no subnet |
| SQL / Postgres / MySQL | **private endpoint** (else public endpoint) |
| Storage account | **private endpoint** (else public endpoint) |
| App Service / Functions | **private endpoint** or VNet integration |

VNet containment alone would connect only the compute half and leave every database and storage account as orphaned as they are today. Private endpoints close the other half, and they carry the stronger claim of the two: *"this database is reached from this VNet"* is a real dependency, where `part-of` a VNet is only co-location.

## Scope

**1. VNet entities.** New provider `Microsoft.Network/virtualNetworks` in `_API_VERSIONS` (`2024-01-01`, matching the other `Microsoft.Network/*` entries). Same network container entity type as ISE-521 — coordinate so AWS and Azure do not invent two models. Native key `azure:{sub}:{vnet-resource-id}` per ADR 0045, unchanged. Attributes: location, address space, subnet count, resource group.

**2. `part-of` edges into the VNet** from VM, VMSS instance, AKS cluster, App Gateway and internal LB. Subnet ids truncate at `/subnets/` to give the VNet id.

**3. Private endpoints.** `Microsoft.Network/privateEndpoints` (`2024-01-01`). Each PE gives both halves of a path: `properties.subnet.id` places it in a VNet, and the connection's `properties.privateLinkServiceId` is **the ARM resource id of the target** — already exactly the string we mint native keys from, so the edge target needs no extra lookup.

Read **both** `privateLinkServiceConnections` and `manualPrivateLinkServiceConnections` — the manual-approval flow populates only the second array, and reading one misses those endpoints entirely.

Worth carrying: `groupIds` (`sqlServer`, `blob`, `file`, `postgresqlServer` — distinguishes a blob PE from a file PE on the same storage account) and `privateLinkServiceConnectionState.status` (Approved / Pending / Rejected / Disconnected).

**4. UI.** Distinct `TYPE_ICON` glyphs in `EntityGraphView.tsx` for any new type — and per the ISE-515 lesson, assert on what the eye perceives, not on component identity. Confirm the graph reads well with a VNet hub present.

**5. VMSS + instances.** `Microsoft.Compute/virtualMachineScaleSets`, then the per-scale-set instance list. AKS nodes are VMSS instances in the managed `MC_*` resource group, not `Microsoft.Compute/virtualMachines`, which is why an Azure AKS cluster currently appears in the estate **with no nodes under it at all**. Instances get `part-of` → AKS cluster (mirroring EC2 → EKS) and a `k8s:node:{computerName}` cross-key — an AKS node's Kubernetes node name *is* the VMSS instance computer name (e.g. `aks-nodepool1-12345678-vmss000000`), so this joins straight onto the Kubernetes connector's node entities, exactly the AWS EC2 pattern.

## The one real design call — model the PE, or collapse it?

**Collapsing** it (emit VNet → target `routes-to` and discard the PE) is fewer nodes and reads cleanly on the graph. But `DiscoveredEdge` carries **only** `target_native_key` and `edge_type` (`connectors/base.py:237`) — no attributes. So a collapsed edge **cannot carry the connection status**, and a Pending or Rejected private endpoint is precisely the broken-path misconfiguration ISE exists to surface. Collapsing makes a broken PE indistinguishable from a healthy one.

**Recommend modelling the PE as its own entity**, following the ISE-517 precedent (`secret` got its own type rather than `other` because it was the thing most worth tracing a dependency *to*). Chain becomes VNet ← `part-of` ← PE → `routes-to` → database. Costs a second new entity type, but the migration is constraint-widening either way so both land in one — settle it in plan mode alongside ISE-521's type choice.

## Traps to plan around

- **Cross-subscription targets will silently vanish.** `privateLinkServiceId` may point into a *different* subscription, and `_key()` scopes with the **client's** subscription id — keying the target with the current sub mints a key that resolves to nothing. Parse the sub out of the target resource id (`/subscriptions/{sub}/…`) rather than assuming it. This is ADR 0045's whole point.
- **An unresolvable edge target is dropped without a trace.** `discovery.py:424-431` — target not in the batch, not in the DB, `continue`. So a PE pointing at a subscription ISE has no System for loses its edge silently. Worth a count in `counts[…]` so it is visible rather than debugged later.
- **The NIC sweep must be hoisted.** `_nic_vm_map` is called *inside* `_discover_load_balancers`. VM → VNet needs the same sweep (NIC → `ipConfigurations[].properties.subnet.id`), so lift it into `discover_entities` and pass it down, or the connector pays for two full NIC listings per sync. Done right, VM → VNet costs **no new API call** beyond the VNet list itself.
- **VMSS instances are an N+1 fan-out** — there is no subscription-wide list of scale-set instances, so it is one call per scale set. Bounded by scale-set count (small), but this is the same shape as the per-bucket tag fan-out ISE-359 refused to pay; confirm the count on the live estate before committing.
- **Naming — apply ISE-511 directly.** A scale set stamps one name pattern across its whole fleet, exactly like a Karpenter pool. Name instances by computer name / k8s node name (the same string emitted as the `k8s:node:` cross-key) so both owners propose the same name and the ISE-471 first-discovery race stops mattering.
- **Churn and retirement.** VMSS instances come and go like Karpenter nodes. Check this against ISE-514's `retire_confirmed_gone` and its >50%-of-a-type stand-down guard before the first live sync.
- **`$expand=instanceView`** blew up subscription-wide on VMs (HTTP 400, live-found on staging — see `_vm_power_states`). The error text said it is *"only supported when Virtual Machine Scale Set resource filter is applied"*, which hints the VMSS-scoped query does support it. Verify against the live estate; do not assume.
- Needs an ADR extending 0059 (append-only — supersede, never rewrite).

## Definition of done

An operator can select an Azure VM or an AKS node on the estate graph and see it connected to its VNet and its cluster; can select a SQL database or storage account and see which VNet reaches it, and whether that path is healthy; and an AKS cluster shows its nodes instead of standing empty.
