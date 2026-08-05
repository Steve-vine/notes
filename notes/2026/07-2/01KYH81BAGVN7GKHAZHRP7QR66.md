---
id: 01KYH81BAGVN7GKHAZHRP7QR66
created: 2026-07-27T07:36:09.808753Z
updated: 2026-08-05T12:02:57.191403Z
type: task
title: Adjust tile layout logic
project: 01KX671DATY39VW6GWK3M2T3DN
number: 323
sprint: sak4nk6
comments:
- id: 01KYHX2AKE7SYFTNZS8ZDQ7N56
  author: Steve Vine
  at: 2026-07-27T13:43:41.934314Z
  text: |-
    Done — PR #300 (feature/ise-323-tile-layout), stacked on ISE-322.

    Root cause: columnsFor rounded sqrt(count·aspect) straight to a column count, so 12 tiles on a 16:9 screen rounded to 5 → 5×3 with three gaps, while 4×3 fits exactly.

    Fix: treat the aspect value as an IDEAL and search the columns either side of it, picking the one that leaves the fewest empty cells (cols·rows − count), tie-breaking toward the ideal so tiles keep their shape. Verified: 11 → 4×3 (one unavoidable gap), 12 → 4×3 (full), 6 → 3×2, 24 → 6×4. columnsFor is now exported and unit-tested for the reported cases.

    Local gates green: build/lint/prettier + FE tests. Moving to Review.
assignee: steve
label: null
priority: medium
task_status: done
---
Always try to make the tiles fit the space with as few gaps as possible.  Current behaviour - 
I had 11 tiles, they were arranged 4 across by 3 down with one empty space - this makes perfect sense.
I added 1 additional tile, expected a full 4 by 3 grid, but instead it changed to 5 across by 3 down with 3 empty spaces.