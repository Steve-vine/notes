---
id: 01M0F47W63X1ZQS243QW3GXDSJ
created: 2026-08-20T08:22:44.163422Z
updated: 2026-08-20T13:24:33.064899Z
type: task
title: The Progress alert says the ball is with the requester when they have just handed it back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 307
sprint: sbph5q5
comments:
- id: 01M0FGJJCHHZ8Z5RKW36YGCBXB
  author: Steve Vine
  at: 2026-08-20T11:58:17.489168Z
  text: |-
    Done — PR #303, merged to main as d995c0d. Took COM-306 first, as the task suggested, so this built on the reworked `outstanding` filter rather than fighting it.

    Three cases now, not two:

    - **`updated`** — "Request updated", with a line saying the approvers have your answer and are looking at it again. It also takes `updated`'s cyan (COM-294) instead of the hardcoded `grape`, so the alert and the status pill beside it stop describing one state in two colours.
    - **`queried`** — the case the fix could have papered over, and it did not: a request that *is* `info_requested` but carries no question message (queried before COM-295's transcript, or an approval whose comment was blank). It reads as genuinely waiting on the requester, in its own words — "An approver is waiting on you, but did not leave a question."
    - **`asked`** — unchanged; the questions themselves.

    Buttons untouched, because they were already right: Respond stays hidden on `updated`, Edit request stays offered (COM-297).

    `ReviewModal` left alone as instructed — its banner is gated on `info_requested` alone, so it never had this bug, and whether an approver should be told "the requester has answered" is a separate decision worth making on its own.

    Tests: after an edit the alert says the request is updated, renders cyan, and does not say an approver is waiting; a queried request with no question message still reads as waiting on the requester and keeps Respond; Edit request stays offered on `updated`. Full suite green (446).

    Ready for smoke-testing: query a request, then Edit request from the portal — the Progress box should turn cyan and say the approvers have it again, with Respond gone and Edit request still there.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Follows COM-298. Edit a queried request and the alert keeps its `info_requested` wording — headed **"More information needed"** and reading *"An approver is waiting on you. Your answers are below — correct them, or say something back."* The opposite is now true: the requester has answered, the request is `updated`, and the approvers are looking at it again.

**Why it lands there.** The alert renders for `info_requested` **and** `updated` (`canAnswer || canEdit`), but its title and its fallback sentence were written for the first case only. An edit moves the queried approvals to `updated` (COM-294), so the `outstanding` questions filter — which matches on `approval.status === 'info_requested'` — comes back empty and falls through to that sentence.

- [ ] **`updated` gets its own heading and sentence.** "Request updated", and a line saying the approvers have it again. The ball has changed hands and the box is the only thing on screen that claims to say whose turn it is.
- [ ] **The fallback fires in a second, unrelated case — don't let the fix paper over it.** A request that *is* `info_requested` but carries no question message (queried before COM-295's transcript, or an approval whose comment was blank) also lands on that sentence. That one genuinely is waiting on the requester, so it needs wording of its own rather than inheriting whichever sentence this task writes.
- [ ] **Colour.** The alert is hardcoded `grape`, which is `info_requested`'s. On `updated` it should take that status's cyan (COM-294) so the alert and the status pill beside it are not two different colours describing one state.
- [ ] Buttons are already right and should stay: **Respond** is hidden on `updated` (there is no outstanding question to answer) and **Edit request** remains, because COM-297 deliberately allows a second correction while the approvers are re-reading.
- [ ] **`ReviewModal` does not have this bug** — its banner is gated on `info_requested` alone, so it renders nothing on `updated`. Worth deciding separately whether an approver should see "the requester has answered — take another look" there; the status pill says it today. Do not "fix" it into the same shape without deciding that.
- [ ] Tests: after an edit the alert says the request is updated and not that an approver is waiting; after a response likewise; a queried request with no question message still reads as waiting on the requester; Respond stays hidden and Edit request stays offered on `updated`.

**Overlaps COM-306** — same JSX block, and COM-306 changes which questions feed the `outstanding.length === 0` branch this task rewords. Worth doing them together, or taking COM-306 first.
