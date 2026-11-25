---
id: 01M89G3DV8Z4KX3NQ6Q51GFE2G
created: 2026-11-25T14:00:09.320584Z
updated: 2026-11-25T14:00:23.984848Z
type: task
title: A recertification review shows its removal request instead of its own Approve button, on screen, on an asset's page and through Polaris
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2168
sprint: s4qjpqd
blocked_by:
- 01M89G2Z64WRQGRM2VJVR6NVZ5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Access Control Review". After COM-2167.

## What people see
- **The review's "Approve N removal(s)" button goes.** On the Instances list and in the review, the orange "N removal(s) awaiting approval" pill becomes **"Removals: ACR-57 awaiting approval"**, linking to the request. It then reads approved, done, rejected or failed as the request moves.
- **Each flagged row** shows where its removal stands (awaiting approval, removed, step to do, rejected or failed). A row's step is ticked on the request, not on the review.
- **An asset's Access page** (technology and data assets), which shows the same review, shows the same link.
- **The request links back** to its review.
- **The evidence CSV** for a review gains the request reference, who approved or rejected it and when, and whether it was self-approved, so the auditor's evidence shows the approval.
- **Polaris:** `access_approve_recert_removals` and `access_confirm_recert_removal` are retired. Polaris approves the request with the ordinary request tools, and the recertification tools report the request (reference, state, approver). In a review read through the Inventory tools, the same.
- **The portal's Recertifications tab** (owners who aren't in Access) shows "Removals sent for approval" once they've signed off. It doesn't link to the request, which they can't see.

## Done when
In E2E Test Company:
- A completed review shows its ACR link and no Approve button. Following the request from awaiting approval → done is reflected on the review.
- The asset page shows the same.
- The evidence CSV carries the approval.
- Polaris answers "where are the Domain Admins removals?" with the request.

## For the build
- `RecertInstanceView.tsx` / `RecertPage.tsx`: drop `useApproveRemovals` and `useConfirmRoleRemoved`. `RecertInstanceOversight` gains `removal_request` {id, ref, status, decided_by, self_approved}.
- Retire `POST /recert-instances/{id}/approve-removals` and `/recert-items/{id}/approve-removal` (409 with a pointer to the request), and the item confirm route. Regenerate `schema.d.ts`.
- Polaris: `assistant/tools/access_recert.py` and the inventory recert reads. Check the 128-tool budget per area is unaffected (it only shrinks).
- Browser smoke: the Recertification tab still renders for each account.
- **On the chain**: API.