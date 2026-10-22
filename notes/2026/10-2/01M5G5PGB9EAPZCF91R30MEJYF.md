---
id: 01M5G5PGB9EAPZCF91R30MEJYF
created: 2026-10-21T21:25:55.68964Z
updated: 2026-10-22T22:46:21.371992Z
type: task
title: Work through the assessment — for each threat, what makes it possible, what it would hit, the controls already in place and how they stand today, the score before and after them, the decision and who owns it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1225
sprint: s33gwqy
blocked_by:
- 01M5G5P7E9BNP0SXDD9P7E1973
comments:
- id: 01M5JWPFNRZD57P0R9VQJ8TFNW
  author: Steve Vine
  at: 2026-10-22T22:46:21.112522Z
  text: |-
    Done — merged in PR #1245 (no migration). Not yet on staging.

    - The assessment page's Threats card has one row per threat: the threat (with its category and any register risk it's about), inherent and residual scores in band colours, Over appetite, decision and owner. A bar above reads "N of M assessed".
    - Opening a row opens the threat over the page, with its own web address. It shows:
      - the risk: the threat, what makes it possible, the consequence, and optionally the register risk it is about;
      - what it would hit: technology assets, data assets and vendors;
      - the controls in place, each with the company's status today (Implemented, Partial, Not implemented, Not assessed) and its maturity;
      - inherent and residual likelihood × impact, picked from the rubric's wording, with the band, Over appetite and the appetite category;
      - the decision (Mitigate, Accept, Transfer or Avoid) with a rationale and an owner. Mitigate adds the treatments to propose (what, who, by when).
    - Accept over appetite is refused, with the register's own wording.
    - "Add threat" offers the catalogue (its controls come pre-filled), a register risk (its details are the starting point), or one written from scratch. A threat can be removed.
    - The first change moves a Draft to In progress. All of this stops once the assessment is submitted. People who can only view see it read-only.
    - Nothing reaches the register until the assessment is approved.

    My calls:
    - "Assessed" means scored before and after, with a decision and an owner. That is exactly what Submit will check, so a full bar means ready to submit.
    - Accept needs a residual score, so there is something to judge against appetite.
    - A register risk can appear only once per assessment.
    - Treatments are only for Mitigate. Changing the decision away from Mitigate clears them.
    - The owner picker offers the same people as the register, because the owner becomes the register risk's owner.
    - A control ruled out of scope for the company shows a fifth status, "Not applicable".
assignee: steve
label:
- feature
priority: high
task_status: review
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