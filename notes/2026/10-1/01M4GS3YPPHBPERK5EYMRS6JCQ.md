---
id: 01M4GS3YPPHBPERK5EYMRS6JCQ
created: 2026-10-09T16:49:37.494948Z
updated: 2026-10-09T18:35:09.001055Z
type: task
title: Mover form amendments
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 891
sprint: sme8esk
comments:
- id: 01M4GZ54VSPQ51TWC9FAGE9RFF
  author: Steve Vine
  at: 2026-10-09T18:35:08.025669Z
  text: |-
    Done — PR #880, merged to main 2026-10-09 (b2e4240a). ADR 0097. No migration. Not yet on staging at the time of writing — deploying next.

    What changed on the move form, under the group sections:
    - Role groups (n) — the groups their roles give them that this move leaves them in. Click one to see which role gives it. There is no Remove: a role's group is changed by changing the role. A group that goes with a role being taken away is in "Membership diff (managed groups)" in red, not here as well.
    - Shared mailbox diff — what the roles on the form would give and take ("+ Service Desk — can open"), then anything added or removed by name.
    - Shared mailboxes (n) — what they can open or send as now. Click one to see why they have it.
    - Add a shared mailbox — a lookup, like "Add a group". Picking one adds a green pill; click it for "Don't add".
    - Remove — on a mailbox's box. It moves up into the diff as a red pill, where the same box offers Restore.
    - A move that changes only mailbox access can be raised.
    - The approver sees "Shared mailbox access added" / "removed" on the request, by name and kind.
    - Access added this way is recorded as approved for them on that request, so it survives their next move and is said on it. Nothing changes that wasn't named.

    Decisions I made — say if any is wrong:
    1. Each kind of access is its own line: "Sales — can open" and "Sales — can send as" are added and removed separately, as they are on a role.
    2. What can be added is what some role of the company grants (and they haven't got, and the roles on the form aren't about to give). That is the existing rule for every mailbox change Compass makes — it doesn't write access to a mailbox no role grants.
    3. For the same reason, access to a mailbox no role grants is listed but has no Remove; its box says "No role grants this, so Compass doesn't change it".
    4. Access a role they will hold gives has no Remove either — take the role away to remove it. Trying either through the API is refused with that reason.
    5. Only access they hold directly is listed. Access that reaches them through a group is the group's, and isn't shown here.
    6. Somebody with no shared mailboxes, in a company where no role grants one, sees no mailbox headings at all.
    7. Headings: I used "Shared mailbox diff" and "Shared mailboxes (n)" rather than "Membership diff (shared mailboxes)" — a mailbox isn't a membership. Easy to rename.

    To check on staging after deploy:
    - Open a move for someone with roles: Role groups lists their role-given groups; take a role away and its groups move to the red diff.
    - Someone with shared mailboxes: the list, and the reason in each box.
    - Add a mailbox and remove one, raise, approve: Exchange shows both changes; the request's notes say "Mailbox access added: …" and "Mailbox access removed: …".
    - Open a second move for the same person: the added mailbox is still there, and its box says "Approved for them on request ACR-n".

    Not looked at in a real browser.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
## Group membership
The groups section shows:
- Membership diff (managed groups)
- Membership diff (manual groups)
- Manual groups (1)
- Dynamic groups (12)

What's missing is:
- Role groups ... This should show what groups the user is in because of their role, sometimes groups stay during a role move, these can't be manually changed.
- Shared Mailboxes ... What mailboxes the user has.

Shared mailboxes should also have a diff list and allow the user to add and remove them like groups as well.
