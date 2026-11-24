---
id: 01M872522KS94MA5JQ5EHMZFBZ
created: 2026-11-24T15:17:53.875138Z
updated: 2026-11-24T15:17:58.998807Z
type: task
title: Pressing Enter in the Add department window saves it, as it does in the Create company window
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2142
sprint: sectbn9
assignee: steve
label:
- bug
priority: low
task_status: active
---
Sprint "Vendor Departments". Found in the pre-UAT pass of COM-2131 on staging 0234a65f3 (24 Nov 2026).

## The problem
Admin → Companies → a company → Departments → Add department: typing a name and pressing Enter does nothing. You have to click Add. The Create company window's Departments section (COM-2132) does take Enter, so the two behave differently.

## What people see
- In the Add department window, and in Rename, pressing Enter saves, just as clicking the button does.
- A duplicate or empty name is refused the same way as with the button.

## Done when
- Enter saves in both the Add and Rename windows, and a duplicate still shows its message.

Independent: screen only, no migration or API change.