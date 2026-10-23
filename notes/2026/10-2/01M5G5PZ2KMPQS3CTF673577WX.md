---
id: 01M5G5PZ2KMPQS3CTF673577WX
created: 2026-10-21T21:26:10.771755Z
updated: 2026-10-23T18:06:05.474513Z
type: task
title: Submit, approve or send back — the approver signs it off, it's frozen as it stood that day with the scales it used, and the register takes its scores, owners and decisions; each risk shows the assessments it was in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1226
sprint: s33gwqy
blocked_by:
- 01M5G5PGB9EAPZCF91R30MEJYF
comments:
- id: 01M5K33YN0ZGQZJDCE3C9PW9FF
  author: Steve Vine
  at: 2026-10-23T00:38:33.888139Z
  text: |-
    Done — merged in PR #1248 (migration 0540). Not yet on staging.

    - An assessor presses "Submit for approval" on the Status card. A dialog lists anything still missing for each threat: a score before or after the controls, a decision, an owner, or an Accept that is over appetite or has no reason. It asks for a Summary and, if no threat is about fraud, why fraud isn't relevant. Submit stays disabled until everything is ready.
    - While awaiting approval the assessment can't be changed. The approver gets "Approve RA-7" in Actions, and Approve and Send back buttons on the Status card.
    - Send back needs a comment. The assessment goes back to In progress and can be edited again; the comment shows on the page and in History, and the assessors get "RA-7 was sent back" in Actions.
    - Approve takes an optional comment. From then on nothing can change. The page says "Assessed on the risk rubric as it stood on …", with a "See the scales" link. Threat rows keep that day's bands, appetite and control statuses whatever changes later.
    - On approval the register is updated, recorded as the approver:
      - a threat tied to a risk updates its scores, owner and category; a new threat creates a new risk;
      - proposed treatments become treatment plans, and Transfer and Avoid become plans of that kind;
      - an Accept becomes an acceptance already approved by the approver, running for the acceptance period;
      - controls, assets and vendors are linked, and each risk is marked reviewed;
      - each risk's History says "From RA-7, approved by …".
    - Approving an assessment started from an earlier one marks the earlier one "Superseded by RA-9".
    - A risk's page has a new Assessments card listing every approved assessment it was in, with the scores and decision given there.

    My calls:
    - Anyone who can manage assessments can submit except the approver, so a manager can cover for an absent assessor.
    - The checks run again at approval. If the appetite has been lowered since submission and an Accept is now over it, approval is refused and the approver sends it back.
    - Submit also needs at least one threat, and a reason on every Accept.
    - For a risk already in the register, only its scores, owner and category change; its title and statement stay as they were. A closed risk gets the new scores but isn't reopened.
    - Links to controls, assets and vendors are only ever added, never removed.
    - An Accept that renews a risk's existing acceptance closes the old one.
    - An assessment awaiting approval has to be sent back before it can be withdrawn. DPIA screenings can't be submitted or approved; they are completed with their outcome.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 83, Risk Assessments (ADR in COM-1219).

**Chain:** on the chain — migration + API

## What people see

**Submit** (an assessor). Before it goes, Compass checks and lists what's missing:
- every threat has inherent and residual scores, a decision and an owner;
- no Accept is over appetite;
- **fraud considered (SOC 2 CC3.3):** if no Fraud-category threat is in the assessment, the assessor must say why fraud isn't relevant — the answer is kept and printed in the PDF;
- a short **Summary** (key findings, overall view) is written.

Status → **Awaiting approval**; the approver gets "Approve RA-7" in Actions.

**The approver** (never an assessor) reads it and either:
- **Approves** — with an optional comment. Status → **Approved**, dated, named. From then it is **frozen**: no field can change, and the page notes "Assessed on the risk rubric as it stood on 21 Oct 2026" (likelihood, impact, bands and appetite as they were — later rubric edits don't change it).
- **Sends back** with a comment — status back to In progress; the comment shows on the page and in History.

**Withdraw** (Manage) a Draft or In-progress one, with a reason. Kept, marked Withdrawn, never deleted.

**On approval, the register is updated** (Posture ▸ Risks):
- a threat tied to an existing risk updates its scores, owner, category; a new one creates the risk (`R-31`) with its three-part statement;
- proposed treatments become treatment plans; Accepts become acceptances already approved by this approver, expiring 12 months on;
- each risk's revision says "From RA-7, approved by …", and its Last reviewed / Next review move on;
- links to controls, assets and vendors are carried across.

A risk's page gains an **Assessments** card: every approved assessment it appeared in, with the scores it was given in each.

## Notes (technical)

- Freeze: store the rubric revision ids (likelihood, impact, bands, appetite) on approval; reject writes when approved (409).
- Register write in one transaction; idempotent; actor = approver, `via` = assessment.

**Done when:** RA-1 can't be submitted with an unscored threat; approving it creates/updates the risks, which show "From RA-1"; editing the rubric afterwards leaves RA-1's displayed scales unchanged; a sent-back assessment is editable again.