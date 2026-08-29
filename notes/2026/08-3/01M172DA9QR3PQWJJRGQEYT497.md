---
id: 01M172DA9QR3PQWJJRGQEYT497
created: 2026-08-29T15:32:31.671094Z
updated: 2026-08-29T18:47:56.683633Z
type: task
title: 'Rubrics tab: new section descriptions, and rename Vendor risk tiers'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 517
sprint: s2fcksg
blocked_by:
- 01M16ZT8Y3BSRY5AHC9T3T7HA9
comments:
- id: 01M17DK4CJAS6ZC1FW3B059CJZ
  author: Steve Vine
  at: 2026-08-29T18:47:56.562096Z
  text: |-
    Done — PR #521, merged to main as 63b8fc5.

    All eleven descriptions replaced with your copy, and Vendor risk tiers renamed to Third party risk tiers.

    The three things the ticket flagged:
    - "sevices" written as services.
    - The two lines without a closing full stop given one, so the tab stays consistent.
    - The versioning note — you confirmed: use the copy exactly as written. So the "your wording is kept in the history" and "this wording is what a colleague reads when classifying" sentences go with the rest. Each section keeps its History control, which is where that fact stays discoverable.

    How far the rename went: AdminPage title, the RiskTierRubricSection docstring, and the approval-rule condition label in vendors/RuleEditor.tsx — "Vendor risk tier at or above…" → "Third party risk tier at or above…". That last one is user-visible too and would have read oddly still saying Vendor; ApprovalAreas.test.tsx asserts the exact string and moved with it.

    Left alone: the backend comment at schemas.py:2740. It heads the VendorRiskTier schemas, so renaming a comment while the type keeps its name would read worse, not better. min_risk_tier is unaffected either way.

    One test needed repointing — DataRubricSection.test.tsx asserted the old data-entities description (/whose rules apply/i). It now asserts the new copy. Added a test pinning the renamed card.

    Ready for smoke test on staging.
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: review
---
Replace the description under each rubric section with the wording below, and rename one section. Copy supplied by Steve, 2026-08-29.

## One rename

`pages/AdminPage.tsx:50` — **"Vendor risk tiers" → "Third party risk tiers"**.

Check the other places the old name appears before deciding how far the rename goes:
- `admin/RiskTierRubricSection.tsx:9` — file docstring, "The Vendor risk tier rubric".
- `vendors/RuleEditor.tsx:54` — approval-rule condition label *"Vendor risk tier at or above…"*, asserted in `vendors/ApprovalAreas.test.tsx:121`.
- `api/v1/schemas.py:2740` — backend comment only.

The AdminPage title is the one Steve asked for. The RuleEditor label is user-visible too and would read oddly if it kept saying "Vendor" — worth changing with it, remembering the test asserts the exact string. The API field name `min_risk_tier` is unaffected either way.

## New copy

| Section | New description |
|---|---|
| **Maturity rubric** | The scale used when assessing control maturity. |
| **Risk rubric ▸ Likelihood** | The descriptors used to score each risk likelihood. |
| **Risk rubric ▸ Impact** | The descriptors used to score each risk impact. |
| **Risk rubric ▸ Severity bands** | Score (1–25) thresholds for each band. |
| **Risk rubric ▸ Risk appetite** | Maximum tolerable residual score per category; residual above appetite must be treated. |
| **Data rubric ▸ Sensitivity** | The scale every data type is classified against. The four levels are fixed. |
| **Data rubric ▸ Data types** | Categories of data used to determine sensitivity. |
| **Data rubric ▸ Data entities** | The parts of the business with specific rules regarding data sensitivity. |
| **Criticality rubric** | The business criticality of services, data and assets. |
| **Access rubric** | How far into the business an external entity can reach. |
| **Third party risk tiers** | Level of risk assigned to third parties. |

Where each one lives: `admin/MaturityRubricSection.tsx:15-17` · `admin/RiskRubricSection.tsx:60-62, 196-198, 336-338` · `admin/DataRubricSection.tsx:55-57, 234-236, 496-498` · `admin/CriticalityRubricSection.tsx:24-28` · `admin/AccessRubricSection.tsx:29-33` · `admin/RiskTierRubricSection.tsx:33-37`.

## Three things to confirm before applying

**Typo corrected.** Steve's note reads "sevices" for the Criticality rubric; written above as **services**. Flagging rather than silently fixing.

**Punctuation normalised.** Two of the supplied lines had no closing full stop (Access rubric, Third party risk tiers). All eleven are written with one above, since the rest of the tab uses sentences. Say if the shorter two were meant to stand without.

**The new copy is much shorter, and drops the versioning note.** Several current descriptions end by telling the admin their wording is kept in the level history and, in three cases, that the wording *is the instruction someone else follows when classifying* — see `CriticalityRubricSection.tsx:24-28`, `AccessRubricSection.tsx:29-33`, `RiskTierRubricSection.tsx:33-37`, which run four to five lines each. The replacements drop all of that. That reads as deliberate tightening, but it does remove the only place the app says "what you type here is versioned" and "this wording is what a colleague reads later". Worth a conscious yes before it goes — and if the versioning point should survive, the history panel each section already has is the natural place for it.

## Depends on [[COM-515]]

The Likelihood and Impact descriptions have nowhere to go until that ticket splits the combined *Likelihood & impact scales* section in two. Everything else here is independent and could land first if preferred.

## Verify
Each section on Admin ▸ Rubrics shows its new description; the tab lists "Third party risk tiers"; `ApprovalAreas.test.tsx` updated if the rule-condition label changes.
