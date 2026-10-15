---
id: 01M4XJ50R67ZM3ABZSWGRRD3DB
created: 2026-10-14T15:57:59.942977Z
updated: 2026-10-15T14:45:59.002284Z
type: task
title: Send as and send on behalf on lists are recertified and watched for unrequested changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 956
sprint: s192kdq
blocked_by:
- 01M4XJ498YCGCKQXZKQ5ZGF54J
comments:
- id: 01M4XRR6C436YC4QHPQP6NRKQQ
  author: Steve Vine
  at: 2026-10-14T17:53:19.748588Z
  text: |-
    Done — PR #950, merged to main. Going to staging now with the other four.

    What to look at:
    - **Access Control ▸ Admin ▸ Validation (What Compass watches):** a new row, **List senders (send as, send on behalf)**, with *access granted* and *access removed* switches, on by default.
    - **Unrequested changes:** give someone send as on a list in the admin centre by hand. After the next hourly list read (ten past the hour), it appears as "Ada can now send as Sales UK". It goes under *Needs validation* if some role gives that right on that list, *For information* otherwise. Something Compass did itself through a request doesn't show up. The very first read after the deploy is a baseline and raises nothing.
    - **Recertification:** a review of a list (Recertifications ▸ schedule a **Group** review of a distribution list) now has a row per person and right: "Grace — Send as · direct", beside the members. Flag one and approve the removal. Compass takes it away through Exchange, or in AD for send on behalf of an on-premises list in a managed OU. Where it can't, the row stays *approved*, says "To be removed by hand, in AD", and offers **Confirm removed**.

    Found while doing this, not changed: when a review is completed by two attestors in the portal, flagged rows for *direct shared-mailbox access* are never sent to Exchange; only the separate "approve removals" path sends them. List rights go out through both paths. The mailbox gap looks like it dates from COM-741. I've left it alone; worth a bug task if you agree.

    Technical: migration 0257 (two unrequested kinds, recert item source list_sender, unrequested_changes.list_right_kind). Detection lives in the list-senders pass; AD-only setups don't detect list-right drift yet.
assignee: steve
label:
- feature
priority: medium
task_status: done
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