---
id: 01KX0MW1GG2HH0DJQ3WF942P6Q
created: 2026-07-08T10:37:40.240993Z
updated: 2026-07-11T14:15:24.837752Z
type: task
title: Adjust the Cloudflared deployment
assignee: steve
priority: medium
task_status: todo
---
Cloudflare deployment uses a daemonset with Anti-affinity and no pod priority.

Claude:-
You've put your finger on exactly the right thing: anti-affinity is a placement hint, not a resource guarantee. It changes the probability that pods clump, but it says nothing about "this critical pod must get its slice." And there are two structural facts making it worse for cloudflared specifically:

It's a DaemonSet, so it's pinned. The pod can only run on its node. When that node fills, it doesn't get to go elsewhere — it just waits.
Karpenter can't rescue it. This is the counter-intuitive bit: adding a node doesn't help a pinned DS pod at all. A new node comes up with its own cloudflared pod; the one stuck on the full node stays pending. So the usual "autoscaling absorbs the pressure" safety net doesn't apply to DaemonSets.

So the question becomes: when a node genuinely doesn't have room, who wins? Right now cloudflared is at default priority, equal to the apps — so it loses. The mechanism that actually guarantees a resource slice is PriorityClass + preemption: give cloudflared a priority above the apps, and when it can't fit, the scheduler evicts a lower-priority app pod to make room. The displaced app pod then goes pending — and that's the pod Karpenter can rescue (it's not pinned). So priority + Karpenter work together: cloudflared preempts an openanswer pod on the full node → openanswer goes pending → Karpenter gives it a new node. The system self-heals, and the tunnel is never the thing that loses. That's the direct answer to "what if the node doesn't have enough resources."
That said, for this particular workload there's an even cleaner structural fix worth weighing: does cloudflared need to be a DaemonSet at all? Cloudflare load-balances across whatever connectors register, so you usually just need N connectors for HA/throughput, not one-per-node. If you run it as a Deployment (say 3–4 replicas, with topology spread + anti-affinity) instead of a DaemonSet, the pinning problem disappears entirely — the scheduler places replicas wherever there's room, and if there isn't, Karpenter adds a node. That removes the whole failure mode rather than mitigating it. The only reason to keep it a DaemonSet is if you specifically want node-local egress, which a tunnel connector generally doesn't need.
So my honest prioritisation:

Right-size the app requests — 425m × 4 on a 2-vCPU node smells over-provisioned. If real usage is a fraction of that (worth a kubectl top / Datadog check), the node was never actually busy — it filled up on phantom reservations. Honest requests are the highest-leverage, lowest-risk lever and make everything else easier.
Give cloudflared (and any genuinely must-run DaemonSets) a PriorityClass above apps — the guarantee for the pinned case.
Or convert cloudflared to a Deployment with spread — removes the pinning failure mode structurally; arguably the best long-term answer for this specific service.
Spread constraints on the heavy apps — hygiene that lowers clustering probability (necessary, not sufficient).

The leverage point is that 2–4 belong in the shared Crossplane composition, so you fix the whole fleet once rather than chasing it per-app per-incident — a coherent priority tier (system-critical > platform infra like cloudflared > apps) plus the cloudflared topology decision, baked in.
Two trade-offs to keep honest: preemption does disrupt the app it evicts (a restart), and it only best-effort-respects PodDisruptionBudgets — so it's for genuinely critical infra, not something to sprinkle everywhere; and priority classes only mean something if apps stay at a disciplined default, otherwise everything inflates to "high" and you're back where you started.
Want me to pull the openanswer kubectl top numbers to see how over-provisioned it actually is, and/or draft the composition change — either the cloudflared PriorityClass or the DaemonSet→Deployment conversion — so you can see what each would look like?