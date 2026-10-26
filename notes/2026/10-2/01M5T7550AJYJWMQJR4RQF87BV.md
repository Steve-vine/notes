---
id: 01M5T7550AJYJWMQJR4RQF87BV
created: 2026-10-25T19:03:48.490088Z
updated: 2026-10-26T00:40:28.1204Z
type: task
title: 'Trust Centre portal: a visitor''s Questionnaires area — each one they sent with a plain status, and "Add a file" until it''s sent back'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1320
sprint: snfoon1
blocked_by:
- 01M5T74Q77SNKXDSZYFAE6YQZ1
comments:
- id: 01M5TTDJE0QP0CAAK2RZXB7SGC
  author: Steve Vine
  at: 2026-10-26T00:40:27.328328Z
  text: |-
    Done — merged to main (PR #1337).

    - **The visitor's Questionnaires area lists every questionnaire they sent in**, newest first, each in one of four plain states:
      - Received;
      - Being worked on;
      - Completed;
      - Closed, which says "contact <email>" and gives no reason.

      Each entry shows what it was for, when it was sent, when it's due, and the files they sent, which they can download again.
    - **"Add a file"**, until the DDQ is sent back:
      - files are checked by what they contain, and can come with a note;
      - each file is attached to the DDQ and noted in History;
      - the owner gets a to-do ("Acme Ltd added 2 files to DDQ-12") until they press **Mark as seen** on the DDQ's Files card.
    - **Ringfenced:** a visitor sees only their own, and anything else gets the one "not found". Nothing internal is shown: no answers, no counts, no names.
    - **When it's sent back through the Trust Centre** (COM-1322/1323), the completed files appear inside the same entry under "What we sent back".

    My calls:
    - **Files that arrive with the questionnaire count as seen straight away.** Only files added later wait for "Mark as seen", so the owner isn't chased twice.
    - **Adding a file needs questionnaires to be switched on**, as well as the DDQ still being open.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
## Behaviour

- **The visitor's Questionnaires area lists every questionnaire they sent in** (COM-1319), newest first. Each shows:
  - their reference, or "Questionnaire sent 25 Oct 2026";
  - what it was for, the due date, and the files they sent (each downloadable again);
  - **a plain status:**
    - **Received:** the DDQ is Received;
    - **Being worked on:** In progress or In review;
    - **Completed:** sent back. The files that came back show here once they're shared (COM-1322).
    - **Closed:** the DDQ was withdrawn or declined. The line reads "Closed — contact <company contact email>". No reason is shown and no email is sent.
- **Ringfenced:** a visitor sees only what they sent, and what was shared with them. Another visitor from the same organisation doesn't see it, and the other visitor's address answers as a missing page. A colleague is shared a completed DDQ by being added when it's sent (COM-1322).
- **Add a file:** until the DDQ is sent back, the visitor can add supporting files, checked as in COM-1317.
  - Each new file is attached to the DDQ.
  - It's noted in the DDQ's History ("Jane Smith added 'Appendix B.pdf' through the Trust Centre").
  - The owner gets a to-do "Acme Ltd added a file to DDQ-12".
  - The visitor can't remove or replace files. They can send a note with the file.
- **The area shows nothing internal:** no answers, no question counts, no names of who is working on it.
- **The section appears** while Questionnaires are switched on, or while the visitor has anything in it.

## My calls (awaiting Steve)

- The four plain states. Closed gives no reason, to match the trust centre's polite decline.
- A visitor can add files but never remove them. Once we have a file, it's part of the DDQ's record.
- The visitor can't withdraw a questionnaire this sprint. They contact the company instead.

## Notes

- **On the chain:** portal API `GET /api/trust-centre/questionnaires`, `GET …/{id}/files/{file}`, `POST …/{id}/files`. Add these to the exact-set route test.
- Scope every lookup by visitor and company, and give one "not found" for anything outside it (ADR 0051 §5 single rejection).
- Map the status in core, not the frontend, so the portal payload carries only the plain state.
- Events: "Added a file" and "Downloaded own file" in `trust_centre_events`.
