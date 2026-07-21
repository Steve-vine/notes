---
id: 01KY1ZP8YRCE560AZMQ6DPSAW4
created: 2026-07-21T09:21:41.848406Z
updated: 2026-07-21T15:30:36.284934Z
type: task
title: Incident filters
project: 01KX671DATY39VW6GWK3M2T3DN
number: 175
sprint: skj7tft
comments:
- id: 01KY2MCMT934G5JGNZSCBNF2Q7
  author: Steve Vine
  at: 2026-07-21T15:23:26.408863Z
  text: |-
    PR #158 → main, merged to staging.

    Every filter is now repeatable — ORs within itself, ANDs across — so "high or critical, and open" is expressible. A single value behaves exactly as before, so bookmarked URLs don't change meaning. MultiSelect per filter with per-filter clear, plus a "Clear filters" action that only appears once something is applied.

    **One thing to push back on if you disagree:** you asked for free-text filtering by *description*. I search title AND description, because the list column shows the title — typing words you can see on screen and getting nothing back would read as broken. Easy to narrow to description alone if you'd rather. LIKE wildcards are escaped, so `92%` searches for a percent sign.

    Also worth knowing: the persisted filter shape changed from `string | null` to `string[]`, and usePersistedState merges stored values over the defaults — a value saved by the old build would come back a string where the new code calls `.length`, crashing the page. New storage key rather than defensive coercion forever, so everyone's remembered filters reset once. Covered by a test.
assignee: steve
label: null
priority: medium
task_status: review
---
Allow filters in the incident list to be multi-selectable.

Add a free-text field to filter by description.