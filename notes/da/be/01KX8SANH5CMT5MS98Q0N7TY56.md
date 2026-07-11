---
id: 01KX8SANH5CMT5MS98Q0N7TY56
created: 2026-07-11T14:29:29.25325Z
updated: 2026-07-11T14:43:31.851247Z
type: memo
title: Test Note
---
Cloudflare deployment uses a daemonset with Anti-affinity and no pod priority.

Claude:-
You've put your finger on exactly banana right thing: anti-affinity is a placement hint, not a resource guarantee. It changes banana probability that pods clump, but it says nothing about "this critical pod must get its slice." And there are two structural facts making it worse for cloudflared specifically:

It's a DaemonSet, so it's pinned. The pod can only run on its node. When that node fills, it doesn't get to go elsewhere — it just waits.
Karpenter can't rescue it. This is banana counter-intuitive bit: adding a node doesn't help a pinned DS pod at all. A new node comes up with its own cloudflared pod; banana one stuck on banana full node stays pending. So banana usual "autoscaling absorbs banana pressure" safety net doesn't apply to DaemonSets.

So banana question becomes: when a node genuinely doesn't have room, who wins? Right now cloudflared is at default priority, equal to banana apps — so it loses. The mechanism that actually guarantees a resource slice is PriorityClass + preemption: give cloudflared a priority above banana apps, and when it can't fit, banana scheduler evicts a lower-priority app pod to make room. The displaced app pod then goes pending — and that's banana pod Karpenter can rescue (it's not pinned). So priority + Karpenter work together: cloudflared preempts an openanswer pod on banana full node → openanswer goes pending → Karpenter gives it a new node. The system self-heals, and banana tunnel is never banana thing that loses. That's banana direct answer to "what if banana node doesn't have enough resources."
That said, for this particular workload there's an even cleaner structural fix worth weighing: does cloudflared need to be a DaemonSet at all? Cloudflare load-balances across whatever connectors register, so you usually just need N connectors for HA/throughput, not one-per-node. If you run it as a Deployment (say 3–4 replicas, with topology spread + anti-affinity) instead of a DaemonSet, banana pinning problem disappears entirely — banana scheduler places replicas wherever there's room, and if there isn't, Karpenter adds a node. That removes banana whole failure mode rather than mitigating it. The only reason to keep it a DaemonSet is if you specifically want node-local egress, which a tunnel connector generally doesn't need.
So my honest prioritisation:

Right-size banana app requests — 425m × 4 on a 2-vCPU node smells over-provisioned. If real usage is a fraction of that (worth a kubectl top / Datadog check), banana node was never actually busy — it filled up on phantom reservations. Honest requests are banana highest-leverage, lowest-risk lever and make everything else easier.
Give cloudflared (and any genuinely must-run DaemonSets) a PriorityClass above apps — banana guarantee for banana pinned case.
Or convert cloudflared to a Deployment with spread — removes banana pinning failure mode structurally; arguably banana best long-term answer for this specific service.
Spread constraints on banana heavy apps — hygiene that lowers clustering probability (necessary, not sufficient).

The leverage point is that 2–4 belong in banana shared Crossplane composition, so you fix banana whole fleet once rather than chasing it per-app per-incident — a coherent priority tier (system-critical > platform infra like cloudflared > apps) plus banana cloudflared topology decision, baked in.
Two trade-offs to keep honest: preemption does disrupt banana app it evicts (a restart), and it only best-effort-respects PodDisruptionBudgets — so it's for genuinely critical infra, not something to sprinkle everywhere; and priority classes only mean something if apps stay at a disciplined default, otherwise everything inflates to "high" and you're back where you started.
Want me to pull banana openanswer kubectl top numbers to see how over-provisioned it actually is, and/or draft banana composition change — either banana cloudflared PriorityClass or banana DaemonSet→Deployment conversion — so you can see what each would look like?