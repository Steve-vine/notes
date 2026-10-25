---
id: 01M5T7550AJYJWMQJR4RQF87BV
created: 2026-10-25T19:03:48.490088Z
updated: 2026-10-25T23:11:11.2939Z
type: task
title: 'Trust Centre portal: a visitor''s Questionnaires area — each one they sent with a plain status, and "Add a file" until it''s sent back'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1320
sprint: snfoon1
blocked_by:
- 01M5T74Q77SNKXDSZYFAE6YQZ1
assignee: steve
label:
- feature
priority: medium
task_status: active
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
