---
id: 01M5G5T7ZM41X5NFN9PXGXQGK4
created: 2026-10-21T21:27:58.196643Z
updated: 2026-10-23T02:43:50.66638Z
type: task
title: PCI targeted risk analyses — for each PCI requirement that lets the company choose how often, a short analysis of what it protects, the threats, what drives likelihood and impact, and the frequency chosen and why; reviewed every 12 months and shown on the requirement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1238
sprint: s33gwqy
blocked_by:
- 01M5G5SVMMN6CMKVJ4FW66EQ4G
comments:
- id: 01M5KA9AZW16XRSYYPM536K0F4
  author: Steve Vine
  at: 2026-10-23T02:43:50.395957Z
  text: |-
    Done — merged in PR #1254 (migration 0565). Not yet on staging.

    - A company with PCI DSS in scope gets "Start a PCI targeted risk analysis" on Risk Assessments ▸ Assessments. "In scope" means the company has adopted it on Frameworks ▸ PCI DSS. Without PCI in scope the button isn't there, and starting one is refused.
    - You pick one of the nine requirements whose frequency the company sets: 5.2.3.1, 5.3.2.1, 7.2.5.1, 8.6.3, 9.5.1.2.1, 10.4.2.1, 11.3.1.1, 11.6.1 and 12.10.4.1. A requirement ruled out of scope, or with an analysis already under way, can't be picked. Then add the technology assets it protects, the assessors, the approver and why now.
    - The analysis follows the PCI SSC's order: the requirement and its text; what it protects; the threats; what makes them more or less likely, and worse or less bad; the frequency chosen and how it addresses the risk; and an optional likelihood × impact.
    - Submit asks for every part. Approval freezes it as for the other kinds, and nothing goes into the risk register.
    - An approved analysis falls due 12 months later. "PCI targeted risk analysis due: RA-n" appears in Actions from 60 days before. "Review this analysis" starts the next one with everything carried forward; once that's approved it replaces the old one.
    - On Frameworks ▸ PCI DSS ▸ Coverage, each of the nine shows its analysis (e.g. "RA-15 · Approved · every 6 months · next review 22 Oct 2027") or "Missing" with a "Start one" link.
    - Evidence of operation on RIM.2, and on the controls mapped to the nine requirements, shows "N of 9 requirements have a current analysis", with warnings for any missing or overdue.
    - The PDF prints the analysis in the PCI SSC's order.

    My calls:
    - 11.6.1 is in the list although its title doesn't say "targeted risk analysis": the standard's text says "weekly, or at the frequency in the entity's analysis". 12.3.1 is left out (it's the process itself), as is 12.3.2 (the customised approach, which is COM-1239).
    - One analysis at a time per requirement.
    - The analysis is written as text in the PCI SSC's order, not as threat rows. The score is optional.
    - The "requirement page" is the requirement's row on the Coverage tab, since that is the company's own view.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 83, Risk Assessments (ADR in COM-1219). PCI DSS 4.0.1 12.3.1 (in force since 2025-03-31).

**Chain:** on the chain — migration + API

## What people see

Only for a company with **PCI DSS** in scope.

- **Start a targeted risk analysis**: pick the PCI requirement from the ones that call for one — those whose frequency is "defined in the entity's targeted risk analysis" (5.2.3.1, 5.3.2.1, 7.2.5.1, 8.6.3, 9.5.1.2.1, 10.4.2.1, 11.3.1.1, 11.6.1, 12.10.4.1 — the exact list pinned from the CSV in the task).
- The analysis (PCI SSC's TRA guidance):
  - the **requirement** and its text;
  - the **assets** being protected (technology assets — the cardholder data environment);
  - the **threats** the requirement protects against;
  - the **factors** that make each threat more or less likely, or worse or less bad;
  - the **frequency** chosen (e.g. "every 6 months"), and **how it addresses the risk** — the justification;
  - optional likelihood × impact on the risk rubric.
- Same assessors, approver, submit/approve and freeze as the other kinds.
- **Due every 12 months** (PCI 12.3.1 requires at least annual review) — in Actions, and "Review this analysis" starts the next one from it.
- The PCI requirement's page in **Compliance/Frameworks** shows its current TRA (RA-15, approved, frequency chosen, next review) or **Missing**.
- Evidence of operation on **RIM.2** and on the requirement's mapped controls; PDF section in the PCI order.

## Notes (technical)

- requirement_ref on the assessment; applicability via company_framework_requirement (ADR 0057).

**Done when:** with PCI in scope, a TRA for 5.2.3.1 can be approved and shows on that requirement; it falls due 12 months later; with PCI out of scope the option isn't offered.