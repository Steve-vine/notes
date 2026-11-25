---
id: 01M88E4WAZRZPHT7MG6JFEQD4C
created: 2026-11-25T04:06:45.343593Z
updated: 2026-11-25T04:06:45.343593Z
type: task
title: Editing an amendment request only asks for and shows what it actually changes
assignee: steve
label: bug
task_status: active
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2161
---
Sprint "Vendor Departments". Found in the round 2 pre-UAT of COM-2143 on staging a63d542b2 (25 Nov 2026). Screenshots: `~/compass-uat/sectbn9/COM-2143/03*`, `04*`, `06*`, `07*`.

## The problem
1. **Edit request on an amendment demands an annual cost the engagement never had.** As E2E Asset Owner, an amendment on "E2E Departments 1503 Engagement A1" (no cost) changing only the criticality. After the approver asks for information, Edit request refuses to save: "Estimated annual cost: Required." The requester has to invent a cost, which then becomes part of the amendment.
2. **After that edit, unchanged fields show as changes.** My requests' summary adds "Changed data types from none to none" and "Changed data entities from none to none". The approver's diff lists "title: X → X", "scope: X → X", "data types: — → —". The activity log reads "title unchanged → …; data types unchanged → none".

## What people see
- Editing an amendment shows what it proposes and lets the requester change it. A field the amendment doesn't propose can be left alone; nothing is required that the amendment doesn't change.
- After the edit, the summary, the approver's diff and the activity log list only the fields the amendment actually changes (e.g. criticality Low → High), never "none → none" or "X → X".
- New-vendor and new-engagement edits behave as now.

## Done when
- In E2E Test Company: an amendment changing only criticality can be edited after "Request info" without typing a cost. The summary, diff and log show only the criticality change.
- An amendment that proposes cost or departments still edits and shows those correctly.
- The open amendment on Engagement A1 (left by the pre-UAT, with a typed £500) reads sensibly.

Independent unless it needs an API change.