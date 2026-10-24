---
id: 01M5Q16A4HB2AQG6FFMDDTYVSY
created: 2026-10-24T13:21:51.761729Z
updated: 2026-10-24T13:21:54.54194Z
type: task
title: When Compass can't be reached, a page says "Not found" — it should say it couldn't load and offer to try again, and never call a DDQ that exists missing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1285
sprint: ssgnel8
assignee: steve
priority: medium
task_status: todo
---
Found running DDQ-3, 2026-10-24. Steve assigned a question; the API was killed for memory a second later (COM-1284); the DDQ page refreshed, its load failed, and the page showed "Not found". Reloading a minute later showed DDQ-3 as normal.

DdqRequestPage renders "Not found" whenever it has no DDQ after loading, so a failed request reads the same as a missing one. DdqAssignedQuestionPage, DsrRequestPage, DsrDisclosurePage, ContentDetailPage, DecisionDetailPage and the Audit evidence pages use the same pattern.

**Do:** tell the two apart.
- **The DDQ, request or document doesn't exist, or you can't see it:** say so, as now.
- **The server couldn't be reached or returned an error:** say "Compass couldn't load this — try again" with a retry, and keep anything already shown on the page.

Use one shared pattern across the detail pages, not a fix to each one.