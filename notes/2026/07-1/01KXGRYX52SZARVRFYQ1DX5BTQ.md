---
id: 01KXGRYX52SZARVRFYQ1DX5BTQ
created: 2026-07-14T16:56:59.298745636Z
updated: 2026-07-19T21:30:29.576424687Z
type: task
title: 'Dashboard: represent unassessed compliance as null / "not assessed", not 0%'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 28
sprint: sz3kacg
comments:
- id: 01KXGRZ7RD14ME3ZKPGEYNTS14
  author: Steve Vine
  at: 2026-07-14T16:57:10.157363997Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-15 21:11 UTC]
    PR up for review: https://github.com/Steve-vine/compass/pull/19 — CI green (backend, frontend, secret-scan, deps-scan, sast).

    Implemented the agreed **Option B** (coverage metric, compliance over assessed):
    - **Compliance** = implemented ÷ assessed-applicable; **null → "Not assessed"** until something in scope is assessed.
    - **Coverage** = assessed-applicable ÷ applicable (how much of the in-scope library has been assessed).
    - Fresh company → compliance "Not assessed" / coverage 0%; 2-of-5 assessed & implemented → coverage 40% / compliance 100%. Not-applicable controls affect neither.

    UI: a Coverage summary card + per-domain Coverage column (neutral progress bar), and compliance shows "Not assessed" (grey) instead of 0%.

    Verification: backend ruff/mypy(src) clean, 27 unit + 41 integration pass; frontend eslint/tsc/prettier clean, 13 vitest pass. Branched off `main` (no stacking).
assignee: steve
task_status: done
priority: medium
---
Follow-up from <issue id="49df18ad-8140-4f5b-8332-5a0e3137abd5" href="https://linear.app/stevevine/issue/DEV-404/compliance-and-maturity-dashboard">DEV-404</issue> (compliance & maturity dashboard).

## Context

The dashboard posture API currently computes `compliance_percent = implemented ÷ applicable`, where every applicable-but-unassessed control counts as a shortfall. Consequence: a company with no assessments yet reads **0% compliance** (red), not "no data". This was a deliberate "know where we stand penalises the unassessed" choice, but it can mislead — 0% reads as "actively failing" rather than "not started".

## Decision to make

Switch the representation so an unmeasured posture is distinct from a measured-but-failing one:

* When a domain (or the company overall) has **no recorded assessments**, return `compliance_percent = null` and surface it in the UI as **"Not assessed"** (neutral/grey), not 0%.
* Keep 0% only for the genuine case where controls *are* assessed but none are implemented.

Open question for the denominator: should `applicable` stay as "all applicable controls" (so partial assessment shows a low %), or should compliance be computed only over **assessed** applicable controls with a separate "coverage %" (assessed ÷ applicable)? Worth deciding here — a coverage metric may be the cleaner answer than overloading compliance.

## Scope

* Backend: `api/v1/dashboard.py` rollup + `DomainPosture` / `DashboardOut` semantics; update `test_dashboard.py` (the empty-company test currently asserts `0`).
* Frontend: `DashboardPage` + `dashboard/posture.ts` colour bands to handle the null / "not assessed" state.

Refs: ADR 0011, 0017. Origin: PR #18 review note.

---
*Migrated from Linear [DEV-427](https://linear.app/stevevine/issue/DEV-427/dashboard-represent-unassessed-compliance-as-null-not-assessed-not) · created 2026-06-15 · completed 2026-06-15*  
*Related to (Linear): DEV-404*