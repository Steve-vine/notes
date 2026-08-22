---
id: 01M0N8104QQRR525FTPPTE92QA
created: 2026-08-22T17:24:19.735872Z
updated: 2026-08-22T17:24:31.277504Z
type: task
title: Finalise and submit — answering the last question no longer ends the assessment
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 368
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the Vendor Portal, an assessment currently completes the moment the last question is answered — the supplier gets no chance to look back over what they've said before it becomes the immutable record. Split answering from finishing.

- [ ] Answering every question does **nothing terminal** — the assessment stays `open`, answers remain editable (the incremental upsert already allows re-answering an open assessment; it's the auto-complete that goes).
- [ ] A **Finalise and submit** button, enabled once all required (currently applicable) questions are answered, disabled with a "N questions remaining" hint otherwise.
- [ ] Before it commits, show a **review step**: every question with its answer, edit links back into the form — the point of the change is that checking happens *here*, deliberately, not by accident of answering order.
- [ ] A confirm on the final action stating the consequence: after submitting, answers cannot be changed. Submit then runs the existing complete path (`open → completed`, full validation server-side, `submitted_by_contact_id` recorded).
- [ ] Server-side: make sure nothing on the backend auto-completes at 100% either — completion must only ever be the explicit submit call. If the current auto-close lives client-side only, assert that with a test anyway.
- [ ] Interactions that must stay true: percentage can sit at 100% with the assessment still open (admin tab shows an open assessment at 100% — that now means "done but not finalised", worth a subtle label); expiry/manual close still apply to a fully-answered-but-unsubmitted assessment and keep the answers as the closed record.
- [ ] Tests: all-answered stays open and editable; button gating incl. conditional questions changing the applicable set; review step reflects edits; submit completes and locks; expiry of a 100% unsubmitted assessment closes (not completes) it.