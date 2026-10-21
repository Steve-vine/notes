---
id: 01M5G5SVMMN6CMKVJ4FW66EQ4G
created: 2026-10-21T21:27:45.556676Z
updated: 2026-10-21T21:29:16.366707Z
type: task
title: When a DPIA leaves a high risk, the ICO must be consulted first — record when it went, count down the regulator's 8 weeks (plus 6 if extended), record the reply, and only then approve; and a DPIA is reviewed when the processing changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1237
sprint: s33gwqy
assignee: steve
label:
- feature
priority: high
task_status: todo
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