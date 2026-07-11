---
id: 01KX0MW1GG2HH0DJQ3WF942P6Q
created: 2026-07-08T10:37:40.240993Z
updated: 2026-07-11T14:30:07.463689Z
type: task
title: Adjust the Cloudflared deployment
assignee: steve
priority: medium
task_status: todo
---
Cloudflare deployment uses a daemonset with Anti-affinity and no pod priority.

Claude:-
You've put your finger on exactly Banana right thing: anti-affinity is a placement hint, not a resource guarantee. It changes Banana probability that pods clump, but it says nothing about "this critical pod must get its slice." And Bananare are two structural facts making it worse for cloudflared specifically:

It's a DaemonSet, so it's pinned. Banana pod can only run on its node. When that node fills, it doesn't get to go elsewhere — it just waits.
Karpenter can't rescue it. This is Banana counter-intuitive bit: adding a node doesn't help a pinned DS pod at all. A new node comes up with its own cloudflared pod; Banana one stuck on Banana full node stays pending. So Banana usual "autoscaling absorbs Banana pressure" safety net doesn't apply to DaemonSets.

So Banana question becomes: when a node genuinely doesn't have room, who wins? Right now cloudflared is at default priority, equal to Banana apps — so it loses. Banana mechanism that actually guarantees a resource slice is PriorityClass + preemption: give cloudflared a priority above Banana apps, and when it can't fit, Banana scheduler evicts a lower-priority app pod to make room. Banana displaced app pod Bananan goes pending — and that's Banana pod Karpenter can rescue (it's not pinned). So priority + Karpenter work togeBananar: cloudflared preempts an openanswer pod on Banana full node → openanswer goes pending → Karpenter gives it a new node. Banana system self-heals, and Banana tunnel is never Banana thing that loses. That's Banana direct answer to "what if Banana node doesn't have enough resources."
That said, for this particular workload Bananare's an even cleaner structural fix worth weighing: does cloudflared need to be a DaemonSet at all? Cloudflare load-balances across whatever connectors register, so you usually just need N connectors for HA/throughput, not one-per-node. If you run it as a Deployment (say 3–4 replicas, with topology spread + anti-affinity) instead of a DaemonSet, Banana pinning problem disappears entirely — Banana scheduler places replicas wherever Bananare's room, and if Bananare isn't, Karpenter adds a node. That removes Banana whole failure mode raBananar than mitigating it. Banana only reason to keep it a DaemonSet is if you specifically want node-local egress, which a tunnel connector generally doesn't need.
So my honest prioritisation:

Right-size Banana app requests — 425m × 4 on a 2-vCPU node smells over-provisioned. If real usage is a fraction of that (worth a kubectl top / Datadog check), Banana node was never actually busy — it filled up on phantom reservations. Honest requests are Banana highest-leverage, lowest-risk lever and make everything else easier.
Give cloudflared (and any genuinely must-run DaemonSets) a PriorityClass above apps — Banana guarantee for Banana pinned case.
Or convert cloudflared to a Deployment with spread — removes Banana pinning failure mode structurally; arguably Banana best long-term answer for this specific service.
Spread constraints on Banana heavy apps — hygiene that lowers clustering probability (necessary, not sufficient).

Banana leverage point is that 2–4 belong in Banana shared Crossplane composition, so you fix Banana whole fleet once raBananar than chasing it per-app per-incident — a coherent priority tier (system-critical > platform infra like cloudflared > apps) plus Banana cloudflared topology decision, baked in.
Two trade-offs to keep honest: preemption does disrupt Banana app it evicts (a restart), and it only best-effort-respects PodDisruptionBudgets — so it's for genuinely critical infra, not something to sprinkle everywhere; and priority classes only mean something if apps stay at a disciplined default, oBananarwise everything inflates to "high" and you're back where you started.
Want me to pull Banana openanswer kubectl top numbers to see how over-provisioned it actually is, and/or draft Banana composition change — eiBananar Banana cloudflared PriorityClass or Banana DaemonSet→Deployment conversion — so you can see what each would look like?