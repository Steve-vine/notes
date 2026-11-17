---
id: 01M7K97APFG2AB49ZRMA50GV97
created: 2026-11-16T22:56:39.631112Z
updated: 2026-11-17T01:12:12.077083Z
type: task
title: 'Risk assessment IDs: RA-n becomes RAS-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1890
sprint: s7nqsy0
comments:
- id: 01M7KGZFSG04P74WBTPQ1G22XP
  author: Steve Vine
  at: 2026-11-17T01:12:11.312522Z
  text: |-
    Done — PR #1880, merged c182b350.
    Every risk assessment (threat assessments, BIAs, DPIAs, AI impact and PCI analyses) now reads RAS-n with its old number. That covers the Risk Assessments list and pages, the risks an assessment raised ("From RAS-7…"), Continuity's approved BIA, the plan's "Done by RAS-7", Audit ▸ Evidence, the SoA, actions and mail, PDFs from now on, and Polaris. New assessments carry on as RAS-(next).
    RA-n still finds the assessment: given to Polaris, or in the address. /risk-assessments/RA-9 opens it and moves to its own address.
    From this task on, any page opened by an ID keeps the rest of the link (?threat=…, ?clause=…) when it moves to the record's own address. That applies to risks, gaps, decisions, contract reviews, risk assessments and workflows.
    Text written before the change keeps its wording. ADR 0157 lists RAS.
    Assumptions: no migration (one sequence across every company and kind). Risk assessments aren't part of the main search, so "search" here is Polaris and the address.
    To check on staging: assessments read RAS-n; open /risk-assessments/RA-<n>, including as an assessor without the module's permissions. Staging check: all 3 numbers are unique. Before release, run the same check on a copy of production.
assignee: steve
priority: medium
task_status: review
---
From Steve's testing of round 2 (staging 43d03f09): every reference should be three letters, a dash and a number. Risk assessments (threat assessments, BIAs, DPIAs, AI impact and PCI analyses) are **RA-n** today.

**Behaviour.** This works the same way as COM-1887 (risks and gaps) and COM-1886 (checks):
- RA-9 becomes **RAS-9**, keeping its number, and the counter carries on.
- The new form shows everywhere an ID is shown:
  - the Risk Assessments list and pages;
  - the risks an assessment raised;
  - Continuity (where the approved BIA is named);
  - exports and printed assessments from now on;
  - Polaris's risk-assessment tools, answers and MCP instructions.
- Old RA-n IDs still find the assessment in the address, in search and through Polaris, and old links redirect.
- Text written before the change keeps its wording.

**Done when**
- On staging, every risk assessment reads RAS-n with its old number, and RA-n still resolves.
- New assessments are numbered RAS-(next).
- The three-letter reference ADR (from COM-1887) lists RAS.
- The switch-over is checked on a copy of production data before release.
- Tests cover formatting, old IDs resolving, a new assessment, and the e2e selectors.

**Where** (for the builder): models/risk_assessment.py (`RISK_ASSESSMENT_REF_PREFIX`), the route or search that resolves an ID, frontend risk-assessment pages, Continuity, assistant/tools (risk_assessments) and MCP instructions. Built after COM-1887.