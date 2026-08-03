---
id: 01KZ4HAPYWXY9NQJVDG9DAHK87
created: 2026-08-03T19:24:08.028349Z
updated: 2026-08-03T20:46:30.020435Z
type: task
title: AWS VPCs as estate entities — stop EC2/RDS/S3 floating unattached on the graph
project: 01KX671DATY39VW6GWK3M2T3DN
number: 521
sprint: skxht3g
assignee: steve
priority: medium
task_status: active
---
Found while functionally testing the Estate graph: AWS resources arrive with almost no relationships, so most of them sit on the graph as isolated nodes.

## What's actually there today

The AWS connector emits only **two** edges (`connectors/aws.py`):

- EC2 → EKS cluster `part-of` (line ~1136) — only when the instance carries `aws:eks:cluster-name` or `kubernetes.io/cluster/*` **and** that cluster was discovered in the same sync.
- ELB → EC2 `routes-to` (`_elb_target_edges`, line ~1279) — instance targets in target groups only; IP and Lambda targets are skipped.

Everything else emits `edges=[]`:

| Resource | Edges today |
|---|---|
| EC2 in an EKS pool | `part-of` cluster (+ `routes-to` if load-balanced) |
| EC2 standalone (bastion, pet VM) | **none** |
| RDS | **none, ever** |
| S3 bucket | **none, ever** |

The RDS case is the sharp one: ADR 0058's stated motivating gap was *"an RDS alert cannot answer which services does this affect"*, and as built an RDS instance has no edge to anything.

## VPCs were never excluded by decision

`grep -ri vpc docs/` returns nothing. ADR 0058 §3 enumerates the v1 entity set (EC2→host, RDS→database, EKS→cluster, ELB→load-balancer, S3→bucket) and never discusses network containers either way. VPC wasn't ruled out — it was just never in scope for read-only v1.

`vpc_id` **is** already captured, but only as a narrative attribute on EC2 (`aws.py:1152`) and ELB (`aws.py:1262`), not on RDS. Attributes are explicitly not join keys (ADR 0028), so it cannot anchor anything in the graph.

## Proposed scope — one vertical slice

1. New entity type for a network container (`network`?) — constraint-widening migration, same shape as `secret` in mig 0091. Layer: Resource (ADR 0073).
2. `_discover_vpc` — one `DescribeVpcs` call per configured region. Native key `aws:{account_id}:{vpc-arn}` per ADR 0045. Name from the `Name` tag, else the VPC id.
3. `part-of` edges from EC2, RDS and ELB to their VPC. Add `vpc_id` to the RDS attributes (`DBSubnetGroup.VpcId`) — it isn't read at all today.
4. UI: confirm it reads well on the estate graph, and that `TYPE_ICON` in `EntityGraphView.tsx` gets a distinct glyph (ISE-515 lesson — assert on what the eye perceives, not component identity).

## Decisions to make in plan mode

- **Subnets**: recommend NOT modelling them for v1 — they'd roughly double node count for AZ detail the existing `availability_zone` attribute already carries.
- **Hub nodes**: a VPC with 200 instances becomes a heavy hub. The topology-aware ring cap and the ISE-520 ghost toggle are the existing mitigations — verify they're enough rather than building anything new.
- **Azure is doing the same thing in ISE-522** (VNet as the direct VPC equivalent, plus VMSS instance discovery). The two tasks must agree on **one** network-container entity type and one edge direction — settle that here, since this one defines the type. Resource groups were considered for Azure and dropped as a management rather than topology grouping.
- Needs an ADR amending/extending 0058 (append-only — supersede, never rewrite).

## Definition of done

An operator can select a standalone EC2 instance or an RDS database on the estate graph and see it connected to its VPC, with the VPC's other members reachable from there.
