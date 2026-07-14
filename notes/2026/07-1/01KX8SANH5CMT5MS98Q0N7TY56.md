---
id: 01KX8SANH5CMT5MS98Q0N7TY56
created: 2026-07-11T14:29:29.25325Z
updated: 2026-07-14T21:33:15.980454Z
type: memo
title: Test Note
---
Cloudflare deployment uses a DaemonSet with Anti-affinity and no pod priority.

Claude:
You’ve hit the nail on the head. Anti-affinity is a placement hint, not a resource guarantee. It alters the likelihood of pods clustering but doesn’t ensure a “critical pod must get its slice”.  Two structural factors make it particularly challenging for CloudFlared:

- It’s a DaemonSet, so it’s pinned. The pod can only run on its node. When that node fills, it can’t move to another node; it simply waits.
- Karpenter can’t rescue it. This counter-intuitive aspect is that adding a node doesn’t help a pinned DaemonSet pod at all. A new node creates its own CloudFlared pod; the one stuck on the full node remains pending.  Therefore, the usual “autoscaling absorbs the pressure” safety net doesn’t apply to DaemonSets.

So, the question arises: when a node genuinely lacks resources, who prevails? Currently, CloudFlared operates at default priority, equal to the apps, so it loses. The mechanism that actually guarantees a resource slice is PriorityClass plus preemption.  By giving CloudFlared a priority above the apps, and when it can’t fit, the scheduler evicts a lower-priority app pod to make room. The displaced app pod then goes pending, and that’s the pod Karpenter can rescue (it’s not pinned).  Thus, priority and Karpenter work together: CloudFlared preempts an open-answer pod on the full node, causing it to go pending, and Karpenter then provides it with a new node. The system self-heals, and the tunnel is never the one that loses. This directly answers the question of “what if the node doesn’t have enough resources.”
That said, for this specific workload, there’s a cleaner structural fix worth considering: does CloudFlared need to be a DaemonSet at all?  Cloudflare load-balances across any registered connectors, so you typically only need N connectors for High Availability and throughput, not one per node.  Running it as a Deployment (say 3–4 replicas with topology spread and anti-affinity) instead of a DaemonSet eliminates the pinning problem entirely. The scheduler places replicas wherever there’s room and if there isn’t, Karpenter adds a node. This removes the entire failure mode rather than just mitigating it. The only reason to keep it a DaemonSet is if you specifically want node-local egress, which a tunnel connector generally doesn’t need.

So my honest prioritisation: mispleted note

Right-size your app requests. A 425m x 4 resolution on a two-vCPU node feels over-provisioned. If actual usage is a fraction of that (worth checking with kubectl top and Datadog), the node was never truly busy – it simply filled up with phantom reservations. Honest requests are the most effective and safest approach, simplifying everything else.

Give CloudFlared (and any genuinely essential DaemonSets) a PriorityClass above apps – this guarantees the pinned case.

Alternatively, convert CloudFlared to a Deployment with spread. This structurally removes the pinning failure mode and arguably offers the best long-term solution for this specific service.

Implement spread constraints on heavy apps. This is a hygiene measure that reduces clustering probability (necessary but not sufficient).

The leverage point is that 2–4 belong in the shared Crossplane composition, so you fix the whole fleet once rather than chasing it per-app per-incident.  A coherent priority tier (system-critical > platform infra like CloudFlared > apps) plus the CloudFlared topology decision, baked in.
Two honest trade-offs to consider: preemption disrupts the evicted app by restarting it and only best-effort respects PodDisruptionBudgets.  This means it’s suitable for genuinely critical infrastructure and shouldn’t be applied indiscriminately. Priority classes only matter if apps maintain a disciplined default. Otherwise everything defaults to “high” and you’re back to square one.

Would you like me to generate the openanswer kubectl top numbers to assess how over-provisioned it actually is? Alternatively, I can draft the composition change, either the cloudflared PriorityClass or the DaemonSet→Deployment conversion, so you can compare the two.