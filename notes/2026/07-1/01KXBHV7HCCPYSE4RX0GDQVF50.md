---
id: 01KXBHV7HCCPYSE4RX0GDQVF50
created: 2026-07-12T16:16:26.668371348Z
updated: 2026-07-12T16:16:26.668371348Z
type: task
title: Phase 4 exit test — detection to execution, end to end
priority: medium
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 53
---
Roadmap Phase 4 exit test, on staging, with real WRITE credentials and a real broken workload. Acceptance verification — no code PR (as ISE-19 / ISE-30 / ISE-43).

MAIN LEG: AI proposes a fix for a detected issue -> approver approves in the UI -> the executor applies it to g5 -> THE ISSUE RESOLVES -> the complete audit chain from detection to execution reads end to end. This is the first time ISE changes anything in the real world.

T3 / SAFETY LEG (because Steve chose the full catalogue incl. delete_resource):
- Propose a delete_resource (T3). Confirm it CANNOT be self-approved (separation of duties, ADR 0017).
- Confirm protected_targets REFUSES it against a protected namespace (kube-system / ise) even when approved — the blast-radius guard holds.
- Only then approve it against the disposable ise-acceptance namespace and watch it execute.

Reuse the ISE-43 broken-workload pattern (nginx:v99-does-not-exist in ise-acceptance) — restart_rollout / scale_workload are the natural remediations, and the AI should propose one of them.