---
id: 01M5G5QE2SN0S49ZEZ081JC8DR
created: 2026-10-21T21:26:26.137351Z
updated: 2026-10-23T04:34:43.877956Z
type: task
title: 'The Overview — what''s current, what''s due and what''s missing for the company: its risk assessment, a DPIA screening for each processing activity, a targeted risk analysis for each PCI requirement that needs one, an impact assessment for each AI system'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1228
sprint: s33gwqy
blocked_by:
- 01M5G5TR9GBF9HWAVSM2RW471Y
comments:
- id: 01M5KGMCCTHMGGERSNTXCC6TC8
  author: Steve Vine
  at: 2026-10-23T04:34:43.738203Z
  text: |-
    Done — merged in PR #1259 (no migration). Not yet on staging.

    Risk Assessments ▸ Overview has one card per kind, with figures across the top and a list below. Each line opens the assessment, or the place to start one.
    - Risk assessment: each current approved one, with who approved it and when, its next due date, and whether it's Current, Due (within 60 days) or Overdue. Ones in progress are listed too. "None" shows in red if the company has never approved one. It also shows the current one's threats by residual band (Low/Medium/High/Critical) and how many are over appetite.
    - DPIAs: one line per data asset still in use. Figures: Screened, Not screened, DPIA required (no approved DPIA yet), DPIA approved, Awaiting the ICO, and Due for review (including when the processing has changed since approval). A data asset never screened shows as "Not screened" and opens its DPIA card in Inventory.
    - PCI targeted risk analyses (only when PCI DSS is in scope): each of the nine requirements, Current / Due / Overdue / Missing.
    - PCI customised approach (only when PCI is in scope and a requirement is marked): each marked requirement.
    - AI impact assessments: each technology asset marked AI system, Assessed / Due / Overdue / Missing, plus "System changed" when its purpose or vendor was edited after approval.
    - Anyone who can view risk assessments sees it.

    My calls:
    - Clicking a figure narrows that card's own list, rather than opening the Assessments list as the task says. The Assessments list can only filter by kind and status, and most of these figures (Not screened, Missing) aren't assessments at all, so the counts wouldn't match. Each card has a "See them in Assessments" link filtered by kind instead. Please confirm that's fine.
    - "Due" means within 60 days of the next due date, the same window Actions uses.
    - "Awaiting the ICO" means sent with no reply yet, while the ICO's deadline hasn't passed.
    - PCI requirements ruled out of scope are listed but not counted. Retired data assets and AI systems are left out.
assignee: steve
label:
- feature
priority: medium
task_status: review
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