---
id: 01M61ZE32CHKVH2PC0F8S7B6KR
created: 2026-10-28T19:22:48.268462Z
updated: 2026-10-28T19:24:39.982259Z
type: task
title: 'Business impact analysis — a new kind in Risk Assessments: the company''s business functions, how badly each is hurt over time, how long it can be down and its recovery targets, approved and due again like the others'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1408
sprint: stqs5r1
blocked_by:
- 01M61ZDMP62Z779B1A1HDHRQX9
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 95, Business Continuity (ADR 0131, COM-1407).

## What people see

- **Risk Assessments ▸ Start** offers **Business impact analysis** beside Risk assessment, DPIA, PCI analysis and AI impact assessment. Scope: company-wide or chosen functions; assessors and approver as the others.
- **Business functions** — the BIA's rows. Add one: name, owner (a person), what it does, busiest times (free text, e.g. "month end").
- **Impact over time** — per function, a grid: rows financial, operational, customer, legal/regulatory, reputational; columns 4 hours, 1 day, 3 days, 1 week, 1 month. Each cell is the risk rubric's impact level (its words, colours as the heat-map). A cell can't be lower than the one to its left ("it doesn't get better by waiting").
- **Maximum tolerable period of disruption** — suggested as the first column where any row reaches the top level; the person can change it with a reason.
- **RTO and RPO** for the function, in hours or days; refused if RTO is longer than the tolerable period. **Minimum service** — free text for what "back" means (e.g. "phones answered, no call recording").
- **Submit → approve** exactly as the other kinds; approved, it shows Next due (Settings ▸ **Business impact analysis**, 12 months by default) and Superseded by the next one.
- **Start the next one** pre-fills every function, impact grid and target.
- The **PDF** of an approved BIA in the house style, like the others.
- **Evidence of operation:** an approved BIA shows on BCR.13 (business impact analysis) and BCR.14 (RTO/RPO defined) for that company.

## Who can do what

The existing Risk Assessments permissions — start, work as assessor, approve (*Approve risk assessments and accept risks*); nobody approves their own.

## Notes (technical)

- `RiskAssessmentKind.business_impact_analysis`; function rows and impact cells as their own tables (like DPIA risks / AI impact items), frozen at approval like the others.
- Settings gains `bia_cadence_months`.
- Dependencies come in COM-1409 — keep the function row ready for them.
- Evidence of operation: a risk-assessments source for BCR.13 / BCR.14 — look the controls up by `CoreControl.key`, not the displayed ref (COM-1062).

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve starts a BIA with two functions, fills the grids and targets, a second person approves it, and Start the next one carries it forward.