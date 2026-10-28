---
id: 01M61ZDMP62Z779B1A1HDHRQX9
created: 2026-10-28T19:22:33.542266Z
updated: 2026-10-28T19:22:33.542266Z
type: task
title: 'ADR: business continuity — a business impact analysis sets how fast each function must come back, the targets flow to the systems it needs, runbooks say what they recover, and SAP exercises prove they work'
label: brief
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1407
---
Sprint 95, Business Continuity. ADR 0131. Builds on ADR 0115 (SAP), ADR 0123 (Risk Assessments), ADR 0072 (Inventory), ADR 0032 (content reviews).

Steve, 2026-10-28:
- the original feature list had "BC/DR exercise — runbook tests with evidence, on the content-review cadence machinery";
- SAP covers the schedule and the evidence; plan the missing parts, **including a business impact analysis**.

## What's there already (unchanged)

SAP's standard plan has a "disaster recovery / continuity exercise"; it repeats, reminds its owner, keeps evidence, freezes when done, raises findings, is signed off and exported, and shows as Evidence of operation on the BCR controls. Systems in Inventory already carry criticality, RTO, RPO and dependencies. Runbooks are a content type in the shared Playbook.

## What the ADR decides

1. **Business impact analysis (BIA)** — a new kind in Risk Assessments, beside DPIA, PCI analysis and AI impact assessment, so it gets their assessors, approver, cadence (Settings, 12 months by default), Next due and **Start the next one**.
   - Its rows are the company's **business functions** (e.g. Payroll, Customer support line). Each has an owner, what it does, and:
     - **impact over time** — for each of a fixed set of categories (financial, operational, customer, legal/regulatory, reputational), the impact on the risk rubric's impact scale at 4 hours, 1 day, 3 days, 1 week and 1 month;
     - **maximum tolerable period of disruption** — suggested as the first point any impact reaches the rubric's top level, editable with a reason;
     - **RTO** and **RPO** for the function, no longer than the tolerable period;
     - **what it depends on** — systems (technology assets), data assets, vendors, plus free-text people and sites.
   - The function list carries into the next BIA.
2. **Targets flow to systems.** From the latest approved BIA, each system gets **Needed back within** (the shortest RTO of the functions that depend on it, directly or through system dependencies) and **Data loss tolerated** (the shortest RPO). The system's own RTO/RPO stay what IT says it can do; where they're longer than needed, or missing on a needed system, the system is flagged. Compass never overwrites them.
3. **Runbooks say what they recover.** A runbook links to systems, per company (the runbook is shared; the systems are the company's). A system shows its recovery runbook(s).
4. **An SAP exercise says what it tested and how it went.** A Testing entry can name the **runbooks** it exercised (and through them the systems), and its **kind of exercise**: tabletop, walkthrough, simulation, full failover. Done records a **result** — passed, partly, failed — and, per system, **how long recovery took** and **how much data was lost**, against the targets.
5. **A runbook carries its test record.** Last tested, how, result, next test due (from SAP), per company; **never tested** is said plainly. A partly or failed result sends the runbook for **review** (the content-review machinery) with the exercise as the reason.
6. **Posture ▸ Continuity** — one view per company: function → systems → needed vs stated RTO/RPO → runbook → last test and achieved times, with the gaps flagged.

## My calls (for Steve to overturn)

- The BIA is in Risk Assessments, not a module of its own — it's an assessment with an approver and a cadence, which that module already does well.
- Impact categories and time points are fixed in this sprint (like SAP's fixed types) so the Continuity view can compare across functions; adjustable later if asked.
- Impact uses the risk rubric's impact scale rather than a new one.
- Dependencies on people and sites are free text — Compass has no register of either.
- A function's targets reach systems only from an **approved** BIA.

## The sprint

ADR → BIA (functions, impact, targets, approval) → BIA dependencies and targets on systems → runbooks recover systems → exercises name runbooks and record results → runbook test record and review → Continuity view → Polaris.

**Chain:** independent (documents only).

**Done when:** ADR 0131 is merged.