---
id: 01M5G5S03GQ8TXYKKQTJ49S14V
created: 2026-10-21T21:27:17.360798Z
updated: 2026-10-22T21:58:25.717006Z
type: task
title: Admin ▸ Rubrics ▸ Risk to people — the scale DPIAs and AI impact assessments use, because they measure harm to people rather than to the company (the ICO's remote–possible–probable × minimal–significant–severe by default)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1234
sprint: s33gwqy
blocked_by:
- 01M5G5RRCKKWRTJ2J47GWPDY6M
comments:
- id: 01M5JSYPXGWNR1Y8VY10GV71D1
  author: Steve Vine
  at: 2026-10-22T21:58:24.944272Z
  text: |-
    Done — merged in PR #1243 (migration 0520). Not yet on staging; the defaults load on the next deploy.

    - Admin ▸ Rubrics has a new Risk to people card, straight after the Risk rubric.
    - Likelihood of harm (Remote · Possible · Probable) and Severity of harm (Minimal · Significant · Severe) each have a name and descriptor that can be reworded.
    - The Overall risk grid is 3×3, laid out as the ICO draws it (Severe at the top, likelihood across). Each cell is a Low / Medium / High picker, and changing one saves it.
    - Kinds of harm lists the ten defaults. An admin can add, reword, retire or restore one.
    - A note on the card explains why this isn't the risk rubric: a High risk to people that remains after measures goes to the ICO for prior consultation, not to acceptance. An approved assessment keeps the version it was scored on.
    - History records every change, e.g. "Overall risk, Possible × Severe: High → Medium", with who made it and when. Changes also show in Activity.

    Checked: the default grid matches the ICO's own matrix cell for cell. The source is the ICO's "How do we do a DPIA?" page and its sample DPIA template; the ICO's own column labels are recorded in the rubrics brief.

    My calls:
    - The three ratings (Low / Medium / High) can't be renamed or added to, because High is what triggers prior consultation.
    - Grid cells can be set freely, cell by cell. Nothing stops a cell being set lower than its neighbour, since the ICO says an organisation may use its own method.
    - Kinds of harm are retired rather than deleted, so assessments that used them keep pointing at them.
    - The card sits after the Risk rubric so the two scales can be compared.
assignee: steve
label:
- feature
priority: high
task_status: review
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