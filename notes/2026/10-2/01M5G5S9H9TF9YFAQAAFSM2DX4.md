---
id: 01M5G5S9H9TF9YFAQAAFSM2DX4
created: 2026-10-21T21:27:27.01751Z
updated: 2026-10-23T00:20:37.107026Z
type: task
title: DPIA screening — for each processing activity, answer "do we need a DPIA?" against GDPR's mandatory cases and the regulators' high-risk criteria, and record the decision and why, whichever way it goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1235
sprint: s33gwqy
blocked_by:
- 01M5G5S03GQ8TXYKKQTJ49S14V
comments:
- id: 01M5K2325XA0HNWDZKCDAFSM5P
  author: Steve Vine
  at: 2026-10-23T00:20:36.15759Z
  text: |-
    Done — merged in PR #1246 (migration 0535). Not yet on staging.

    - Risk Assessments ▸ Assessments has "Start a DPIA screening" beside "Start an assessment". A data asset's page in Inventory has the same button on its new DPIA card. You pick the data asset (fixed if you start from its page), the assessors (you by default) and why now. There's no approver.
    - The screening shows the processing as Inventory holds it: purpose, lawful basis, role, data types, whose data, volume, recipients, transfers and retention.
    - It asks 17 yes/no questions, each with a line of guidance and an optional note: the three cases that always need a DPIA (Art. 35(3)), the EDPB's nine high-risk criteria and the ICO's five. The ICO is credited under the Open Government Licence.
    - Compass suggests the outcome as you answer:
      - DPIA required: any Art. 35(3) case, or two or more criteria;
      - recommended: one criterion;
      - otherwise not required.
      You confirm it or pick another. A reason is required whichever way it goes, and every question must be answered.
    - "Complete screening" freezes it as Completed. It keeps the data asset's details as they stood that day, and Compass's suggestion if you chose differently. A later screening of the same data asset supersedes it. Only one screening per data asset can be under way at a time.
    - Any Draft or In-progress assessment (of any kind) can be withdrawn with a reason. It is kept, marked Withdrawn, never deleted.
    - The data asset's DPIA card shows the latest screening (RA-n, outcome, date, reason), any screening under way and the latest DPIA, or "Not screened yet".
    - PDH.12's Evidence of operation shows the screenings completed in the last 12 months, and warns "N data assets have never been screened".

    My calls:
    - A screening's title defaults to "DPIA screening: DAT-3 · Name". Its details are set when it's started and can't be edited afterwards.
    - "Incident" isn't offered as a screening's reason for starting.
    - Unanswered questions count as "no" in the suggestion, but completing needs every question answered.
    - The question set is versioned, and each screening records which version it used.
    - "Start the DPIA" from a "DPIA required" screening comes with the DPIA itself (COM-1236). Until then the screening says "A DPIA is needed before this processing goes ahead."
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 83, Risk Assessments (ADR in COM-1219). GDPR Art. 35(1), 35(3), 35(4); ICO: record the screening even when no DPIA is done.

**Chain:** on the chain — migration + API

## What people see

**Start a DPIA screening** from Risk Assessments, or from a data asset's page in Inventory (a data asset is a processing activity — it already holds purpose, lawful basis, volume, transfers, recipients and retention).

The screening asks, with a line of guidance for each:
- **Always needs a DPIA (Art. 35(3)):** systematic and extensive profiling or automated decisions with legal or similarly significant effects; large-scale special-category or criminal-offence data; large-scale systematic monitoring of a public area.
- **High-risk criteria (EDPB / ICO):** evaluation or scoring; automated decisions with legal effect; systematic monitoring; sensitive or highly personal data; large scale; matching or combining datasets; vulnerable people (incl. children, employees); innovative technology (incl. AI); prevents people exercising a right or using a service — plus the ICO's own list (biometrics, genetic data, invisible processing, tracking, risk of physical harm).

**Outcome**, suggested from the answers and confirmed by the person: **DPIA required** (any Art. 35(3) case, or two or more criteria), **DPIA recommended** (one), **Not required**. Whatever the outcome, a **reason** is required and kept. "DPIA required" offers **Start the DPIA** with the data assets filled in.

- The data asset's page shows its latest screening and DPIA, with dates.
- A screening is a short assessment (`RA-n`, kind DPIA screening) — it can be withdrawn but not deleted, and has no approver.
- Evidence of operation on **PDH.12** for each screening.

## Notes (technical)

- Screening answers as a fixed question set (code-defined, versioned with the record); outcome rule shown, never forced.

**Done when:** screening a data asset that uses employee monitoring and new technology suggests DPIA required; a Not required screening can't be saved without a reason; the data asset shows its screening.