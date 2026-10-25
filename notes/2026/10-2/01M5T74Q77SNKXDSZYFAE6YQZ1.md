---
id: 01M5T74Q77SNKXDSZYFAE6YQZ1
created: 2026-10-25T19:03:34.375791Z
updated: 2026-10-25T19:03:34.375791Z
type: task
title: 'Trust Centre portal: a visitor sends us a questionnaire — a file, pasted questions or their system''s address — and a DDQ appears as Received'
label: feature
assignee: steve
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1319
---
## Behaviour: the visitor

- While Questionnaires are switched on (COM-1318), a signed-in visitor sees a **Questionnaires** section in the portal with **Send us a questionnaire**.
- **The form:**
  - **How is your questionnaire set out?**
    - **A file:** a spreadsheet or Word document (checked as in COM-1317);
    - **Paste the questions:** a text box;
    - **On our own system:** the address and any notes (for example, how to log in, or who invited us).
  - **What's it for?** A new relationship, an annual review, or something else.
  - **When do you need it by?** Optional, never in the past. Left blank, the company's default from Settings applies, and the confirmation says which date that is.
  - **Your reference:** optional.
  - **Supporting files:** optional, any of the accepted types. These are things like a covering letter or their own policy.
  - **Anything we should know:** optional note.
- On **Send**, the page shows "Thanks — we've received your questionnaire", and the visitor gets an email confirming it with the due date. The email comes from the company's Trust Centre sender.
- The portal works on a phone as today.

## Behaviour: inside Compass

- **A DDQ is logged at once, as Received:**
  - **requester:** the visitor's organisation;
  - **contact:** the visitor's name and email;
  - **kind:** from "What's it for?";
  - **format:**
    - Spreadsheet or Word from the file;
    - Email for pasted questions, with the text as the email text;
    - Online with the address and notes.
  - **due date** as given or defaulted;
  - **their reference**;
  - **owner:** the person in Settings;
  - the visitor's note is kept on the DDQ.
- The questionnaire file is the DDQ's original file, and supporting files are attached as other files. All of them are unchanged.
- **NDA position:** if this visitor has accepted the company's current NDA wording, the DDQ reads "In place, via the trust centre" from the moment it's logged. This is the existing ADR 0124 §8 rule, now matched on the visitor themselves as well as their email domain.
- **The DDQ's questions start with Polaris** (COM-1287). Nothing is read or drafted until someone asks Polaris to set it up (Steve, 2026-10-25).
- **The owner gets a to-do:** "New questionnaire from Acme Ltd via the Trust Centre — set it up with Polaris". It has an email, and it closes when the questions are set up.
- **History:** the DDQ's first entry reads "Received through the Trust Centre from Jane Smith (jane@acme.com)". The Trust Centre's Activity records a "Sent a questionnaire" event against the visitor.
- **The visitor is also a requester like any other**, so carry-forward reference (ddq_read_last_time) finds their earlier DDQs as usual.

## My calls (awaiting Steve)

- **Three ways in** (file, paste, address). "On our own system" is included because some clients only have their online platform.
- **The DDQ is logged straight away.** Nobody has to accept it first, because the visitor is already trusted. Someone can still decline it as today.
- **If no owner can be found**, the DDQ is still logged with no owner, and the COM-1318 to-do picks it up.

## Notes

- **On the chain:**
  - migration: `ddqs.received_from_visitor_id` (FK trust_centre_visitors, SET NULL) and `ddqs.received_note`;
  - portal API: `POST /api/trust-centre/questionnaires`, multipart, visit cookie.
- **The portal's first visitor-authenticated write with files.** Add it to the trust-centre exact-set route test, and run `scripts/ci/check-portal-host-boundary.sh`. The response model is its own (ADR 0120 §10: portal payloads are written, not derived).
- Log through `core/ddqs.log_ddq`, so numbering, history and file keeping are shared with the screen.
- The to-do is an Actions source; the visitor email goes through the trust centre's sender and mail transports. Respect the portal off-switch (the generic "isn't valid" response).
- Frontend: `src/trustCentrePortal` gets a Questionnaires section and the form. It uses no internal-app components (separate Vite entry).
