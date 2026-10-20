---
id: 01M5B0EBPCTS9TVY9GDED4A69Q
created: 2026-10-19T21:17:53.740345Z
updated: 2026-10-20T00:52:27.607691Z
type: task
title: Each part of a request is decided — granted, partly granted or refused, with reasons from a list Settings can edit and any fee recorded — and an objection to direct marketing can never be refused
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1134
sprint: ss8348q
blocked_by:
- 01M5B0DY76EHKQ3Y8E5T31SVSG
comments:
- id: 01M5BCQ720EHFY6XNKAVN7DFYT
  author: Steve Vine
  at: 2026-10-20T00:52:26.816271Z
  text: |-
    Done — merged (PR #1130).

    - The Decide area has a **Decisions** card, one row per thing the person asked for: Granted, Partly granted, Refused, Not ours to answer, or Withdrawn by the person.
    - Partly granted and Refused need at least one reason; the picker only offers reasons that fit the request's law and that kind of request. Each row shows the reasons, the note for the letter, any fee, and who decided and when.
    - A fee (amount and why) only goes with Granted or Partly granted; free is the default. The currency follows the law (£, € or $).
    - An objection can be ticked as "to direct marketing"; it then can't be refused or partly granted. A CCPA opt-out can only be refused for "Identity not confirmed", with a warning that CCPA doesn't require verification for an opt-out.
    - A refused or partly granted row says a letter is expected, giving the reasons, the right to complain to the regulator named in Settings ▸ Company, and the right to go to court.
    - Once every row is decided, a one-line summary shows, e.g. "Access granted · Erasure refused: we must keep it by law (erasure)".
    - A decision can be changed until the request closes; each change needs a reason and goes on the timeline and in History.
    - **Settings ▸ Reasons**: the 12 shipped reasons, shared by every company, each showing the laws and kinds of request it fits. Someone with Manage data subject request settings can add, reword, retire and restore them; a retired reason stays on decisions that gave it; every edit is kept as a revision.

    My calls: the "to direct marketing" tick is new (nothing yet told a marketing objection apart); a marketing objection can still be Withdrawn or Not ours to answer; reasons can't be deleted or reordered, only retired. The task didn't say which laws and request types each reason fits, so I chose them — please check the list in Settings ▸ Reasons. "Exemption under the law" fits every law and type so that a complaint or a HIPAA restriction can always be refused with a named exemption.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 79, Data Privacy (ADR in COM-1129).

## What people see

A **Decide** card: one row per type the request asks for (Access, Erasure…). For each row:

- **Decision**: **Granted**, **Partly granted** or **Refused**. There are also **Not ours to answer** (forwarded to the customer whose data it is; the customer decides) and **Withdrawn by the person**.
- **Reasons** (needed for Partly granted and Refused, several allowed), from the list in **Settings ▸ Reasons**. Shipped:
  - Identity not confirmed
  - Manifestly unfounded
  - Manifestly excessive
  - Includes other people's data that can't be separated
  - Legally privileged
  - Needed to establish, exercise or defend legal claims
  - We must keep it by law (erasure)
  - Overriding legitimate grounds (objection, not marketing)
  - Exemption under the law (named in the note: e.g. DPA 2018 Schedule 2 crime and taxation, management forecasts, references)
  - HIPAA: psychotherapy notes, or information compiled for legal proceedings
  - HIPAA: the record is accurate and complete (amendment)
  - Not held

  Each reason says which laws and types it applies to, so the picker shows only those that fit. Settings can add, reword or retire reasons. A retired reason stays on old decisions.
- **Note**: the explanation that goes into the letter.
- **Fee**: an amount and why (a manifestly unfounded or excessive request, or further copies). Free is the default and the usual case.
- Compass keeps who decided and when.

Once every row has a decision, the card shows a one-line summary ("Access granted · Erasure refused: we must keep it by law").

## Rules

- **An objection to direct marketing can't be refused.** That row offers Granted only (UK/EU GDPR Art. 21(3)). The Fulfil stage records the suppression.
- **A CCPA opt-out of sale or sharing** has no refusal reasons except Identity not confirmed. CCPA doesn't require verification for an opt-out, so even that is shown with a warning.
- **Refused and Partly granted** expect a letter that states the reasons, the right to complain to the regulator (from Settings ▸ Company) and the right to go to court (Letters task). The card says so.
- A decision can be changed until the request closes. Every change is logged with its reason.

## Notes (technical)

- Reasons as a configurable table with revisions, like `IncidentCategory` (shared across companies; managed under Manage data subject request settings). Applicable law/type sets on each reason.
- A decision row per request type.

**Done when:** a handler can decide each part separately with reasons that fit the law; a marketing objection can only be granted; a refused part has its reasons and note.