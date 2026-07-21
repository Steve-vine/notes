---
id: 01KY0J1RN0X6MVYNH4FRK3P9VK
created: 2026-07-20T20:04:03.872606Z
updated: 2026-07-21T16:17:11.716451Z
type: task
title: Add year to incident timeline audit-line timestamps
project: 01KX671DATY39VW6GWK3M2T3DN
number: 168
order: 1.0
sprint: skj7tft
assignee: steve
priority: medium
task_status: done
---
Follow-up to ISE-160 (done): the agreed format left the year off the timestamp. Update the audit-line format on the incident timeline from:

> `Mon 20 Jul 17:21 - Steve Vine - Resolved incident`

to:

> `Mon 20 Jul 2026 | 17:21 - Steve Vine - Resolved incident`

Two changes to the timestamp segment: add the **year** after the date, and separate date from time with ` | ` instead of a space. The name and action-first wording segments are unchanged from ISE-160.

Frontend-only — the ISE-160 rendering in `IssueTimeline.tsx` (audit-line formatter); update its tests to the new format.