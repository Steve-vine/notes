---
id: 01M5B0DY76EHKQ3Y8E5T31SVSG
created: 2026-10-19T21:17:39.942044Z
updated: 2026-10-20T18:05:46.049258Z
type: task
title: The handler records how the person's identity was checked — the method, the result, who and when, and a representative's authority — without Compass ever keeping a copy of an ID document
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1133
sprint: ss8348q
blocked_by:
- 01M5B0DJMR6AHT3ZY93VD0ZME3
comments:
- id: 01M5BC70ZNBP0J1ES760B13C8Q
  author: Steve Vine
  at: 2026-10-20T00:43:36.308404Z
  text: |-
    Done — merged (PR #1129).

    - The Verify area has an **Identity** card. **Ask for identity** (with an optional note of what was asked for) records when and by whom. Where the law starts the clock on confirmed identity (UK GDPR), the clock waits and the request shows "Waiting for identity".
    - **Record the check**: one or more of the six methods, Confirmed or Not confirmed, and a note such as "Passport, last 4 digits 1234". Compass keeps who recorded it and when.
    - Confirming starts a waiting clock from that day. Not confirmed keeps the request open and the clock waiting; the handler can ask again.
    - "Not needed" stands on its own and asks for no result; if ID had been asked for, the clock goes back to counting from receipt.
    - A request made through a representative also has a **Representative's authority** card with its own check.
    - Any check can be **corrected** with a reason until the request closes; corrections go on the timeline and in History.
    - The card says to ask for no more than is needed, and never for ID when the details already match. There's no upload anywhere in Verify, and the Attachments card now warns in yellow not to attach ID documents.

    My calls: asking for identity again is refused once it's confirmed (correct the check instead); a correction that undoes a confirmation holds the clock again; an authority check is only offered when the request came through a representative. "Clarification received" stays on the Deadline card's Restart.
assignee: steve
label:
- feature
priority: high
task_status: done
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