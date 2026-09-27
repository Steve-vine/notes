---
id: 01M3GW3BZY8T9262ZP1KKH6VK0
created: 2026-09-27T07:26:02.238611Z
updated: 2026-09-27T07:26:11.421659Z
type: task
title: 'Every Access Control list shows the On-premises pill: users, groups, shared mailboxes and where they appear'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 772
sprint: ss8v7d0
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Requested by Steve, 2026-09-27.

Since the Business Role Update sprint, *on-premises* decides what Compass can do with an object. A synced account's leaver and a synced group's changes are made by hand in AD (ADR 0079). But the fact is shown unevenly:

| Screen | Today |
|---|---|
| Role editor | **On-premises** pill (COM-762) |
| Shared mailboxes tab | its own *Cloud / On-premises* pill + filter (COM-742) |
| Groups tab | a plain-text *Source* column ("Synced from on-premises") + filter |
| Group modal | a *Source* detail row |
| Users tab | nothing — the mirror knows (1,441 of 1,551 synced on staging), the screen doesn't say |
| User modal | nothing |

## What people see

One **On-premises** pill, looking the same everywhere as it does in the role editor, on every row or header of something synced from AD. A cloud object gets no pill. An account whose sync state Compass hasn't read yet also gets no pill: it's unknown, not cloud.

- **Users tab:** the pill beside the name, plus a **Source** filter (Cloud / On-premises), like the Groups tab's.
- **Groups tab:** the *Source* text column becomes the pill beside the name; the filter stays.
- **Shared mailboxes tab:** swaps its own pill for the shared one, and shows only *On-premises* (no *Cloud* pill), so it reads like every other list. The filter stays.
- **User modal and group modal:** the pill in the header next to the name.
- **Where people and groups appear inside other screens**, the same pill on each row:
  - a group's members
  - a user's groups
  - a shared mailbox's *Can open* / *Can send as* lists
  - a directory role's holders
  - the people on an access request

Devices and conditional-access policies aren't included: they aren't synced from AD in this sense.

## Notes

- Move `OnPremisesBadge` out of `access/RoleDetailPage.tsx` into a shared component (beside `directoryLabels.ts`), and use it everywhere. Groups read `source === 'on_premises'`; accounts read `on_premises_sync_enabled === true`.
- **The API doesn't send the account flag yet.** Add `on_premises_sync_enabled` to the user list and user modal payloads, and to the person references that request, role-holder and mailbox-access rows carry. It's already in the mirror.
- Pills never truncate (Screen conventions): the name yields.
- The Users tab filter is a new query parameter on `/directory/users`, the same shape as the Groups tab's `source`.

**Done when:** each screen in the list shows the pill on a synced object and none on a cloud one, and the Users tab filters by source. There's a test per screen, or a shared-component test plus one per list.