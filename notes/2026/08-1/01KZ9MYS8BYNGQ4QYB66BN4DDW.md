---
id: 01KZ9MYS8BYNGQ4QYB66BN4DDW
created: 2026-08-05T19:03:43.627999Z
updated: 2026-08-08T17:32:40.059282Z
type: task
title: Fleet coverage reconciler — Arc, EC2 and Azure VM candidates with dismiss and exclusion rules
project: 01KX671DATY39VW6GWK3M2T3DN
number: 566
sprint: sesjg7z
assignee: steve
label: null
priority: high
task_status: todo
---
The register is the definitive fleet list; everything else audits it (ADR 0084 §coverage). Depends on ISE-564/565.

**Reconciler**
- Scheduled task compares the register against every machine-shaped sighting ISE has, in two source classes:
  - **Already-entities**: EC2 instances, Azure VMs — an unregistered one is a candidate that, on confirm, **binds** to the existing entity.
  - **List-only**: Arc machines (`Microsoft.HybridCompute/machines` via the existing ArmClient — the fleet deliberately excluded from the Azure connector 2026-08-03; Arc is a *list ISE reads*, never a System that owns entities) — on confirm, registers + mints. (EntraID devices: ISE-569; Hyper-V guests: ISE-570.)
- Candidates land in the **proposals queue** (the established confirm surface) with three outcomes: **register** (pick profile → preflight), **dismiss** (persistent per machine — never reappears), and never-reach via **exclusion rules**.
- **Exclusion rules — the noise defence.** Unregistered is the *default* state of the cloud estate; without rules the queue is permanent noise and dies of being ignored. v1 starter set, hard-coded: instances that are k8s nodes (Karpenter churn), VMSS/ASG members, other ephemeral scale-set compute. Log excluded counts (no silent caps).

**Frontend**
- **Coverage tab** on the Servers screen: unmatched machines by source, register/dismiss inline, count badge on the tab. Excluded-by-rule total shown as a line, not rows.

**Acceptance**: with Arc/AWS/Azure connectors enabled on staging, the Coverage tab lists genuinely unmanaged machines (the ~39 Arc fleet expected), zero EKS/Karpenter/VMSS noise; dismissing a machine is durable across reconciler runs; confirming an EC2 candidate binds, not duplicates.