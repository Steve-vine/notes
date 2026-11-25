---
id: 01M89G2Z64WRQGRM2VJVR6NVZ5
created: 2026-11-25T13:59:54.3084Z
updated: 2026-11-25T17:07:07.833175Z
type: task
title: A completed recertification with removals raises a request on the Requests tab, approved there however many people reviewed it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2167
sprint: s4qjpqd
blocked_by:
- 01M89G1WPC942TTFE0S0S3WQ5P
- 01M89G2CG2CSAEC5WJC88Q32KP
comments:
- id: 01M89TSSDS8DVHKYW2B4R0FR4Z
  author: Steve Vine
  at: 2026-11-25T17:07:07.832977Z
  text: |-
    Built and merged to main: PR #2172, migration 0923_recert_removal_requests.

    What people see:
    - Every review that completes with flagged rows raises one "Recertification removals" request on the Requests tab, however many owners signed off and whatever kind of review it is. Compass raises it (no requester). Nothing is removed until it's approved; the two-owner path that removed straight away is gone.
    - The request page names the review (with a link) and who signed it off, and lists each row: person, what they lose, and where the removal stands.
    - Approving needs Approve requests. Privileged rows (a group granting directory roles, or a directory role) need an Access Admin, and the refusal says why. An owner who signed the review off can't approve it unless they're an Access Admin, in which case it reads self-approved.
    - On approval, each row goes down the path it always has. The request reads Executed when all rows are removed, or Failed if one fails; Retry re-runs only the failed rows.
    - Reject needs a reason. Each row reads Rejected with the reason, and nothing is removed. Cancel and gate edits are refused.
    - It appears in approvers' Actions, and so in the approval mail.
    - The migration raised a request for every completed review still waiting on the old approval. On production, that includes the Domain Admins review with its 4 removals.

    Two bugs found and fixed on the way:
    - Actions hid any request with no requester, so this kind would never have reached an approver.
    - The sweep that fails a request stuck in "executing" would have failed a review's request waiting days for an Entra step. This kind is now excluded.

    Differences from the task:
    - There's no per-row reviewer comment in Compass to show, so rows show the person and what they lose.
    - Steps for people stay where they're confirmed today: directory roles via "Confirm removed in Entra" on the review, asset entries on the asset's page, AD steps as before. Confirming finishes the request.

    Tested: integration tests for each point (two-owner, single-owner, Access Admin self-approval, rejection, Actions, privileged directory role, the migration's carry-over plus down/up), with older recert suites rewritten for the new rule. 1,112 integration tests across 80 files, unit suite, vitest. CI green.

    For Steve to decide: approving an asset review's removals needs Access's Approve requests (the request lives in Access), so Inventory-only people can't approve them.

    Not checked yet: in a browser (staging pre-UAT next).
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Access Control Review". Follows ADR 0179 (COM-2165) and COM-2166 (the self-approval rule it reuses).

## What people see
- **When any review completes with flagged rows**, Compass raises one request for it on the Requests tab. This applies to every kind of review: business role, group, directory role, shared mailbox, list senders, technology asset and data asset. It doesn't matter how many owners signed off. Nothing is removed until the request is approved. Today a review signed off by two or more owners removes access at once; that stops.
- **The new kind, "Recertification removals"**, reads e.g. "ACR-57 · Recertification removals · Domain Admins (2026-11-01)". It is raised by Compass "for the review signed off by [owners]". It lists each person and what is to be taken away, with the reviewer's comment where they left one. It can be filtered by kind like the others.
- **Approving it** needs the usual Approve requests right. A privileged row (for example Domain Admins, or a directory role) needs an Access Admin, as any privileged change does. **The approver must be someone other than the owners who signed the review off, unless they are an Access Admin** (holding "Approve their own requests", COM-2166). So Steve, signing off a review alone, can approve its removals himself, and that is shown as self-approved.
- **On approval**, each row is removed the way it is today: Compass removes group memberships, mailbox access and the list rights it can. A row Compass can't remove becomes a step for a person on the request, as on-premises steps are: a directory role in Entra, or an asset's own user or local entry. The step is ticked off when done. The request finishes when every row is removed or its step is done.
- **The approver can reject it with a reason.** Nothing is removed. The review records "removals rejected by [name]: [reason]", and the review stays complete. The approver can't take out individual rows: to keep someone, reject, and the owners re-run the review.
- **Approval emails and Actions** come with it, as for any request awaiting approval.
- **Reviews already waiting** when this arrives (including production's Domain Admins review, with 4 removals) get their request raised then, so nothing is left on the old approval. A review whose removals were already approved or done is left alone.

## Done when
In E2E Test Company:
- A group review signed off by one owner, with 2 flagged rows, raises one request with both rows. An Access Manager who didn't review it approves it. Both are removed and the request reads Done.
- A group review signed off by two owners also raises a request, and nothing is removed until it is approved.
- An owner who signed off, who is not an Access Admin, is refused. An Access Admin who signed off can approve, and it reads self-approved.
- A directory-role review's request needs an Access Admin. Approving it leaves an Entra step to tick.
- An asset review's own-entry row becomes a step on the request.
- Rejecting with a reason removes nothing and shows on the review.
- A review left waiting on the old approval gets its request when the migration runs.

## For the build
- New `AccessRequestKind.recert_removal`. The subject rows reference `recert_instance_items` (one subject per flagged item, or one subject holding the item ids; choose whichever `execute_access_request` handles more cleanly).
- `evaluate_instance_completion` raises the request instead of setting `removal_state` approved/pending_approval. `removal_state` follows the request: pending → approved → removed/failed, plus a new `rejected`.
- Execution reuses the current per-source paths (`execute_recert_removal`, `mark_manual_pending`, the manual-step model for directory-role and asset rows).
- `request_privilege_reasons` must understand the new kind.
- Second person: approver ∉ the instance's submitted owners, unless they hold `access_approve_own_request`.
- `requester_id`: none. Raised by Compass, with the owners named. Check every place that assumes a requester (mail, display, cancel rights). Who can cancel: nobody but Compass itself; a rejection is the way out.
- Data migration: every completed instance with `pending_approval` items gets its request.
- Inventory asset reviews: their approvers need Access's Approve requests. Note it in the ADR.
- **On the chain**: migration + API.