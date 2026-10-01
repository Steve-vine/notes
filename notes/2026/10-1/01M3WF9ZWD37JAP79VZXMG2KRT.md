---
id: 01M3WF9ZWD37JAP79VZXMG2KRT
created: 2026-10-01T19:33:20.910007Z
updated: 2026-10-01T21:25:09.710079Z
type: task
title: Role matrix shared mailboxes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 829
sprint: s0zzctz
comments:
- id: 01M3WNPJQN1G88W0SRTCK08368
  author: Steve Vine
  at: 2026-10-01T21:25:04.885688Z
  text: |-
    Merged: PR #839 (de0ea49).

    On a role's page (Access Control ▸ Role matrix ▸ a role), the shared mailboxes picker now works like the directory groups picker above it:

    - The left box lists every shared mailbox up front, scrolled, under its own heading — "Directory mailboxes". It used to stay empty ("Type to find a shared mailbox") until you typed.
    - Search narrows the list.
    - Each row shows who already reaches the mailbox — "4 can open · 1 can send as" — and its address, where a group's row shows how many members it has.
    - A mailbox drops out of the list once the role grants both kinds of access to it; one that has gone from Exchange is not offered.

    The "Granted mailboxes" box on the right is unchanged.

    I read "contain data same as the directory groups boxes do" as: filled in without typing, with a comparable line of detail per row. If you meant something else by it (the boxes' size, say), tell me.

    To check on staging: open a role and scroll to Shared mailboxes.

    Technical: access/RoleDetailPage.tsx. Not seen in a browser — covered by tests (list shows before typing with the counts, fully-granted and vanished mailboxes not offered, search narrows).
assignee: steve
label: null
priority: medium
task_status: review
---
On the Role matrix detail screen expand the shared mailboxes list boxes so that they contain data same as the directory groups boxes do.