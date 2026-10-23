---
id: 01M5G5R65K7MTR0CCH7Z9EDHFK
created: 2026-10-21T21:26:50.80323Z
updated: 2026-10-23T18:06:05.533783Z
type: task
title: Import threats from a spreadsheet into an assessment — and the Carbide assessment comes across that way, its 23 threats landing in a Moneypenny draft with their scores before controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1231
sprint: s33gwqy
blocked_by:
- 01M5G5QXBK6N7VHRQRFPX1JFJ0
comments:
- id: 01M5K4E2ZNCBRHD5KKVKQ9B9RG
  author: Steve Vine
  at: 2026-10-23T01:01:34.581793Z
  text: |-
    Done — merged in PR #1249 (no migration). Not yet on staging.

    - The Threats card of a Draft or In-progress assessment has "Import threats" for people who can manage assessments, with "Download the template" and "Choose CSV".
    - Choosing a file shows a preview of every row before anything is saved: whether it matches a catalogue threat, inherent and residual scores in band colours, decision, owner and controls. Problems show in red: a bad score, an unknown owner or one who can't own a risk, an unknown control, a missing name, a duplicate, Accept with no residual. Nothing is dropped quietly.
    - A problem row can be skipped (untick it) or fixed in place and checked again. "Import N threats" stays greyed out while any ticked row has a problem.
    - Scores accept 1–5, Very low…Very high, or the rubric's own words. Reduce reads as Mitigate. Owners are matched by email and controls by reference.
    - History gets one line, e.g. "imported 23 threats into RA-7 from a spreadsheet". A Draft stays a Draft.

    The Carbide file is attached to this task (see the top of the description). I kept it out of the code repo because it's company risk data with staff email addresses; the tests use a made-up file of the same shape.

    My calls on the Carbide file:
    - 23 threats, not 24: Carbide's "Theme: Financially Motivated Attacks (Meta)" is a reporting tag, which Carbide itself says not to score.
    - Carbide holds likelihood and impact separately, so they came across as inherent scores (Very low = 1 … Very high = 5). Residual is blank.
    - Reduce became Mitigate (19 threats). Carbide's 4 Accepts are left undecided, because Compass won't take an Accept without a residual score; each one's notes say "Carbide's treatment was Accept".
    - Descriptions use Moneypenny's own rewritten threat text rather than Carbide's template wording.
    - Carbide's control codes were matched to Compass controls by hand. Three had no clear match and stay in the notes: PRV12, PRV3 and HRS11. The full table is in the attached README.
    - None of the 23 is a fraud threat, so the assessors will need to add one, or say why fraud isn't relevant, before submitting.

    Still to do after the staging deploy: import the file into a Moneypenny draft on staging. The draft needs assessors and an approver, and owners must exist in Compass and be able to manage risks: steve.vine@, joe.newton@, chris.roughsedge@ and amy.jones@moneypenny.co.uk. I'll ask you who to name.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 83, Risk Assessments (ADR in COM-1219). Steve's decision: import the existing Carbide assessment so nothing is retyped.

**Chain:** on the chain — API

## Attached

- [carbide-moneypenny-risk-assessment.csv](attachments/2026/10/01M5G5R65K7MTR0CCH7Z9EDHFK/carbide-moneypenny-risk-assessment.csv) — Moneypenny's Carbide assessment "Risk Assessment Inherent Risk" in Compass's import format (23 threats, inherent scores only). Kept out of the code repo: it's company risk data.
- [carbide-import-README.md](attachments/2026/10/01M5G5R65K7MTR0CCH7Z9EDHFK/carbide-import-README.md) — source, date read, how scores/decisions/descriptions were carried, and the control mapping table.

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