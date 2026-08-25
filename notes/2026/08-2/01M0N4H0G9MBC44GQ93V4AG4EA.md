---
id: 01M0N4H0G9MBC44GQ93V4AG4EA
created: 2026-08-22T16:23:10.089714Z
updated: 2026-08-25T18:43:09.099041Z
type: task
title: Dormancy voids assurance — dormant reads Non-compliant, reactivation starts from Not Assessed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 363
sprint: sbph5q5
blocked_by:
- 01M0N4GG6BPQ47RE7ASHNYHEW0
comments:
- id: 01M0N94B2ZJV19QSC95NZBXFS3
  author: Steve Vine
  at: 2026-08-22T17:43:37.823626Z
  text: |-
    Done — PR #365, merged to main.

    - `active → dormant` sets `non_compliant`; `dormant → active` sets `not_assessed` (the prior status is *not* restored). Both in **`core/vendor_posture.apply_state_change`**, called from the one state-transition path in `vendors.py` *before* the assignment, since the consequence depends on where the vendor is coming from as well as where it is going.
    - Single-writer rule intact: a review is still the only *user* lever, these are system consequences, so they live in the module that owns the column. The posture flip rides into the same revision the state change writes — one snapshot carrying both, rather than two describing half a move each.
    - Offboarding untouched, and now covered **both ways**: neither offboarding nor an admin's revert out of it rewrites compliance. `requested → active` voids nothing (already `not_assessed`).
    - Frontend: nothing new to render, as expected — but "Mark dormant"/"Mark active" are one-click buttons that now rewrite the posture, so the lifecycle card states the consequence beforehand. Otherwise a compliance status that changed because somebody pressed a button is a mystery on the History tab. Dormant + Non-compliant reads fine: separate pills, separate colours.
    - Tests: the full round trip with the revision sequence asserted in order (`requested/not_assessed → active/not_assessed → active/compliant → dormant/non_compliant → active/not_assessed`); offboard + admin revert leave `non_compliant` alone; an admin's PATCH goes through the same function (no second copy); three frontend cases for the consequence lines.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: done
---
Decided 2026-08-22, completing the compliance model (COM-361's ADR):

- [ ] **`active → dormant` sets `compliance_status = non_compliant`.** A dormant vendor isn't being reviewed or assessed; whatever assurance it had lapses with it. This is a lifecycle side effect, not a user status edit — it belongs in `core/vendor_posture.py` (a function the state-transition path calls), keeping the "reviews are the only *user* lever" rule intact while the system applies its own consequences.
- [ ] **`dormant → active` (reactivation) sets `compliance_status = not_assessed`.** Coming back means being assessed again — matches ADR 0039's "re-activation re-triggers review" intent and COM-361's earned-compliance rule. The prior status is not restored; it aged exactly as long as the vendor sat dormant.
- [ ] Offboarding stays as designed: it does **not** rewrite compliance — the record keeps what was last judged.
- [ ] Both flips write a revision (posture changed with a reason the history should show) and respect the single-writer rule: implemented in `vendor_posture`, invoked from the one state-transition path in `vendors.py`.
- [ ] Frontend: nothing new to render, but check the register/detail badge combinations read sensibly (Dormant + Non-compliant together is now the designed pair, not the broken one COM-352 removed).
- [ ] Tests: dormant flip sets non_compliant + revision; reactivation sets not_assessed + revision; offboard leaves compliance untouched; admin PATCH of state routes through the same posture functions (no second copy).