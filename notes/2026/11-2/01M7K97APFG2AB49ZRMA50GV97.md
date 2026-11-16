---
id: 01M7K97APFG2AB49ZRMA50GV97
created: 2026-11-16T22:56:39.631112Z
updated: 2026-11-16T22:57:08.037279Z
type: task
title: 'Risk assessment IDs: RA-n becomes RAS-n'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1890
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: backlog
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