---
id: 01KY2QTNJDPKNNTJWEXB59CAVE
created: 2026-07-21T16:23:31.661148Z
updated: 2026-07-21T17:37:24.862667Z
type: task
title: Incident search matches title as well as description — confirm or narrow
project: 01KX671DATY39VW6GWK3M2T3DN
number: 196
sprint: skj7tft
assignee: steve
label:
- follow_up
priority: low
task_status: active
---
**Follow-up from ISE-175 (released to main 2026-07-21).** The task asked for "a free-text field to filter by **description**". What shipped matches **title OR description** (`list_issues`, `q` param — case-insensitive `ILIKE`, wildcards escaped).

## Why it was widened

The incidents list shows the **Title** column; description is only visible on the detail page. Typing words an operator can plainly see on screen and getting an empty list back reads as a broken search rather than a precise one. The placeholder says "Search title & description" so the behaviour is at least declared.

## The decision

- **Keep as is** — close this, and optionally reword ISE-175's intent in hindsight.
- **Narrow to description only** — one-line change in `list_issues` (drop the `Issue.title.ilike(...)` arm of the `or_`), plus the placeholder text and two backend tests (`test_free_text_also_matches_the_title` inverts).

Genuinely low stakes either way; raised only because the shipped behaviour is wider than the written ask and that shouldn't go unrecorded.

## DoD

Either the widened behaviour is explicitly accepted, or it is narrowed and the tests/placeholder follow.