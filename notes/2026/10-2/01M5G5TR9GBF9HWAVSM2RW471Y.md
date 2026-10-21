---
id: 01M5G5TR9GBF9HWAVSM2RW471Y
created: 2026-10-21T21:28:14.89649Z
updated: 2026-10-21T21:29:17.433578Z
type: task
title: AI system impact assessments — for each AI system, what it's for and how it could be misused, who it affects, the harms and benefits to people and society, what reduces them, and sign-off; repeated on material change
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1240
sprint: s33gwqy
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 83, Risk Assessments (ADR in COM-1219). ISO 42001 6.1.4, 8.4, A.5.2–A.5.5 (and ISO/IEC 42005's structure). The company's **AI risk** assessment (42001 6.1.2) is an ordinary risk assessment scoped to AI using the catalogue's AI threats; this is the separate **impact** assessment.

**Chain:** on the chain — migration + API

## What people see

**Start an AI impact assessment** from Risk Assessments, or from a technology asset marked **AI system** in Inventory.

Cards in place of Threats:
1. **The system** — the AI system(s) (technology assets marked AI system), the vendor or model behind it, **intended purpose**, **reasonably foreseeable misuse**, where it's used and by whom, the data it uses (data assets), the level of human oversight.
2. **Who it affects** — individuals, groups (incl. vulnerable groups), society; employees and customers.
3. **Impacts** — each: area (fairness and discrimination · privacy · safety and physical harm · psychological · economic · human rights · transparency and explainability · accountability and human oversight · environmental), positive or negative, who it reaches, likelihood × severity on the **Risk to people** scale.
4. **Measures** — for each negative impact: what reduces it, residual on the same scale, owner and due date (a treatment if it needs doing).
5. **Links** — the DPIA when personal data is involved (or "Start a DPIA screening"), and the AI risk assessment.
- Same assessors, approver, submit/approve and freeze. A High residual impact needs a recorded **decision to proceed or not** from the approver.
- Due on the AI cadence, and **Reassess** on material change: editing the AI system's purpose or vendor in Inventory raises "AI system changed — reassess RA-20" in Actions.
- Evidence of operation on **AIG.6** and **AIG.7** (and **AIG.5** for AI risk assessments); PDF section.

**Done when:** an impact assessment for an asset marked AI system can be approved; it links to a DPIA; changing the asset's purpose raises a reassess to-do.