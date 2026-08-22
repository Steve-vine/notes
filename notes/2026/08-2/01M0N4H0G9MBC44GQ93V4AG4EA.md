---
id: 01M0N4H0G9MBC44GQ93V4AG4EA
created: 2026-08-22T16:23:10.089714Z
updated: 2026-08-22T16:23:33.796559Z
type: task
title: Dormancy voids assurance — dormant reads Non-compliant, reactivation starts from Not Assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 363
sprint: sbph5q5
blocked_by:
- 01M0N4GG6BPQ47RE7ASHNYHEW0
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Decided 2026-08-22, completing the compliance model (COM-361's ADR):

- [ ] **`active → dormant` sets `compliance_status = non_compliant`.** A dormant vendor isn't being reviewed or assessed; whatever assurance it had lapses with it. This is a lifecycle side effect, not a user status edit — it belongs in `core/vendor_posture.py` (a function the state-transition path calls), keeping the "reviews are the only *user* lever" rule intact while the system applies its own consequences.
- [ ] **`dormant → active` (reactivation) sets `compliance_status = not_assessed`.** Coming back means being assessed again — matches ADR 0039's "re-activation re-triggers review" intent and COM-361's earned-compliance rule. The prior status is not restored; it aged exactly as long as the vendor sat dormant.
- [ ] Offboarding stays as designed: it does **not** rewrite compliance — the record keeps what was last judged.
- [ ] Both flips write a revision (posture changed with a reason the history should show) and respect the single-writer rule: implemented in `vendor_posture`, invoked from the one state-transition path in `vendors.py`.
- [ ] Frontend: nothing new to render, but check the register/detail badge combinations read sensibly (Dormant + Non-compliant together is now the designed pair, not the broken one COM-352 removed).
- [ ] Tests: dormant flip sets non_compliant + revision; reactivation sets not_assessed + revision; offboard leaves compliance untouched; admin PATCH of state routes through the same posture functions (no second copy).