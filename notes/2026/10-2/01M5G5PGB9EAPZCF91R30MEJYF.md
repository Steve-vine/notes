---
id: 01M5G5PGB9EAPZCF91R30MEJYF
created: 2026-10-21T21:25:55.68964Z
updated: 2026-10-21T21:29:30.206283Z
type: task
title: Work through the assessment — for each threat, what makes it possible, what it would hit, the controls already in place and how they stand today, the score before and after them, the decision and who owns it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1225
sprint: s33gwqy
blocked_by:
- 01M5G5P7E9BNP0SXDD9P7E1973
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 83, Risk Assessments (ADR in COM-1219).

**Chain:** on the chain — migration + API

## What people see

The assessment page's **Threats** card: one row per threat — threat, inherent, residual (band colours), decision, owner, and a progress bar "14 of 23 assessed". Opening a row, assessors fill in:

- **The risk:** the threat (from the catalogue or written), **what makes it possible** (vulnerability), **consequence**; or pick an **existing risk from the register** this threat is about.
- **What it would hit:** technology assets, data assets, vendors (from Inventory and Vendors).
- **Controls in place:** core controls (pre-filled from the catalogue), each showing the company's **current status** — Implemented, Partial, Not implemented, Not assessed — and maturity. *"Review the controls already in place"*: an assessor sees at a glance that a control relied on is Not implemented.
- **Inherent** likelihood × impact and **residual** likelihood × impact on the risk rubric's scales, with the descriptors on hover; band and **Over appetite** shown.
- **Decision:** Mitigate · Accept · Transfer · Avoid, with a rationale; **owner**; for Mitigate, the treatment to add (description, owner, due date). Accept is refused over appetite, as in the register.
- **Category** (from appetite categories).
- Rows can be added, edited and removed until submitted.

Nothing is written to the register yet — that happens on approval.

## Notes (technical)

- risk_assessment_item: assessment, catalogue threat (nullable), risk_id (nullable, existing risk), text fields, scores, decision, owner, category; item↔control/container/data asset/vendor links; proposed treatments.
- Control status from the company's assessments (`models/assessment.py`).

**Done when:** an assessor scores every threat in RA-1, links controls (seeing their status) and assets, and records decisions and owners; an Accept over appetite is refused.