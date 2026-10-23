---
id: 01M5G5TR9GBF9HWAVSM2RW471Y
created: 2026-10-21T21:28:14.89649Z
updated: 2026-10-23T04:14:40.315913Z
type: task
title: AI system impact assessments — for each AI system, what it's for and how it could be misused, who it affects, the harms and benefits to people and society, what reduces them, and sign-off; repeated on material change
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1240
sprint: s33gwqy
blocked_by:
- 01M5G5TF84VA6GF9YXR6GG1265
comments:
- id: 01M5KFFN3PRTKDE67R98250DC1
  author: Steve Vine
  at: 2026-10-23T04:14:40.246701Z
  text: |-
    Done — merged in PR #1258 (migration 0585). Not yet on staging.

    - Risk Assessments has "Start an AI impact assessment". A technology asset marked AI system has an AI impact assessment card showing the current one, when the next is due and any under way, with a start button (the asset filled in). Only assets marked AI system are offered.
    - In place of Threats, the page has:
      - The system: Inventory's details for each system, the vendor or model behind it, intended purpose, reasonably foreseeable misuse, where and by whom it's used, the data it uses, and the level of human oversight;
      - Who it affects: individuals, groups, vulnerable groups (you have to say which), society, employees, customers;
      - Impacts: area (the nine areas), positive or negative, who it reaches, likelihood × severity on the Risk to people scale;
      - Measures: for each negative impact, what reduces it, the residual, and an owner and due date if still to do;
      - Links: whether it uses personal data and, if so, its DPIA or screening ("Start a DPIA screening" if there isn't one), and the AI risk assessment.
    - With a High residual impact, the approver must record "Proceed" or "Do not proceed" and why before approving. Only the approver can record it.
    - Once approved it is frozen with the systems' details of that day, and the next one falls due on the AI cadence. Measures still to do become follow-ups in their owners' Actions. Nothing goes into the risk register.
    - Editing the system's purpose or vendor in Inventory raises "AI system changed — reassess RA-n" for the assessors. "Reassess" starts the next one with everything carried forward.
    - The PDF has its own sections. Evidence of operation is on AIG.6 and AIG.7 (with a warning for any AI system without one), and on AIG.5 for risk assessments whose scope names ISO/IEC 42001. The approved PDFs support those controls in Audit ▸ Evidence.

    My calls:
    - Measures still to do become follow-ups, not register treatments, following ADR call 21.
    - Every impact, benefits included, is scored. Only negative impacts have measures and a residual.
    - "Uses personal data?" is an explicit yes/no. If yes, Submit needs a linked DPIA or DPIA screening.
    - The decision to proceed counts only for the current submission; after a send-back it has to be recorded again.
    - A new approval replaces an earlier one only if it covers all of that one's systems.
    - Reassess must name the assessment it follows, because the last approved one may be for a different system.
assignee: steve
label:
- feature
priority: high
task_status: review
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