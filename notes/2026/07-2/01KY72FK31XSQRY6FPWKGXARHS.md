---
id: 01KY72FK31XSQRY6FPWKGXARHS
created: 2026-07-23T08:46:40.737848Z
updated: 2026-07-23T09:08:58.688428Z
type: task
title: Search and Filter bahaviour
label: null
assignee: steve
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 290
comments:
- id: 01KY72FR13C68CVY71A4Y43CQY
  author: Steve Vine
  at: 2026-07-23T08:46:45.795531Z
  text: |-
    Steve Vine · 2026-07-11:

    The Filter section of the description ends mid-sentence ("Only return …"). Per Steve's clarification in session, the completed spec is: **filters are a literal, case-insensitive substring narrowing of the list they sit on — no fuzzy matching, and they never return items from outside that list.** PR #273 implements to that spec, alongside the ID → Title → Content(match-count) search ranking.
---
Standardise Search and Filter behaviour across the app.

Add Filter to the top of the Projects and Tasks sections on Kanban, and to the Workspaces section on Workspace view

#### Search

Ranking order for results - ID, Title, Content 

* Match on ID always at top of results
* Match on Title next
* Match on content next, ranked by number of matches

#### Filter

Only show items that contain the exact text entered into the filter

---

Linear DEV-943 · Backlog · created 2026-07-11 · done 2026-07-11