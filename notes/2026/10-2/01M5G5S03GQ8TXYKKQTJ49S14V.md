---
id: 01M5G5S03GQ8TXYKKQTJ49S14V
created: 2026-10-21T21:27:17.360798Z
updated: 2026-10-21T21:29:12.048822Z
type: task
title: Admin ▸ Rubrics ▸ Risk to people — the scale DPIAs and AI impact assessments use, because they measure harm to people rather than to the company (the ICO's remote–possible–probable × minimal–significant–severe by default)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1234
sprint: s33gwqy
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 83, Risk Assessments (ADR in COM-1219). GDPR Art. 35(7)(c) "risks to the rights and freedoms of data subjects"; ISO 42001 6.1.4.

**Chain:** on the chain — migration + API

## What people see

**Admin ▸ Rubrics ▸ Risk to people** (Manage rubrics), versioned with history:
- **Likelihood of harm:** Remote · Possible · Probable — name and descriptor each.
- **Severity of harm:** Minimal · Significant · Severe — name and descriptor each (e.g. Severe: "significant or irreversible consequences — financial loss, discrimination, physical harm, loss of liberty").
- **Overall risk** grid: each likelihood × severity → **Low / Medium / High** (ICO defaults: Remote×Minimal Low … Probable×Severe High), editable cell by cell.
- **Kinds of harm** list used to tag each risk: e.g. loss of control of personal data, discrimination, identity theft or fraud, financial loss, reputational damage, physical harm, distress, loss of confidentiality, inability to exercise rights, unfairness of automated decisions.

A note on the page explains why this isn't the 5×5 risk rubric: it's harm to people, and a High that remains after measures goes to the ICO, not to acceptance.

## Notes (technical)

- Same shape as the other rubrics (revisions; frozen by id on approval). Seed via importer. The ICO's DPIA guidance and template are Open Government Licence.

**Done when:** the tab shows the defaults; a grid cell can be changed and history records it.