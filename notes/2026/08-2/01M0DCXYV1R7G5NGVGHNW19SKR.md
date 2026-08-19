---
id: 01M0DCXYV1R7G5NGVGHNW19SKR
created: 2026-08-19T16:16:07.521957Z
updated: 2026-08-19T16:16:18.66257Z
type: task
title: Conversations in the portal's My requests — the owner's side of the thread
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 293
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Follows COM-291. The owner's half. **My requests, not the portal vendor record** — that page is visible to every employee with portal read, and this thread is not company-visible (Steve, 2026-08-19).

- [ ] **Conversation on the My requests page** (`PortalRequestsPage`) for vendors the user owns — the same thread, oldest-first, with a composer. Reachable in one click from the row, not buried.
- [ ] **Badge next to the vendor name** with the unread count, from COM-291's batched payload. Clears when the owner reads the thread.
- [ ] **Nothing appears on `PortalVendorDetailPage`** — no card, no badge, not even for an owner. Worth a comment saying so, because the Contacts card right beside it *is* owner-editable there (COM-221) and the next person will reasonably assume this follows the same pattern.
- [ ] **The gap that needs an answer before this ships**: My requests lists requests **you raised**. Since COM-215 the requester becomes the owner, so usually the same person — but a **transferred vendor** (COM-222) or a **co-owner** owns a vendor whose request they never raised, and their thread has no row to hang off. Either My requests also lists owned vendors with an active conversation, or the badge falls back to **My Vendors**. Pick one; do not ship a thread an owner cannot reach.
- [ ] A departed author renders as a departed user, matching the internal card.
- [ ] Tests: an owner sees the thread and can post; a portal reader who owns nothing sees none; the badge counts and clears; the vendor detail page shows nothing for an owner; whichever answer the ownership gap takes, a co-owner can reach their thread.