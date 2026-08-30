---
id: 01M19J2YNAF9YG6N7KC671TCN4
created: 2026-08-30T14:44:58.154771Z
updated: 2026-08-30T16:01:12.995294Z
type: task
title: The browse tabs are named for what they hold, and Users comes before Groups
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 537
sprint: sz42uhw
comments:
- id: 01M19PE15NDVXR6RR60HZ3KD9X
  author: Steve Vine
  at: 2026-08-30T16:00:55.477757Z
  text: |-
    Done — PR #542, merged to main.

    View Groups → Groups, View Users → Users, View Devices → Devices, and Users now leads Groups. The rest of the tab bar keeps its order. Directory Roles keeps its name (COM-445) — there is no second Groups, Users or Devices for the renamed tabs to be confused with, so nothing reintroduces that clash.

    Labels only. Every tab `value` is the URL segment and none of them changed, so /access/groups, /access/users and /access/devices still resolve — pasted links and notification links are untouched.

    Also repointed the comments in DevicesPage.tsx, hooks.ts, directoryLabels.ts, GroupDetailModal.tsx, PageSizeControl.tsx and the page's own docstring, which named the old labels in passing.

    AppLayout.test.tsx:175 asserted "View Users" was absent from the sidebar as evidence the old Access section is gone. After the rename it would still have passed while asserting the absence of a string nothing renders any more, so it now names a tab label that is still real (Directory Roles).

    Verified: AccessControlPage.test.tsx covers the full bar in order and the URL→tab marking for /access/users and /access/devices; 23 tests green across the two touched files, full frontend suite green in CI.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: low
task_status: review
---
Three tabs in Access Control still carry a "View" prefix from when they were sidebar entries. Every tab is a view; saying so on three of thirteen tells a reader nothing and costs the tab bar width it has none of.

- **View Groups** → **Groups**
- **View Users** → **Users**
- **View Devices** → **Devices**

And Users moves in front of Groups. The people are what somebody arrives looking for; the groups are how they got their access.

The rest of the bar keeps its order, so the tabs on either side of the three are where they were.

## Labels only

The tab `value` is the URL segment, and every one of them stays exactly as it is. `/access/groups`, `/access/users`, `/access/devices` are pasted between people and followed from notifications (COM-342 kept them for that reason), and a rename that moved them would break links for a word.

## Notes

- One place: the `TABS` list in `AccessControlPage.tsx`.
- **Directory Roles keeps its name**, and the comment above it stays true — it is named for what it holds rather than "View …" because the bar already opens with a *Role matrix* meaning business roles, and the two must not read as the same thing (COM-445). Nothing here reintroduces that clash: there is no second Groups, Users or Devices to be confused with.
- Two page comments mention the old names in passing (`DevicesPage.tsx`, `hooks.ts`, `directoryLabels.ts`) — worth updating so the next reader is not looking for a tab that is not there.
- `AppLayout.test.tsx:175` asserts `View Users` is absent from the sidebar, as evidence the old Access section is gone. It will still pass after the rename and will have stopped meaning anything — point it at a string that is still real, or at the assertion it was actually making.
