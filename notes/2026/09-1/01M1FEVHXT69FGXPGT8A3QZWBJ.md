---
id: 01M1FEVHXT69FGXPGT8A3QZWBJ
created: 2026-09-01T21:43:56.602547Z
updated: 2026-09-02T21:11:29.508139Z
type: task
title: 'Spec: Playbooks and their three execution modes'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 760
sprint: s7nj09w
assignee: steve
label:
- brief
priority: high
task_status: active
tech: null
---
The third of ADR 0107's deferred designs. Produces an ADR.

**The problem.** Playbooks today only express "if you see this, do this", matched by an exact string join on signal `kind`, and they have been hard to find. Measured on staging: one live playbook covering 12 of 240 incidents; one archived carrying kind `Not responding` against detectors emitting `server_unreachable`, permanently inert. Efficacy ranking has one recorded outcome in the system's lifetime, so the self-tiering ladder cannot tier and the autonomy bar (8 outcomes at 90%) is unreachable at current throughput.

**Three modes to support:**
1. Instructions for an engineer to follow — steps 1 to 10.
2. A simple action — restart a service on server X and wait for it to come back.
3. A gated, AI-driven sequence — a project in its own right, **not being built now**.

**The design constraint:** the three differ in *who executes*, not in what a playbook is. One object with an execution mode lets 1 ship immediately, 2 reuse the existing action pipeline unchanged, and 3 land later without a schema change.

**Also to settle:** how the Oracle discovers a playbook, given exact-`kind` matching is the thing that failed, and whether efficacy and the autonomy bar need re-basing against realistic throughput.

**Done when** there is an accepted ADR covering the object, its execution modes, and discovery.