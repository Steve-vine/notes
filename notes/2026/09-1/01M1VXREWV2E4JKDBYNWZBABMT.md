---
id: 01M1VXREWV2E4JKDBYNWZBABMT
created: 2026-09-06T17:55:17.019233Z
updated: 2026-09-06T21:24:52.597416Z
type: task
title: Correcting your own suggestion, and an admin triaging anyone's
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 602
sprint: scx5myr
blocked_by:
- 01M1VXR15W5TVB1Z55WYYHYQKQ
comments:
- id: 01M1W3SS91QRPMXNF4Y1ZZDGSH
  author: Steve Vine
  at: 2026-09-06T19:40:51.873405Z
  text: |-
    Done — PR #611 merged to main.

    - The author gets an Edit pencil on their own rows only, opening the same two fields in place with Save/Cancel. No status control, no Delete.
    - A holder of "Manage suggestions" gets Edit on every row, a status picker on the row that saves on change (no separate Save), and Delete behind a confirm that names the title: Delete "…"? It goes from everyone's list, and whoever wrote it is not told.
    - Driven off usePermissions().has('admin.manage_suggestions') and the row's author against the signed-in user; the server enforces both rules on its own.
    - suggestions/hooks.ts: useUpdateSuggestion, useDeleteSuggestion.

    Smoke-test as admin: change a status from the picker — the pill should follow with no Save press; delete one and confirm the wording. Then as a non-admin (e.g. a viewer): raise one, see Edit on it and nothing on anyone else's row.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
A list you can only read is a suggestion box with the lid nailed shut. Two people can change a row, and they can change different things.

## The author

Anyone can correct or expand **their own** suggestion, at any time — an **Edit** on their own rows only, opening the same two fields in place. Nothing else: they cannot move their own idea to Planned.

## The administrator

With `admin.manage_suggestions`, on **every** row:

* **Edit** the title and description — tidying a title so the list stays readable.
* **Set the status** — New, Under review, Planned, Done, Declined. A `Select` on the row, saving on change; no separate Save, because a one-field change with its own button is a button nobody presses.
* **Delete** — behind a confirm naming the suggestion's title, because it is gone from everyone's list and the person who wrote it gets no warning. Soft delete server-side, but say "Delete", not "Archive": what the reader is told must match what the reader sees.

Drive all three off `usePermissions().has('admin.manage_suggestions')` and the row's author id against the signed-in user. The server enforces both rules independently (COM-599) — this is about not showing people buttons that will 403.

## Tests

- [ ] An ordinary user sees Edit on their own row and on no other; no status control, no Delete, anywhere.
- [ ] A manager sees Edit, the status Select and Delete on someone else's row.
- [ ] Changing the status saves without a Save press and the pill updates.
- [ ] Delete asks first, names the title in the question, and the row goes on confirm.
- [ ] Cancelling the confirm changes nothing.

## Related

- COM-599 — the PATCH and DELETE rules this reflects, and the new permission.
- COM-601 — the rows these controls sit on. Blocked on it.
