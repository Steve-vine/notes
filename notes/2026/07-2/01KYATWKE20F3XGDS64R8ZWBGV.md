---
id: 01KYATWKE20F3XGDS64R8ZWBGV
created: 2026-07-24T19:50:56.194266Z
updated: 2026-08-05T12:34:32.798237Z
type: task
title: Estate explorer search box
project: 01KX671DATY39VW6GWK3M2T3DN
number: 268
sprint: s5khymf
comments:
- id: 01KYB4VJJY63H98EF209DN480S
  author: Steve Vine
  at: 2026-07-24T22:45:08.317942Z
  text: |-
    Done on feature/ise-268-explorer-search-box (PR #250 → main).

    - Search box widened to 4× (maxWidth 460→1840px), width:100% so it shrinks gracefully on a narrow header.
    - Typeahead cap raised 8→20 results; dropdown capped at maxHeight 360 with overflow-y:auto so the extra results scroll instead of running off the viewport.

    Test added: a search matching 25 entities renders exactly 20 result buttons. All 6 Estate Explorer tests pass; tsc/prettier/eslint green.
assignee: steve
priority: medium
task_status: done
---
Increase the width of the search box to 4x the current width.
Increase the maximum number of results that are shown while typing currently 8, increase to 20 and add a scroll bar for when there are more results to show.