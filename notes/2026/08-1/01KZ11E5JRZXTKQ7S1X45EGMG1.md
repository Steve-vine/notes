---
id: 01KZ11E5JRZXTKQ7S1X45EGMG1
created: 2026-08-02T10:48:40.792185Z
updated: 2026-08-05T12:03:15.335338Z
type: task
title: 'Nav: move Assist section below Approvals'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 479
sprint: sfv5yw0
comments:
- id: 01KZ1QV8T2C8M48R52PXJFWTH6
  author: Steve Vine
  at: 2026-08-02T17:20:18.754089Z
  text: |-
    Done — PR #418, merged to staging (ad22ce7), staging CI green and deployed.

    Assist now sits below Approvals, at the end of the ISE Core nav section. It previously sat between Incidents and Events, interrupting a run of estate screens.

    Added a test asserting the position, since the ordering is now a deliberate choice rather than an accident of when the item was added.
assignee: steve
label: null
priority: medium
task_status: done
---
UI tweak — move the Assist section down so it sits below the Approvals section (left nav section ordering, `components/nav.ts`).