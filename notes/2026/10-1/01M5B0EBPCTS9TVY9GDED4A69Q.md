---
id: 01M5B0EBPCTS9TVY9GDED4A69Q
created: 2026-10-19T21:17:53.740345Z
updated: 2026-10-19T21:17:53.740345Z
type: task
title: Each part of a request is decided — granted, partly granted or refused, with reasons from a list Settings can edit and any fee recorded — and an objection to direct marketing can never be refused
label: feature
task_status: todo
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1134
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