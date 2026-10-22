---
id: 01M5G5PZ2KMPQS3CTF673577WX
created: 2026-10-21T21:26:10.771755Z
updated: 2026-10-22T22:29:10.934166Z
type: task
title: Submit, approve or send back — the approver signs it off, it's frozen as it stood that day with the scales it used, and the register takes its scores, owners and decisions; each risk shows the assessments it was in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1226
sprint: s33gwqy
blocked_by:
- 01M5G5PGB9EAPZCF91R30MEJYF
assignee: steve
label:
- feature
priority: high
task_status: active
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