---
id: 01KZXKXY25909XVEA978PMY5TY
created: 2026-08-13T13:10:35.845715Z
updated: 2026-08-13T19:00:07.231922Z
type: task
title: Bulk resolve has been impossible since ISE-642 — it sends no resolution note
project: 01KX671DATY39VW6GWK3M2T3DN
number: 686
sprint: sevhjex
comments:
- id: 01KZXZZPRB54C7TTC4Z945M5HZ
  author: Steve Vine
  at: 2026-08-13T16:41:16.811056Z
  text: |-
    2026-08-13 — DONE, PR #637 merged to main.

    **One note for the selection, captured in the confirm dialog** and sent with every PATCH in the fan-out. Per-incident prompting was considered and rejected for the reason the task gives: 39 prompts collect 39 pasted copies of one sentence, which is the rot the required field exists to prevent. The field is labelled "What was done" and its description names the destination — "saved as the resolution note on all 39 — it is what the next operator reads in Recall when one of these recurs" — because someone writing one sentence for 39 incidents should know that is what they are doing.

    **Empty is refused in the dialog**, not 39 times over the wire. The server would reject every one; a client that can see that coming should not spend the round trips to be told. Whitespace does not count.

    **The toast stops inventing.** It now collects the distinct `detail`s from the failures and reports them, and distinguishes the two cases the task asked for: "2 of 2 failed. The server said: …" versus "3 of 39 failed, for 2 different reasons: … · …". One thing to fix versus a list to work through.

    **Not in the task, found while building:** the Modal is rendered unconditionally, so the draft survives its own close — a sentence written about the last selection would have greeted the next one. Cancel clears it. On a field whose entire purpose is that the next operator can trust it, a stale note is worse than none.

    **On the test gap.** Fixing the stub to record bodies was necessary but not sufficient — the failure-path tests still passed vacuously at first, because `<Notifications />` lives in `main.tsx`, not in `App`. A test rendering `<App />` alone has nowhere for a toast to land, so every assertion about what the operator was TOLD would have been green against a toast that never rendered. That is the same class of hole as the one that hid this bug, one layer up, and it is worth remembering for any future test that asserts on a notification.

    Five tests now: the note reaches the body, an empty note cannot fire, a 422/409 surfaces the server's wording with "1 of 2 failed", several causes read as several, and a cancelled draft does not survive. All green; prettier, eslint, tsc build, api-types green on the PR.
assignee: steve
label:
- bug
priority: high
task_status: review
tech: null
---
Selecting 39 incidents and clicking **Resolve selected** fails 39 of 39, every time, on a freshly refreshed list. Reported from staging 2026-08-13.

**Cause.** ISE-642 (PR #588, merged 2026-08-10) made a resolution note mandatory for `resolved` and `dismissed`, enforced in `apply_status_change` (`api/v1/issues.py:1290`) so no surface can route around it. The bulk fan-out in `IssuesPage.tsx:229` sends `body: { status: 'resolved' }` with no note, so every request is a deterministic 422. Nothing is stale and nothing raced — refreshing cannot help. `test_crud_api.py:197` already asserts exactly this rejection.

PR #588 added the note modal to `IssueDetailPage.tsx` and never revisited its sibling callers.

**Scope**
- Capture **one note for the whole selection** in the existing confirm dialog, and send it with every PATCH in the fan-out. One note, not 39: per-incident prompting for a 39-way bulk produces 39 pasted copies of one sentence, which is the failure mode the required field exists to prevent. The operator's real answer here is a single fact about the batch ("alerts recovered at source").
- The dialog must make the note's destination clear — it lands on every incident in the selection and is what the next operator reads in Recall.
- **Surface the server's reason instead of guessing.** The handler does `if (error) failed += 1` and discards `error`, then the toast asserts "they may have changed under you; the list has refreshed" — a confident invention. The server said "say what was done before marking this resolved", which would have made this self-diagnosing. Report the first distinct `detail` from the failures. Same defect shape as ISE-685, three days apart.
- Partial failure stays possible (a child merged under a master still 409s), so the toast must distinguish "all failed for one reason" from "3 of 39 failed for mixed reasons".

**Test gap that let this ship.** `StaleOpenIncidents.test.tsx:105-107` asserts only that a PATCH reached each id, against a stub that always succeeds — never the request body, never a failure path. Green suite, dead feature. The regression test must assert the note is present in the body and that a 422 surfaces the server's wording.

Sibling surface with the same root cause: ISE-687 (the guided view's resolve button).