---
id: 01M0ZTDCSV3G5GFXRX72GXSEGN
created: 2026-08-26T19:58:04.603951Z
updated: 2026-08-26T19:58:10.844966Z
type: task
title: Delete group blanks the whole app — the modal flashes and the screen goes white
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 442
sprint: s5gwx0s
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: backlog
---
Open a group from Access Control ▸ View Groups, click **Delete group…**, and a modal appears for a fraction of a second before the whole screen goes white. The URL reads `https://compass.citops.net/access/groups`. Reproduced on staging.

Nobody can raise a group-deletion request through the UI, and recovering takes a page reload.

## What changes for the reader

**Delete group… opens the deletion request form and stays open.** You pick the group — already filled in, because you opened it from that group — write a justification and submit. Nothing goes blank.

## Where to look

"White screen, then the URL you were already on" is a render crash taking the app tree with it, not a navigation — the address bar keeps `/access/groups` because nothing navigated. The brief flash says something renders and then throws on the next paint.

The flow is `access/GroupDetailModal.tsx` opening `RaiseRequestModal` with `kind="group_delete"` and `initialGroupId` — a Modal rendered inside the group's own Modal. Two things arrive a beat after the first render, which fits the timing:

- `GroupDeletePicker` seeds its `Select` with `initialGroupId` and then resolves the group's name through `useDirectoryGroup` (COM-301's fix, in `RaiseRequestModal.tsx:458`). The `Select` holds a `value` that is not in `data` until that query answers.
- The group search behind the picker resolves separately and rebuilds the option list underneath it.

Confirm the actual throw before fixing — the console will name it, and this is cheap to reproduce.

**Also worth knowing:** the app has no error boundary anywhere, so any uncaught render error blanks everything rather than the panel that failed. That is why this reads as catastrophic instead of "this modal didn't open". Out of scope here, but it is the reason the symptom looks the way it does.

## Tests

`GroupsPage.test.tsx:512` already clicks **Delete group…** and passes, so whatever throws needs the real query timing that test does not have. Extend the coverage so the form is asserted to still be on screen after the group lookup resolves, not merely that the click did something.