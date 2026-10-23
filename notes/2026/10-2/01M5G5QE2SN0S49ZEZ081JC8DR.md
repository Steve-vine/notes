---
id: 01M5G5QE2SN0S49ZEZ081JC8DR
created: 2026-10-21T21:26:26.137351Z
updated: 2026-10-23T03:22:34.240988Z
type: task
title: 'The Overview — what''s current, what''s due and what''s missing for the company: its risk assessment, a DPIA screening for each processing activity, a targeted risk analysis for each PCI requirement that needs one, an impact assessment for each AI system'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1228
sprint: s33gwqy
blocked_by:
- 01M5G5TR9GBF9HWAVSM2RW471Y
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 83, Risk Assessments (ADR in COM-1219). Built after the four kinds exist so it can count all of them.

**Chain:** on the chain — API

## What people see

**Risk Assessments ▸ Overview**, one card per kind, each with figures and a list that opens the item:

- **Risk assessment:** the current approved one (RA-7, approved 3 Mar, by …), next due, any in progress; **None** in red if the company has never approved one. Residual bands of its threats (Low/Medium/High/Critical) and how many are over appetite.
- **DPIAs:** processing activities (data assets) — screened, not screened, DPIA required, DPIA approved, awaiting the ICO, due for review.
- **PCI targeted risk analyses** (only when PCI DSS is in scope for the company): each requirement that needs one — current, due, missing.
- **AI impact assessments:** each technology asset marked AI system — assessed, due, missing.

Figures open the Assessments list filtered to match.

## Notes (technical)

- `GET /risk-assessments/overview`; reuses the requirement-applicability data for PCI scope.

**Done when:** a company with no approved risk assessment sees None; a data asset with no screening shows under "not screened"; with PCI out of scope the PCI card doesn't show.