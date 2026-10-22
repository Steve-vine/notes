---
id: 01M5G5S9H9TF9YFAQAAFSM2DX4
created: 2026-10-21T21:27:27.01751Z
updated: 2026-10-22T22:02:41.218487Z
type: task
title: DPIA screening — for each processing activity, answer "do we need a DPIA?" against GDPR's mandatory cases and the regulators' high-risk criteria, and record the decision and why, whichever way it goes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1235
sprint: s33gwqy
blocked_by:
- 01M5G5S03GQ8TXYKKQTJ49S14V
assignee: steve
label:
- feature
priority: high
task_status: active
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