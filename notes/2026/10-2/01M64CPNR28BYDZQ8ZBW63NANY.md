---
id: 01M64CPNR28BYDZQ8ZBW63NANY
created: 2026-10-29T17:53:09.890597Z
updated: 2026-10-29T20:15:37.222561Z
type: task
title: 'Operators Manual: Posture — assessing controls, gaps, risks and decisions'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 17
sprint: sstqjgj
blocked_by:
- 01M64CNWM12FKRY4C9ZPVKB4XW
comments:
- id: 01M64MVGR6HG4YG08V78Z2W287
  author: Steve Vine
  at: 2026-10-29T20:15:37.222419Z
  text: |-
    Pushed to staging (216d329): a "Posture" group in the docs sidebar with seven pages and 11 screenshots, checked against the v0.16.0 code.

    The pages:
    - Assess a control
    - How compliance is calculated
    - Raise and track a gap
    - Record and treat a risk
    - Measure against a framework (scope, levels, exclusions)
    - Follow compliance over time
    - Record a decision

    Still to retake: the Compliance page's charts read "No points yet" until the demo has nightly snapshots, so that shot is clipped to the gauge for now.

    The 0.6.0 facts were re-checked: Compliant still means Implemented only; unassessed still counts as a shortfall; the "Not applicable" status still does nothing. New since then: framework levels (CIS IG1–3, HITRUST e1/i1/r2) change the denominator; decisions can link to incidents; the Timeline page is now called Compliance.

    Possible app issues found while writing, for COM:
    - The New risk button is gated on the wrong permission.
    - The New risk dialog says the residual changes when a treatment is recorded. Nothing changes it.
    - A risk can be set to Accepted while over appetite.
    - Add treatment leaves Add enabled when accept is blocked.
    - The Cancelled treatment status isn't offered on screen.
    - The risk register's Owner column shows "You/Assigned", not names.
    - The Compliance page's "Not applicable" chip and the list it opens disagree.
    - The API accepts a gap on any assessment, not only on a shortfall.
    - Clearing a scope statement leaves the framework adopted.
    - The Decision status picker shows lowercase values.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
How to measure a company against the playbook: assessing a control (status, maturity, applicability), raising a gap from a shortfall and seeing it through, recording and treating a risk, and recording a decision. Checked against the released version.