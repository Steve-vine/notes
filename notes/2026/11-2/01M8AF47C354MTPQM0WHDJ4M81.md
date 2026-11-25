---
id: 01M8AF47C354MTPQM0WHDJ4M81
created: 2026-11-25T23:02:21.315891Z
updated: 2026-11-25T23:05:19.277956Z
type: task
title: A shared mailbox and a directory role open in a popup like a person, group or device — and all five popups are wider
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2175
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
**Independent** (screens only — no migration, no API change).

On Access Control, **Users**, **Groups** and **Devices** open a row's details in a popup over the list. **Shared mailboxes** and **Directory roles** go to a page of their own instead. That's not a decision anyone made: the first three were built together as one pattern in August (COM-253 / 255 / 387). The directory-role page (COM-445) grew out of making the role pill clickable, and the shared-mailbox page (COM-742) copied it.

It also breaks the rule in `brief/information-architecture.md` → *A modal opens over what you were reading*. Clicking a role pill in a person's popup today navigates away and loses the popup. Steve's call (25 Nov): make them popups, and make all five wider.

## What people see

- Clicking a **shared mailbox** or a **directory role**, from its tab or from a link elsewhere, opens it in a popup over what you were reading. Closing it, or pressing Escape, puts you back exactly where you were.
  - The links elsewhere include a role pill in a person's or group's popup, and a mailbox in a person's Shared mailboxes section.
- The popups show what the pages show today. A role: what it is, its active and eligible holders, direct or through which group, and the "eligible couldn't be read" warning. A mailbox: who can open it and who can send as it (and send on behalf, once COM-2173 lands).
- **Two deep, and the second is a leaf.** From a role or mailbox popup, a person or group opens one more popup on top. From there, further links swap that popup's content rather than stacking a third.
- **Each popup keeps its own address.** Ctrl/cmd-click and "open in new tab" still work, and a pasted link or a notification still opens it (as a full page when there's nothing underneath), so nothing that links to these today breaks.
- **All five popups are wider:** person, group, device, shared mailbox and directory role go from about 620px to about 960px. They stay inside the window on a smaller screen, and fill the screen on a phone. All five use one shared width, so they stay the same as each other.

## Notes (technical)

- Follow the brief's shape: keep the routing (id from the URL, fetch) apart from the content. Turn `SharedMailboxDetailPage.tsx` and `DirectoryRoleDetailPage.tsx` into a content component plus a thin route, the way the existing modals are opened. Keep the routes `access/shared-mailboxes/:id` and `access/directory-roles/:id` (`App.tsx` ~815) resolving for direct links.
- Links stay real anchors; only the plain left-click is intercepted (brief rule 3). Update `PrivilegeBadge`'s role link and the mailbox links in `UserDetailModal.tsx` / `MoverMailboxes.tsx` to open over rather than navigate.
- Width: `UserDetailModal`, `GroupDetailModal` and `DeviceDetailModal` all use `size="lg"` today. Introduce one shared size constant for the five Access detail popups rather than five literals. Leave `CaPolicyDetailModal` as is unless it reads oddly beside them, and say if it's changed.
- Check the trail label (`useTrailLabel`) and the Browser smoke journeys that visit these two pages (`app/e2e`). Update the journeys to the popup.
- `screen-conventions.test.ts`: make sure the moved tables keep `SortableTh` / no-sort markers.

**Done when:** on staging:
- Clicking a role pill in a person's popup opens the role over it, and Escape returns to the person with nothing reloaded.
- Clicking a mailbox on the Shared mailboxes tab opens a popup over the list, and a holder in it opens the person on top.
- Pasting a role's or mailbox's address into a new tab still opens it.
- All five popups are visibly wider and the same width as each other.