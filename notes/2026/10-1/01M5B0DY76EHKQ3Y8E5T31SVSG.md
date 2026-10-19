---
id: 01M5B0DY76EHKQ3Y8E5T31SVSG
created: 2026-10-19T21:17:39.942044Z
updated: 2026-10-19T21:17:39.942044Z
type: task
title: The handler records how the person's identity was checked — the method, the result, who and when, and a representative's authority — without Compass ever keeping a copy of an ID document
label: feature
priority: high
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1133
---
Sprint 79, Data Privacy (ADR in COM-1129).

## What people see

A **Verify** card on the request page (the first stage area).

- **Ask for identity**: records that ID was requested, and when. Where the law's clock starts on confirmed identity, the clock waits (COM-1132). An "Identity check needed" letter is expected (Letters task).
- **Record the check**:
  - **Method**, one or more of:
    - details match what we already hold;
    - confirmed from a contact point we already hold (known email or phone);
    - ID document seen;
    - a representative's written authority seen (power of attorney, signed consent, court order, parental responsibility);
    - the customer confirmed it (forwarded requests);
    - not needed (e.g. a complaint, or a request for no personal data).
  - **Result**: Confirmed, or Not confirmed.
  - **Note**: what was checked, e.g. "passport, last 4 digits 1234". Compass keeps the note, not the document.
  - Compass keeps who recorded it and when.
- **Not confirmed** keeps the request open. The handler can ask again, or later close the request as **Identity not confirmed** (the Decide and Close tasks). A refusal letter then explains why.
- For a request through a representative, both are recorded: the person's identity, and the representative's authority.

## Rules

- **No ID documents in Compass.** This card has no upload, and the request's attachments warn that ID documents must not be attached. ID is checked and then deleted wherever it arrived (data minimisation, UK GDPR Art. 5(1)(c)). The ADR records why.
- Proportionate checks: the card's help text says to ask for no more than is needed, and never for ID when the details already match.
- A recorded check can be corrected (with a reason, logged) until the request closes.

## Notes (technical)

- Verification rows on the request (method set, result, note, by, at); representative authority as a second row kind.
- Wire the "clock starts on identity" rule from COM-1132.

**Done when:** a handler can ask for ID (the clock waits where the law says), record a confirmed check that starts the clock, and record a not-confirmed check; there is nowhere to upload an ID.