---
id: 01M5G5T7ZM41X5NFN9PXGXQGK4
created: 2026-10-21T21:27:58.196643Z
updated: 2026-10-23T01:21:46.355704Z
type: task
title: PCI targeted risk analyses — for each PCI requirement that lets the company choose how often, a short analysis of what it protects, the threats, what drives likelihood and impact, and the frequency chosen and why; reviewed every 12 months and shown on the requirement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1238
sprint: s33gwqy
blocked_by:
- 01M5G5SVMMN6CMKVJ4FW66EQ4G
assignee: steve
label:
- feature
priority: high
task_status: active
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