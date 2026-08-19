---
id: 01M0DF56ATEGD5HSQKRNY07GKT
created: 2026-08-19T16:55:01.722923Z
updated: 2026-08-19T16:55:28.794825Z
type: task
title: The Progress view rebuilt — the question up front, Edit Request and Respond instead of Resubmit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 298
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
What the requester sees when they click **Progress** in the portal (`ProgressModal`, `PortalRequestsPage.tsx`): a purple alert that says an approver has a question, a **Resubmit** button, and — twenty lines below, in `size="xs" c="dimmed"`, unlabelled and unattributed — the question itself. The one thing they need to read is the smallest text on screen, and the only thing they can do is resubmit unchanged answers.

- [ ] **The question replaces the boilerplate.** Delete *"An approver has a question — see their comment below. Once you have answered it, resubmit and they will be asked again."* and render the approver's actual words in the alert, with **who asked and when** — the transcript (COM-295) carries all three and the current rendering carries none.
- [ ] **More than one area can ask.** The alert must handle several outstanding questions rather than assuming one; today's markup renders each area's comment in a flat list with no indication which are still waiting on an answer.
- [ ] **Remove Resubmit. Add `[Edit Request]` and `[Respond]`** — Respond opens a composer that posts a response message (COM-295); Edit Request opens the pre-filled original form (COM-297). Both reopen the loop and move the request to `updated` (COM-294).
- [ ] **The transcript renders in the modal**, oldest-first with authors and timestamps, so the requester can see the exchange rather than only the latest question.
- [ ] **The same banner exists in `ReviewModal`** with different wording — *"An approver needs more detail — see their comment below, provide the information (e.g. complete an assessment on the vendor) and resubmit."* Both change, or the internal and portal surfaces tell the requester two different things.
- [ ] Progress is a modal, not a route — so the COM-296 email link lands on My requests, not on the request. Either make it addressable (`?request=<id>`) or accept that the link lands one click away, and say which.
- [ ] Tests: the question and its author render prominently; multiple outstanding questions render; Respond posts and closes the loop; Edit Request opens pre-filled; no Resubmit button remains on either surface.