---
id: 01M11XJ1YB4Q88FC68HCYRH1QD
created: 2026-08-27T15:31:31.915417Z
updated: 2026-08-27T15:31:31.915417Z
type: task
title: The pre-filled delete-group field opens a list you can click to empty it
company: moneypenny
label: bug
priority: medium
task_status: active
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 463
---
Follow-on defect from COM-442, found smoke-testing staging.

Open a group from Access Control ▸ View Groups and click **Delete group…**. The form opens with the group already filled in — and a dropdown list hanging open below it showing that same group, the only entry. Click that entry and the field empties completely, leaving the form unsubmittable.

The field arrives already answered. There is nothing to choose, so there should be no list, and clicking the group you are already deleting should certainly not un-choose it.

## What changes for the reader

**No list when the group is already chosen.** The form opens showing the group and nothing else; you write the justification and submit. Clicking the field still opens the list if you genuinely want a different group, and the un-seeded form — raising a deletion from the Requests page, where you do have to search — is unchanged.

**Re-picking the group you already picked leaves it picked.** The field can no longer be emptied by clicking its own entry.

## Where to look

Both halves are Mantine `Select` defaults doing exactly what they are documented to do, in `access/RaiseRequestModal.tsx`'s `GroupDeletePicker`:

- `openOnFocus` defaults to **true**, and the field carries `data-autofocus` so the modal focuses it on open — which opens the list. Wanted when the field is empty, noise when it is not.
- `allowDeselect` defaults to **true**, so clicking the option that is already the value resolves to `null`. For a required field that is only ever destructive.

Note this does not reproduce in jsdom: its autofocus does not fire the focus event Mantine listens on, so the list never opens in a test. The deselect half does reproduce and is worth asserting; the open-on-focus half is a prop assertion plus a look at the real screen.

## Scope

The picker only. Not the group modal, not the request flow, and not the other pickers — `OwnerPicker` has the same shape but is an optional field where clearing is a legitimate thing to want.