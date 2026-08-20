---
id: 01M0F43JH2V38F6TN5AYVZRG6Q
created: 2026-08-20T08:20:23.202467Z
updated: 2026-08-20T08:20:37.71844Z
type: task
title: '''More information needed'' shows only the current question — the superseded ones live in the transcript'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 306
sprint: sbph5q5
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Follows COM-298. Ask an area a **second** question and the alert stacks it under the first: both stay rendered, because the filter selects *every* `question` message whose approval is currently `info_requested` — and a repeat question leaves the earlier one attached to that same approval.

```ts
// PortalRequestsPage.tsx (and identically in ReviewModal.tsx)
const outstanding = (request?.messages ?? []).filter(
  (message) =>
    message.kind === 'question' &&
    request?.approvals.some(
      (a) => a.id === message.approval_id && a.status === 'info_requested',
    ),
)
```

The box should show **what is being asked now**. The exchange already renders in full under *Conversation* at the bottom of the modal (COM-298), so repeating the superseded questions in the alert makes the requester read the same thing twice and guess which one they are answering — while making the alert grow with every round of a loop that already has a home for its history.

- [ ] **The latest question per outstanding approval**, not every question on it. Both surfaces sort by `created_at` and take the last one for each approval still in `info_requested`.
- [ ] **Not "exactly one question" — one per waiting area.** COM-298 deliberately made the alert handle several outstanding questions, because Cyber and Legal can each be waiting and answering only the one you can see is how a request stalls. This narrows *within* an area, not across them. If a single question really is wanted no matter how many areas are waiting, say so — that is a different change and it undoes part of COM-298.
- [ ] **Both surfaces, same rule.** `ProgressModal` (`PortalRequestsPage.tsx`) and `ReviewModal.tsx` carry the identical filter; COM-298's own reasoning was that the two must not tell the requester different things.
- [ ] Worth a shared helper rather than a third copy of the predicate — it has already been duplicated once.
- [ ] `vendor_approvals.comment` already holds the *latest* question (COM-295 kept it for exactly this kind of reader), so it is available as a cross-check. Deriving from the transcript is still preferable: the message carries the author and timestamp the alert renders, and `comment` carries neither.
- [ ] Tests: an area asked twice renders only its second question in the alert while both remain in the transcript; two areas each waiting still render one question each; the empty case is unchanged.

**Reachable, and already walked at the backend layer** — `test_asking_twice_appends_instead_of_overwriting` (COM-295) does exactly this: ask, respond, ask again.
