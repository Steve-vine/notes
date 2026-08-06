---
id: 01KZ4HAPYWXY9NQJVDG9DAHK87
created: 2026-08-03T19:24:08.028349Z
updated: 2026-08-06T08:15:02.581133Z
type: task
title: AWS VPCs as estate entities — stop EC2/RDS/S3 floating unattached on the graph
project: 01KX671DATY39VW6GWK3M2T3DN
number: 521
sprint: skxht3g
comments:
- id: 01KZ4Q83XPKMRJM5MBWCJE1WX6
  author: Steve Vine
  at: 2026-08-03T21:07:34.454411Z
  text: |-
    Built — PR #445, branch feature/ise-521-aws-vpc-network-entities. ADR 0074, migration 0092.

    WHAT LANDED
    - A VPC is a `network` entity: one DescribeVpcs per configured region, keyed aws:{account}:{vpc-arn} (ADR 0045), named by the Name tag falling back to the id. `ec2:Describe*` already covers the call, so the read scopes are unchanged.
    - part-of edges into it from EC2, RDS, ELB — and EKS as well, which was not in the ask. The cluster's VPC is already in the describe_cluster response (no extra call), and ISE-522 edges AKS → VNet, so leaving it out would have left the two connectors uneven on the exact point this task was asked to settle.
    - RDS gained vpc_id from DBSubnetGroup.VpcId, which the connector never read at all. That is the case ADR 0058 opened with and did not close.
    - A node keeps BOTH containment claims (cluster and network). They answer different questions, and a standalone bastion only ever has the second.

    DECISIONS SETTLED FOR ISE-522
    - One entity type for both clouds: `network`. Two would put a vendor's vocabulary in the estate model and make "what is in this network" a per-cloud question.
    - Edge direction: the member points at the network, `part-of` — matching EC2 → EKS, and meaning the network is reached by traversal from whatever the operator was actually paged about.
    - `private-endpoint` is defined and migrated here too (unused by AWS, starts empty). The constraint swap is the same rebuild either way, and splitting it would put two migrations racing to stack in one sprint.

    TWO THINGS WORTH KNOWING
    1. An edge is only offered for a VPC the same sync discovered. Minting the key from the id would look identical and be worse — discovery drops an unresolvable target silently, so a fabricated key connects nothing while appearing to work. Edges are upserted, never withdrawn, so a failed slice costs that sync's new edges only.
    2. Writing the migration test exposed a live-code drift in the existing pattern: several migrations (0091 among them) build the type constraint from `import ENTITY_TYPES`, so `upgrade 0091` on an EMPTY database already admits types 0091 never heard of. "It was refused before this migration" is therefore not something a fresh-database test can establish. 0092 freezes its vocabulary as a literal (the 0084 pattern), and the test asserts the constraint at head equals ENTITY_TYPES — which catches the failure that actually costs a deploy: a type added to the code with no migration behind it, rejected by a long-lived database at the first sync while every fresh-database test stays green. The older migrations are append-only and untouched.

    NOT DONE, DELIBERATELY
    - Subnets — double the nodes for AZ detail `availability_zone` already carries.
    - S3 → network — a bucket is account/region-scoped and sits in no VPC. Asserted in a test rather than left implicit, because that edge would be a reachability claim that is untrue. The task title mentions S3 floating unattached; it stays unattached, and correctly so.
    - Hub-node handling — a 200-instance VPC is heavy and this relies on the existing ring cap (ISE-238) and ghost toggle (ISE-520). Nothing new built, per the ask. Worth your eye on staging.

    VERIFICATION
    Full backend suite 2168 passed; frontend 562 passed; ruff, mypy, eslint, prettier and `npm run build` clean. OpenAPI + api types regenerated (one enum pattern changed).

    UI: `network` gets IconCloudNetwork and `private-endpoint` IconPlugConnected — picked so neither reads as `cluster`'s star or `zone`'s globe at 18px (the ISE-515 rule). Both join the Estate type filter and the tag dictionary. The AWS System card counts networks with no change. The graph capability itself needs no new code — it draws whatever edges exist — so the DoD is met via smoke: select an RDS instance or a bastion and the VPC is now one hop away.
assignee: steve
priority: medium
task_status: done
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
