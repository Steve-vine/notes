---
id: 01M0ZTDCSV3G5GFXRX72GXSEGN
created: 2026-08-26T19:58:04.603951Z
updated: 2026-08-27T13:49:51.158913Z
type: task
title: Delete group blanks the whole app — the modal flashes and the screen goes white
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 442
sprint: s5gwx0s
comments:
- id: 01M11QQRX1MZ99R01S9F0YBD1X
  author: Steve Vine
  at: 2026-08-27T13:49:47.809397Z
  text: |-
    Fixed and merged — PR #441, on main as 97097c2.

    The crash was an infinite render loop, not a thrown exception. GroupDeletePicker seeds its Select with the group already chosen, and a searchable Select writes the chosen option's label back into the search box — which is the query the picker searches on. The seeded option was labelled with the bare display name, while a search hit for that same group carried the member count too, so the two labels drove each other:

      q=''                          -> seeded option, label "Finance Users"
      q='Finance Users'             -> search hit,    label "Finance Users (3 members)"
      q='Finance Users (3 members)' -> matches nothing -> seeded option returns -> repeat

    React hit its update-depth limit and tore the tree down, which with no error boundary anywhere is the white screen.

    Fix: one label function for both sources — the OwnerPicker precedent, which has this exact shape and never oscillated because it labels seed and search hit identically. The query settles on a label that matches nothing, the seeded option carries that same label, so there is nothing left to flip to. Pre-filled, the field now reads "Finance Users (3 members)" — exactly as a search hit for that group already read.

    Why the existing test missed it: its search returns nothing, so only one label was ever in play. The crash was only ever reachable against a server that finds the seeded group. The new test answers the way staging does — matching on the group's name — asserts the form is still on screen after the lookup resolves, and asserts the search settles rather than oscillating. Verified it fails on the pre-fix code with the production error and passes after.

    Checked the other seeded picker (OwnerPicker) — already consistent, no second instance of this.

    Not done, and worth its own task: the app has no error boundary anywhere, which is why any render error blanks everything rather than the panel that failed. Out of scope here as the brief said.

    For smoke testing: Access Control > View Groups > open an assigned security group > Delete group... The form should open with the group pre-filled and stay open.
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: review
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