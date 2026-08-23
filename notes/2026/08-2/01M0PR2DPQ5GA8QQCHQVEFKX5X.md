---
id: 01M0PR2DPQ5GA8QQCHQVEFKX5X
created: 2026-08-23T07:23:58.039118Z
updated: 2026-08-23T07:24:10.765108Z
type: task
title: One Finalise and submit for the whole portal — all assessments go together
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 372
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
COM-368 put a Finalise and submit on each assessment; the intent was **one** — the supplier's visit ends with a single act. Move it to the portal's main screen and make it submit every open assessment together.

- [ ] The per-assessment Finalise buttons go; individual assessments can be fully answered but never individually submitted.
- [ ] One **Finalise and submit** button on the landing page (the open-assessments list), **disabled until every open assessment has all its required (currently applicable) questions answered** — with a hint of what remains ("2 questions left in Security Questionnaire") so a disabled button is actionable, not mute.
- [ ] The review step becomes combined: every assessment's questions and answers, grouped by assessment, edit links back into each form — then one confirm ("after submitting, answers cannot be changed") and one submit.
- [ ] Submit flips **all open assessments to `completed` in one transaction** — no partial outcome where two commit and one fails validation; server-side validation covers the full set before any flip, `submitted_by_contact_id` recorded on each.
- [ ] "All" means all **currently open**: an assessment that already expired or was closed is out of the set and must not block the button. A batch started later (COM-365's late-addition path) joins the gate — the button reflects whatever is open right now.
- [ ] Admin side: the per-assessment % and status displays are unchanged; expect the common pattern of several assessments sitting at 100% open until the supplier finalises — the "done but not finalised" label from COM-368 now matters more.
- [ ] Tests: button gating across multiple assessments (incl. conditional questions changing the applicable set); combined review reflects edits in every form; atomic submit (inject a validation failure in one, assert none complete); closed/expired excluded from the gate; single-assessment vendor degenerates to COM-368's behaviour.