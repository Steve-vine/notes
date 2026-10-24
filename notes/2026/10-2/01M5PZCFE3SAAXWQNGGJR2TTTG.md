---
id: 01M5PZCFE3SAAXWQNGGJR2TTTG
created: 2026-10-24T12:50:16.643267Z
updated: 2026-10-24T20:20:23.084459Z
type: task
title: A DDQ answer is never built from how a control was assessed — compliance, maturity and assessment notes are internal and are not a source, on screen or for the assistant; answers come from the controls, rated documents and evidence, and the Q&A library
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1282
sprint: ssgnel8
comments:
- id: 01M5PZYEX5JWB8EZ0A58QPZEEZ
  author: Steve Vine
  at: 2026-10-24T13:00:05.925453Z
  text: |-
    Steve's rule (2026-10-24): "ignore any controls that are marked as 'Not implemented' or 'Not applicable' or 'Not assessed'. 'Partial' and 'Implemented' assume that the control is robust enough to cite as in place to clients."

    So the assessment is a gate, never content. A control can be offered and cited only when the company's current assessment is Partial or Implemented. Not implemented, Not applicable, or no assessment at all means it isn't offered and can't be cited. Maturity, notes and the status itself never shape or appear in the wording.

    My call: if a cited control's assessment drops out of Partial/Implemented before the DDQ is sent, the answer shows that control as no longer citable and can't be approved until it's re-drafted. A library entry citing it is treated the same when used. Sent DDQs stay frozen.

    Staging note: Test Company has 1 assessment (Not implemented) and Moneypenny has 3, so under this rule there are almost no citable controls on staging.
- id: 01M5QS4JZJG6KBVCAV3WZQCYSH
  author: Steve Vine
  at: 2026-10-24T20:20:21.106413Z
  text: |-
    **Done: PR #1299, merged to main.** Goes to staging with the rest of sprint 86.

    **What you'll see**
    - **Offered controls:** the source pickers and Polaris's search offer only the controls the company has assessed **Partial** or **Implemented**. Nothing about how a control was assessed is offered or citable; an "assessment" is refused by name.
    - **A cited control that drops out** (reassessed Not implemented or Not applicable, or the assessment removed): the answer says "… — no longer in place for this company". It can't be approved, with Approve all or a release either. An already approved one is left out of the completed file until it's redrafted without the control.
    - **The questions list** shows a red **Source out of date** pill on such answers.
    - **Polaris** is told never to read assessments, gaps or risks to draft an answer, and never to say how well something is done.

    **Under the hood**
    - Migration 0686 withdraws COM-1273's `control_assessment` source kind. Any existing citation becomes a citation of the control itself; there were none on staging, and production never had the kind.
    - `control_citable` and `no_longer_citable` live in `answer_links`.
assignee: steve
priority: medium
task_status: review
---
From Steve while running DDQ-3, 2026-10-24:

"These answers go back to clients so if we have a control that for instance says 'Strong passwords must be used for all systems' and when it was last assessed, someone marked it as Partially compliant and added a comment – 'The old legacy CRM system doesn't support strong passwords', the answer to the client [would] say 'Strong passwords are not currently in place' or something like that. Compliance and maturity ratings are always internal and shouldn't even be considered when selecting an answer; answers should be built from the core controls themselves, uploaded evidence and documents with the appropriate rating, and Q&A answers."

**Changes:**
- Reverses the part of COM-1273 (ADR 0124 amendment) that made a control's assessment a citable Internal source. The control stays Public. The assessment (status, maturity, notes) is no longer a source: remove it from the DDQ page, the library, the assignee page and the assistant's source search.
- COM-1273 is merged to main but not yet on staging or production, so no existing answer cites an assessment. Check before removing.
- The assistant doesn't read assessments, gaps or risks while drafting DDQ answers. This replaces ADR 0124 §9's "the assistant may still read them".
- Sources are the controls, the Q&A library, and policies, standards, evidence and trust centre documents, each under its own classification.

**Open:** whether the approver gets an internal-only warning when a cited control is assessed below compliant. See the comment.