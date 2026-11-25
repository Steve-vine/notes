---
id: 01M89G3DV8Z4KX3NQ6Q51GFE2G
created: 2026-11-25T14:00:09.320584Z
updated: 2026-11-25T22:31:43.030162Z
type: task
title: A recertification review shows its removal request instead of its own Approve button, on screen, on an asset's page and through Polaris
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2168
sprint: s4qjpqd
blocked_by:
- 01M89G2Z64WRQGRM2VJVR6NVZ5
comments:
- id: 01M89VWGJXJ4RMS0X75GDGZGH4
  author: Steve Vine
  at: 2026-11-25T17:26:05.660967Z
  text: |-
    Built and merged to main: PR #2173.

    What people see:
    - The review's "N removal(s) awaiting approval" badge and its "Approve N removal(s)" button are gone. The Instances list, the review and an asset's page show "Removals: ACR-n awaiting approval" instead, linking to the request. It follows the request: approved, being removed, done, failed or rejected.
    - The evidence CSV gains five columns at the end: the request, its decision, who decided, when, and whether it was self-approved.
    - Polaris: "approve recertification removals" is retired. The review tools report the request (reference, state, approver, link), and Polaris approves it with the request tools.
    - The portal tells owners "Removals sent for approval" once a review they signed off completes with flags.

    Differences from the task:
    - Directory-role rows are still confirmed on the review ("Confirm removed in Entra"), because that's where the Entra step is done. Confirming finishes the request. The Polaris confirm tool stays for the same reason.

    Tested: integration tests for the review naming its request and the CSV carrying the approval, Polaris before and after approval, and Vitest for the link and the missing Approve button. 2,549 integration tests across recert, Polaris and portal; unit suite; CI green.

    Not checked yet: in a browser (staging pre-UAT next).
- id: 01M8A0JBEHG5ACP16SQE1Y2EGJ
  author: Steve Vine
  at: 2026-11-25T18:47:55.601247Z
  text: |-
    Pre-UAT on staging 2016209cf, E2E Test Company: **Passed**.

    What was seen:
    - The review (Recertification → Instances) shows "Completed" and "Removals: ACR-197 awaiting approval", linking to the request. There's no Approve button.
    - After Admin B rejected it, the pill read "Removals: ACR-197 rejected".
    - The evidence CSV's last five columns read: ACR-197, rejected, E2E Admin B, the time, no.
    - The API's removal_request on the review carries the same.

    Couldn't check:
    - Polaris answering "where are the removals?" — it needs Polaris's AI provider. The tool test covers the output.
    - An asset's page — there's no asset review in E2E Test Company. It uses the same view.

    Screenshots: ~/compass-uat/s4qjpqd/COM-2168/
assignee: steve
label:
- feature
priority: medium
task_status: done
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