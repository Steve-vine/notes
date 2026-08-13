---
id: 01KZ3VYPS8SNVWVKT4MDTX82CS
created: 2026-08-03T13:10:34.53603Z
updated: 2026-08-13T19:00:09.953272Z
type: task
title: 'Estate: Karpenter hosts named after the nodepool Name tag, not the hostname'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 511
order: 1.0
sprint: skxht3g
comments:
- id: 01KZ3YGWH7RV4SWRPK85W8AFMV
  author: Steve Vine
  at: 2026-08-03T13:55:27.39899Z
  text: |-
    Fixed in PR #436 (feature/ise-511-host-naming).

    Root cause as described: aws.py named every EC2 instance `tag_map.get("Name") or instance_id`, and an autoscaled pool stamps one Name tag across the whole fleet.

    Fix: a pool-managed instance is named by its private DNS name instead. Pool-managed = any of a `karpenter.sh/*` tag, an EKS cluster tag (`aws:eks:cluster-name` / `kubernetes.io/cluster/*`), or `eks:nodegroup-name`. Worth noting — the EKS cluster tag alone was NOT enough: a Karpenter instance is tagged by the provisioner that launched it and need not carry a cluster tag at all, which is the live shape here (my first attempt missed exactly the nodes in this ticket, and the test caught it).

    Why the full private DNS rather than the short `ip-172-21-82-67` form: it's the string the Kubernetes connector already uses for the same machine (`node.metadata.name` on EKS) and the one AWS emits as its `k8s:node:` cross-key. Both owners now propose the same name, so the ISE-471 first-discovery race stops deciding what a node is called — a shortened form would reintroduce a name that flips with sync order.

    A plain instance is unaffected: a bastion keeps its Name tag, a tagless one still falls back to the instance id.

    No migration needed — a name is a discovered fact refreshed each sync by the namer, so the two mis-named staging-uk hosts correct themselves on the next AWS sync (a human-pinned name still wins per ISE-493).

    Tests: two new cases in test_aws_discovery.py (three nodes sharing a Name tag come out distinct; pets/fallbacks unchanged), plus the existing EKS-tagged fixture assertion updated deliberately. AWS + discovery/source-of-record/multi-cluster suites green, ruff/format/mypy strict clean.
- id: 01KZ429354KYEB6RZ8CEQAAMHQ
  author: Steve Vine
  at: 2026-08-03T15:01:06.340498Z
  text: 'RELEASED to main 2026-08-03 (PR #436 merged, main 34366df, no migration). Staging smoke passed and staging reset to main. The two mis-named env-staging-uk hosts take their correct hostnames on the next AWS sync — no manual repair needed, since a name is a discovered fact the namer refreshes each pass.'
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Found in Sprint 46 Estate testing. Two env-staging-uk hosts display as "cluster-envstaginguk-nodeclass-nodepool-apps" — the Karpenter pool's AWS Name tag — instead of their hostname (ip-172-21-82-67 / ip-172-21-85-156). Naming is a first-discovery race: when the AWS integration discovers an instance before the Kubernetes sync, it names the entity from the EC2 Name tag, and every Karpenter node in a pool carries the same tag value — so the estate shows multiple hosts with identical, meaningless names.

**Fix direction:** for host entities, prefer the hostname/private-DNS over the EC2 Name tag when naming (or treat the shared Karpenter tag as non-authoritative).