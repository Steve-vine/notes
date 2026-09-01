---
id: 01M0N8104QQRR525FTPPTE92QA
created: 2026-08-22T17:24:19.735872Z
updated: 2026-09-01T13:55:50.640718Z
type: task
title: Finalise and submit — answering the last question no longer ends the assessment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 368
sprint: sbph5q5
comments:
- id: 01M0NF65KZD0FATJGXT8GZ6JFS
  author: Steve Vine
  at: 2026-08-22T19:29:29.215249Z
  text: |-
    Done — PR #370, merged to main.

    **One correction to the premise.** Nothing auto-completed at 100%, on either side. `complete_assessment` was already only ever reached from the explicit submit/complete endpoints, and the portal had no auto-submit — the Submit button simply *enabled* once the required questions were answered. So there was no auto-complete to remove. The substance stood, though: one click on a newly-enabled button made an immutable record of whatever had been typed on the way through, and checking happened by accident of answering order or not at all.

    What shipped:
    - **Finalise and submit** opens a **review step** rather than submitting: every question being asked, the answer as the supplier should read it back (Yes/No for booleans, joined lists, "Not answered" for optional blanks), and an **Edit** beside each that returns to the form with that field focused and scrolled to.
    - Only applicable questions appear — a follow-up nobody triggered is not a blank in the record, it is a question that was never put.
    - **A confirm stating the consequence** before it commits, with "Keep editing" as the way out. Gating reads off the applicable set, so conditional questions change what the button waits for.
    - Admin tab labels an open assessment at 100% **"Not submitted"** — otherwise a row sitting there for days reads as something stuck.
    - Closing a fully-answered unsubmitted assessment still *closes* rather than completes it, answers intact.

    **The no-auto-complete property is now asserted rather than assumed**, as the task asked: answering everything leaves the assessment `open`, `completed_at` null, at 100%, and still editable (re-answering after 100% works). Plus the frontend flow test: 100% with zero submits, review shows the answer, backing out of the confirm submits nothing, only the confirmed action submits.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
On the Vendor Portal, an assessment currently completes the moment the last question is answered — the supplier gets no chance to look back over what they've said before it becomes the immutable record. Split answering from finishing.

- [ ] Answering every question does **nothing terminal** — the assessment stays `open`, answers remain editable (the incremental upsert already allows re-answering an open assessment; it's the auto-complete that goes).
- [ ] A **Finalise and submit** button, enabled once all required (currently applicable) questions are answered, disabled with a "N questions remaining" hint otherwise.
- [ ] Before it commits, show a **review step**: every question with its answer, edit links back into the form — the point of the change is that checking happens *here*, deliberately, not by accident of answering order.
- [ ] A confirm on the final action stating the consequence: after submitting, answers cannot be changed. Submit then runs the existing complete path (`open → completed`, full validation server-side, `submitted_by_contact_id` recorded).
- [ ] Server-side: make sure nothing on the backend auto-completes at 100% either — completion must only ever be the explicit submit call. If the current auto-close lives client-side only, assert that with a test anyway.
- [ ] Interactions that must stay true: percentage can sit at 100% with the assessment still open (admin tab shows an open assessment at 100% — that now means "done but not finalised", worth a subtle label); expiry/manual close still apply to a fully-answered-but-unsubmitted assessment and keep the answers as the closed record.
- [ ] Tests: all-answered stays open and editable; button gating incl. conditional questions changing the applicable set; review step reflects edits; submit completes and locks; expiry of a 100% unsubmitted assessment closes (not completes) it.