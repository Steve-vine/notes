---
id: 01KZ8VJX321XFZR6M5EX5MRE28
created: 2026-08-05T11:40:19.938447Z
updated: 2026-08-05T14:49:06.555563Z
type: task
title: Estate list Type
project: 01KX671DATY39VW6GWK3M2T3DN
number: 555
sprint: skxht3g
comments:
- id: 01KZ8ZR1JDG0QQD5EANAH8QDV8
  author: Steve Vine
  at: 2026-08-05T12:53:02.669043Z
  text: |-
    Fixed on feature/ise-555-estate-type-column — PR #470 (green, merged to staging).

    Cause: the Type column was fixed at `w={120}` in EstatePage.tsx. A Mantine Badge is `max-width: 100%` with `text-overflow: ellipsis`, so any type wider than the column silently truncates rather than wrapping — `kubernetes-service`, `private-endpoint`, `business-service` and `app-registration` all rendered cut off.

    Widened to 190px, sized to the widest member of ENTITY_TYPES rather than to whichever types happen to be in the estate today.

    No automated guard: jsdom performs no layout, so a column-width regression cannot fail a vitest assertion. This is a visual check on staging.
assignee: steve
priority: medium
task_status: review
---
In the list, the first column ‘Type’ doesn’t show the full name due to the column width. Increase the column width so that the full type name is visible.