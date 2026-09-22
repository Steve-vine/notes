---
id: 01M34Y83RXQV61HDDDCZBTM9PT
created: 2026-09-22T16:12:41.629233Z
updated: 2026-09-22T16:12:59.023884Z
type: task
title: Mailbox access is watched, and can be recertified
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 741
sprint: s3nfes0
blocked_by:
- 01M34Y7PYDC14PWXMPYVM0YNB5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Once shared mailboxes are mirrored and managed, the two governance mechanisms that already exist for groups extend to them.

**Watched.** Each mirror pass compares the access on every *managed* mailbox against what Compass's own requests explain. Access that appeared or disappeared with no request behind it becomes an **unrequested change**, in the same feed as group ones, with the mailbox and the access kind named. Who made it is a stretch: Exchange's admin audit log is a separate read (`Search-UnifiedAuditLog`) and may follow as its own task — the change itself is the finding; the actor is enrichment.

**Recertified.** A recertification campaign can include shared-mailbox access: the reviewer sees *can open* / *can send as* lines beside group memberships for each person, and a removal decided in the campaign executes through the same path as everything else — one write path, recorded, refusable.

Unmanaged mailboxes are observed and shown but neither watched nor recertified, consistent with the boundary.