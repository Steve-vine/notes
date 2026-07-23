---
id: 01KY72SGWXNDKD1PK8HD2JXCBJ
created: 2026-07-23T08:52:06.173161Z
updated: 2026-07-23T11:00:30.94278Z
type: task
title: 'Taxonomy values: flag pills break row control alignment'
task_status: done
assignee: steve
priority: medium
imported_from: null
project: 01KY6W9951TW0904DT0GGJVGE7
number: 312
sprint: sf9yevt
label: null
---
## Context

Each taxonomy value row is its own CSS grid (`.values li`, DEV-959), so the flag-chips column (`auto`) sizes per row: a row carrying a "default" (or done/hidden/me) pill shrinks its label and id inputs while the rows around it don't, breaking the column alignment DEV-707 established.

## Change

Move the column tracks up to the `.values` list itself and give each row `grid-template-columns: subgrid`, so the chips column is sized once by the widest row and every row's controls stay aligned. Rows keep their own boxes (drag opacity, padding); the insert line and options panel keep spanning the full width.

## Acceptance

* With a "default" pill on one row of Task Status, all rows' label/id inputs and buttons remain exactly aligned.

---

Linear DEV-965 · Settings Window · created 2026-07-12 · done 2026-07-12