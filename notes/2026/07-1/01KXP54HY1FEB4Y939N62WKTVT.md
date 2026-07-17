---
id: 01KXP54HY1FEB4Y939N62WKTVT
created: 2026-07-16T19:05:59.489971138Z
updated: 2026-07-17T19:22:33.471935036Z
type: task
title: Inline approvals in the issue timeline
task_status: done
priority: high
label:
- feature
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 99
blocked_by:
- 01KXP543Q76F4SQVAAE682B51X
sprint: s0v93ii
---
Bring the approval gate **into** the issue timeline (ISE-88): "Approvals should show as an orange notification, unless the user is an approver in which case there should be an approval acceptance button, that changes to a name and timestamp once accepted." Today approvals live only on `/approvals` (`ApprovalsPage.tsx`); this surfaces them inline in the feed.

- A `ProposedChange` that is `awaiting_approval` renders as an **approval bubble** in the timeline — orange "awaiting approval" notification, tier badge, operation + exact parameters, rationale, proposer (robot-vs-user).
- For **approvers**, inline **Approve** / **Reject** — reuse `POST /proposed-changes/{id}/approve` and `.../reject` (comment-required modal). Mirror the SoD logic from `ApprovalsPage.tsx:61-79`: block self-approval at T2/T3 unless admin, show the audited self-approve warning where it applies. **Server remains the authority** — the UI check is a mirror.
- Once decided, the bubble resolves to **"approved / rejected by {name} at {time}."**
- Execution runs server-side after approval (`enqueue_if_approved` → `execute_change`); the **execution-result** event and the **post-execution AI follow-up** (ISE-95) then appear as the next bubbles in the feed.

Blocked by the timeline feed (ISE-97). Label: feature.