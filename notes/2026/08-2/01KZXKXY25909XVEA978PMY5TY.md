---
id: 01KZXKXY25909XVEA978PMY5TY
created: 2026-08-13T13:10:35.845715Z
updated: 2026-08-13T13:10:53.635086Z
type: task
title: Bulk resolve has been impossible since ISE-642 — it sends no resolution note
project: 01KX671DATY39VW6GWK3M2T3DN
number: 686
sprint: sevhjex
assignee: steve
label:
- bug
priority: high
task_status: backlog
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