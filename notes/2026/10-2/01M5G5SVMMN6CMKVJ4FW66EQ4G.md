---
id: 01M5G5SVMMN6CMKVJ4FW66EQ4G
created: 2026-10-21T21:27:45.556676Z
updated: 2026-10-23T03:33:06.514241Z
type: task
title: When a DPIA leaves a high risk, the ICO must be consulted first — record when it went, count down the regulator's 8 weeks (plus 6 if extended), record the reply, and only then approve; and a DPIA is reviewed when the processing changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1237
sprint: s33gwqy
blocked_by:
- 01M5G5SKCFQ3VPX40JS479970D
comments:
- id: 01M5KD3HSDMAG6XQSW7RB3357W
  author: Steve Vine
  at: 2026-10-23T03:33:06.477136Z
  text: |-
    Done — merged in PR #1256 (migration 0575). Not yet on staging.

    - A DPIA that leaves a High risk to people gets a Prior consultation card: "This DPIA leaves a high risk. Processing can't start until the ICO has been consulted (Article 36)." The warning on Risks to people links to it.
    - "Record as sent" takes the day it went and what was sent (a description, a copy attached, or both). The card then counts down "Reply due …" like an incident's notification deadline: grey, amber in the last week, red "Overdue by N days".
    - "Extended" adds 6 weeks and asks for the ICO's reason.
    - "Record the reply" takes the date, the outcome (No objection / Advice given / Processing should not go ahead), an optional note, and the reply file, which is required.
    - Submit and Approve are refused until the reply is recorded, or the deadline passes with no reply (which is noted). If the ICO says not to go ahead, approval records that the processing will not proceed. The PDF gains a "Prior consultation with the ICO" section.
    - Actions:
      - "ICO reply due for RA-12" goes to the assessors a week before the deadline, and shows as overdue after it.
      - "Processing changed — review DPIA RA-12" goes to the assessors when a covered data asset's purpose, lawful basis, data types, volume or transfers change after approval. The DPIA page shows what changed.
    - "Review this DPIA" starts the next DPIA from it, with its cards and risks carried forward.
    - Once the DPIA is approved, the copy sent and the ICO's reply appear in Audit ▸ Evidence with it. Admin ▸ Files names them, and the kept assessment PDFs, with a link (before, they showed with no owner).

    My calls:
    - The deadline is 56 days from the day it was sent (plus 42 if extended), counted in UK days.
    - "Processing changed" compares the DPIA's details as approved with the data asset now. Undoing the edit clears the to-do.
    - The ICO letters only appear as evidence once the DPIA is approved, because a copy can still be replaced before then.

    To decide: a DPIA whose processing won't go ahead still gets a next-due date from the DPIA review cadence. Should it?
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 83, Risk Assessments (ADR in COM-1219). GDPR Art. 35(11), Art. 36.

**Chain:** on the chain — migration + API

## What people see

**Prior consultation** card on a DPIA with any **High** residual risk to people:
- "This DPIA leaves a high risk. Processing can't start until the ICO has been consulted (Article 36)."
- Record **sent on** (and what was sent — attach it); Compass counts down **8 weeks**, shown like an incident's notification deadline; **Extended** adds 6 weeks with the ICO's reason.
- Record the **reply**: date, outcome (no objection / advice given / processing should not go ahead) and the reply itself as a file.
- The DPIA can be submitted and approved only once the reply is recorded (or the deadline has passed with no reply, which is noted). If the ICO says not to go ahead, approval records that the processing will **not** proceed.
- Actions: "ICO reply due for RA-12" for the assessors a week before the deadline.

**Review on change (Art. 35(11)):**
- An approved DPIA falls due for review on the DPIA cadence (Settings), and **Review this DPIA** starts the next one from it.
- Editing a covered data asset's purpose, lawful basis, data types, volume or transfers in Inventory raises "Processing changed — review DPIA RA-12" in Actions for its assessors.

## Notes (technical)

- Consultation fields + attachments on the assessment; deadline per ADR 0121 dates; action sources per ADR 0055; data-asset change hook compares the audited fields.

**Done when:** a DPIA with a High residual can't be approved until a reply is recorded; the 8-week countdown shows; changing a covered data asset's lawful basis raises a review to-do.