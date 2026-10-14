---
id: 01M4XJ50R67ZM3ABZSWGRRD3DB
created: 2026-10-14T15:57:59.942977Z
updated: 2026-10-14T15:58:10.92811Z
type: task
title: Send as and send on behalf on lists are recertified and watched for unrequested changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 956
sprint: s192kdq
blocked_by:
- 01M4XJ498YCGCKQXZKQ5ZGF54J
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of the POC Tweaks sprint; stacks on COM-954. It is independent of COM-955, so the two can be built side by side once COM-954 lands.

## What people see

- **Recertification.** A list's review (where lists are already recertified, COM-765) gains its senders. Each person who can send as or send on behalf is a row of its own ("Sam Jones — can send on behalf"), with the reason shown: the role, *Exception*, or *Not from a role*. A reviewer can keep it or remove it.
  - Removing it raises the change the usual way: Applied by Compass, or a to-do for AD / on-premises Exchange.
  - An unattributed right that the reviewer keeps stays as it is; a review doesn't turn it into an exception.
- **Watched for unrequested changes.** Somebody grants or removes send as or send on behalf in the admin centre or in AD, without a request. The next read finds it and it shows as an unrequested change, like a mailbox-access change.
  - **Access Control ▸ Admin ▸ Validation** gains a line for it, **List senders**, on by default and able to be switched off (ADR 0082).
  - Undoing an unrequested change follows the same routing as any other write: Exchange, AD, or a to-do (COM-765's reversal).

## Notes (technical)

- **Recert.** Add a row kind alongside the mailbox-access rows in `tasks/recert.py` (look at how `SharedMailboxAccessKind` labels are built there). Removals execute at completion through the execution task, as for any recert removal.
- **Detection.** Diff the mirror pass from COM-953 against the previous state, the same way mailbox access changes are found. Every new discriminator must be added to `_pending_item_exists` in `tasks/directory_sync.py`, or two findings collapse into one. Respect the ADR 0082 configuration switch.
- **Changes Compass made itself** are stamped at the write (COM-954) and must not come back as unrequested.
- **A to-do confirmed by observation** (ADR 0079) clears through this same read. Check the two don't double-report.

**Done when:** on staging, a send-as grant made by hand in the admin centre appears as an unrequested change within one read, and switching **List senders** off stops it. A list's review shows its senders, and removing one through the review takes the right away (or raises the to-do).