---
id: 01M5G5R65K7MTR0CCH7Z9EDHFK
created: 2026-10-21T21:26:50.80323Z
updated: 2026-10-22T22:52:05.280175Z
type: task
title: Import threats from a spreadsheet into an assessment — and the Carbide assessment comes across that way, its 23 threats landing in a Moneypenny draft with their scores before controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1231
sprint: s33gwqy
blocked_by:
- 01M5G5QXBK6N7VHRQRFPX1JFJ0
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 83, Risk Assessments (ADR in COM-1219). Steve's decision: import the existing Carbide assessment so nothing is retyped.

**Chain:** on the chain — API

## What people see

On a Draft or In-progress assessment: **Import threats** (Manage).
- **Download the template** (CSV): threat, category, description, what makes it possible, consequence, inherent likelihood, inherent impact, residual likelihood, residual impact, decision, rationale, owner email, controls (core control refs), notes.
- Likelihood/impact accept 1–5 or the words — Very low/Low/Moderate/High/Very high (Carbide's) or the rubric's own names; decisions accept Mitigate/Reduce, Accept, Transfer, Avoid.
- **Preview** before anything is saved: each row, what it maps to, and problems (unknown owner, unknown control, bad score) — rows with problems can be skipped or fixed in the preview.
- Imported rows are ordinary threats in the assessment; a threat matching a catalogue name links to it.

**The Carbide assessment:**
- I export "Risk Assessment Inherent Risk" (Moneypenny org in Carbide, 23 threats, status draft there) into the template: likelihood and impact as **inherent** (residual left blank for the assessors); Reduce → Mitigate; owners by email; mitigation and treatment text into rationale and notes.
- Carbide's own control codes (ECM4, IAM1, BCIM1…) are matched to Compass core controls by hand where the match is clear; the rest stay in each threat's notes.
- The file is attached to this task; imported on staging as a Draft in Moneypenny for Steve to check, and on production after release when Steve says.

## Notes (technical)

- `POST /risk-assessments/{id}/import` with a dry-run preview; CSV only, size-limited; quoted commas handled (csv module, not split).
- Read Carbide via its MCP read tools only; no writes to Carbide.

**Done when:** the template round-trips; a bad row is shown in the preview and skipped; the Carbide file imports 23 threats into a Moneypenny draft on staging.