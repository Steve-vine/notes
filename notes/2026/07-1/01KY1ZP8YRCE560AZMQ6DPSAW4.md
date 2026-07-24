---
id: 01KY1ZP8YRCE560AZMQ6DPSAW4
created: 2026-07-21T09:21:41.848406Z
updated: 2026-07-24T13:29:18.229951Z
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
- id: 01KY2PA8YDYQH5K095FHAQ6XJ5
  author: Steve Vine
  at: 2026-07-21T15:57:05.868979Z
  text: |-
    Follow-up fix (smoke test finding): the MultiSelect stacked every ticked item as a pill inside the field, so the filter row grew taller with each tick and shoved the controls beside it down.

    Replaced with a `CheckboxFilter` tick list. The trigger is now fixed-height whatever is ticked — placeholder when nothing is on, the value's own name at one, "N selected" beyond that — and the picking happens in a dropdown with checkboxes. Deliberately not Mantine's `maxDisplayedValues`: capping the pills still changes height between one and two rows, and still lets the labels set the width.

    Extracted as a shared component so all four filters stay uniform. Added the accessibility the pattern needs (an aria-label naming each filter, since the visible text changes with the selection; aria-expanded on the trigger; aria-multiselectable on the list; aria-selected per option — Mantine's `active` prop is styling only, so without it a screen reader couldn't tell what was ticked).

    Also fixed a real bug the merge surfaced: the "Show merged" switch read `e.currentTarget.checked` inside the state updater, which runs after the handler returns — by which point currentTarget is null. Would have thrown on every toggle.

    10 component tests + updated page tests. Re-merged to staging.
assignee: steve
priority: medium
task_status: done
---
Allow filters in the incident list to be multi-selectable.

Add a free-text field to filter by description.