---
id: 01KZK7WJ806MM5TD9KJX4G3HKZ
created: 2026-08-09T12:27:43.74451Z
updated: 2026-08-09T13:20:12.346793Z
type: task
title: Discovery wrongly excludes every EC2 instance as a Kubernetes node
project: 01KX671DATY39VW6GWK3M2T3DN
number: 625
sprint: sesjg7z
comments:
- id: 01KZKAWN1T67DR1K935VAKWYBY
  author: Steve Vine
  at: 2026-08-09T13:20:12.346671Z
  text: |-
    BUILT + MERGED to main 2026-08-09 — PR #565, `feature/ise-625-k8s-node-offer-not-claim`.

    **The fix.** `servers_coverage.excluded_reason` now joins the alias check to `system.connector_type == "kubernetes"`. An alias only means "Kubernetes node" when the Kubernetes integration asserted it; anyone else publishing `k8s:node:` is offering a join, not making a claim.

    **The second rule was dead code.** With the alias check matching every EC2 instance and returning first, the `part-of`-a-`cluster` rule had never once run. It now does the work it was written for — there is a test pinning that specifically, because "belt and braces" that has never fired is not belt and braces.

    **Audit done.** `servers_coverage` was the only reader of `k8s:node:` as proof of nodehood. Every other site (`aws.py`, `azure.py`, `datadog.py`, `kubernetes.py`, `servers.py`) *publishes* the key as a join offer, which is correct and unchanged. The coverage API's `excluded` count recomputes through the same function, so it corrected itself with no separate change.

    **Tests.** The existing test asserted the bug — its fixture hung the node alias off an `aws` system, so it was green for the wrong reason. Corrected, plus three cases: an AWS-published key alone is NOT excluded (the `tgc-…zone-zonea` shape from the report); a Kubernetes-asserted key is; both together is (the real EKS shape, where the assertion must beat the offer).

    Acceptance is met on the code; the live numbers (Discovered gaining ~49 EC2 hosts, excluded dropping to real nodes + VMSS) need the staging deploy to confirm.
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Bug in ISE-566's exclusion rules, found by Steve 2026-08-09 from `tgc-bstrstaging-instance-network-bstrstaging.zone-zonea` in the staging account — a Twingate connector, not a Kubernetes node, and absent from Discovered.

**Live evidence:**

```
EC2 host entities: 89
  k8s:node alias asserted by the KUBERNETES connector : 40   <- genuinely nodes
  k8s:node alias only from AWS (a speculative join key): 49   <- wrongly excluded
  no k8s:node alias at all                            : 0
```

**More than half the EC2 estate is hidden from Discovered.**

**Root cause — a join HINT read as a FACT.** `aws.py` attaches `k8s:node:{private_dns}` as a cross key to every EC2 instance that has a private DNS name, and it is right to: on EKS the node name IS the private DNS name, so publishing the key speculatively is what lets an EKS node and its instance resolve to one entity (the ISE-205 join). The key is an offer, not a claim.

`servers_coverage.excluded_reason` then treats the mere presence of that alias as proof the machine IS a node. Every EC2 instance carries the key, so every EC2 instance is excluded.

The example: `tgc-…zone-zonea` is a `host` in state `running` with aliases

```
aws:463040245339:…instance/i-0b37c05816b139be3
datadog:host:i-0b37c05816b139be3
k8s:node:ip-172-21-14-222.eu-west-2.compute.internal   <- published by AWS, resolves to no node
```

**The fix.** The alias only means "Kubernetes node" when the KUBERNETES connector asserted it — i.e. an `EntityAlias` on a system whose `connector_type` is `kubernetes`. AWS publishing the key means only that AWS is offering a join.

Note `excluded_reason` already has a second, correct rule — a `part-of` edge to a `cluster` entity — but it is unreachable, because the alias check returns first. Fixing the alias check makes the cluster-edge rule do the work it was written for.

**Why it went unnoticed, and the lesson.** This fails as a FALSE NEGATIVE: machines silently missing from a list, with no error and a queue that looks clean. I reported the 91-excluded number to Steve as evidence the rules were working well; it was the opposite — the rule was swallowing the entire EC2 estate. An exclusion count is only reassuring if something independently verifies what was excluded.

**Also worth an audit**: anything else in the codebase reading a `k8s:node:` alias as proof of nodehood has the same conflation. The key is deliberately unscoped and deliberately speculative.

**Acceptance**: `tgc-bstrstaging-instance-network-bstrstaging.zone-zonea` appears in Discovered; the ~40 genuine EKS nodes still do not; the excluded count drops to roughly the number of real nodes plus VMSS instances; a test asserts that an EC2 instance carrying an AWS-published `k8s:node:` key with no corresponding Kubernetes-asserted alias is NOT excluded.