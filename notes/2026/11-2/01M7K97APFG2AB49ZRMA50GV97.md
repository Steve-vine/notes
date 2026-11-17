---
id: 01M7K97APFG2AB49ZRMA50GV97
created: 2026-11-16T22:56:39.631112Z
updated: 2026-11-17T20:31:42.336192Z
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
- id: 01M7MGYZV5P52E6PT0WCAYPPC0
  author: Steve Vine
  at: 2026-11-17T10:31:09.413382Z
  text: |-
    Pre-UAT on staging 44d15b9a — Passed
    - Every risk assessment reads RAS-n with its old number: Passed. As E2E Admin A, the Risk Assessments list shows RAS-4 and RAS-3, and the assessment page's header and trail read "RAS-3 · E2E pre-UAT sprint 80 DPIA". The portal page reads RAS-3 for its assessor, E2E Asset Owner. Polaris's list_assessments and get_assessment answer RAS-n. Activity lines written before the change still say "RA-3", as intended. E2E Test Company has no approved BIA and no risks raised from an assessment, so Continuity and "From RAS-n" had nothing to show.
    - RA-n still resolves: Passed.
      - Admin A: /risk-assessments/RA-3 and /risk-assessments/RA-4 open RAS-3 and RAS-4 and move to their own addresses. /risk-assessments/RA-4?threat=xyz keeps "?threat=xyz".
      - E2E Asset Owner (assessor of RAS-3, portal only): /portal/risk-assessments/RA-3 opens RAS-3.
      - Polaris: get_assessment "RA-3" answers RAS-3.
      - The main search finds no assessment by RA-3 or RAS-3: assessments were never part of search, as the Done comment says.
    - New assessments are RAS-(next): Passed. Admin A started "E2E pre-UAT COM-1890 assessment", a risk assessment, which became RAS-4. Its activity reads "created risk assessment RAS-4 · …".
    - ADR 0157 lists RAS: Passed.
    - Switch-over check on a copy of production: Couldn't check on staging, because it's a step before release.
    - Tests: PR #1880 changes 7 test files. No app/e2e selector reads an assessment ID.
    - Small leftover, not a Done-when point: several of Polaris's risk-assessment tool descriptions still say "RA-n". That's in assistant/tools/risk_assessments.py (list_assessments "lists them: RA-n, title…", the start-next and reassess fields) and risk_assessments_ai.py (the DPIA and AI risk-assessment fields). Polaris's answers do use RAS-n.
    - Observation: Asset Owner, who is portal only, opening the staff address /risk-assessments/RA-3 is sent to /portal/vendors, not to the assessment. /portal/risk-assessments/RA-3 works.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1890/
    Left behind: RAS-4 "E2E pre-UAT COM-1890 assessment", now Withdrawn.
assignee: steve
label: null
priority: medium
task_status: done
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