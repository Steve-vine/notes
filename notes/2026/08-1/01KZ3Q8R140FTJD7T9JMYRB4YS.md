---
id: 01KZ3Q8R140FTJD7T9JMYRB4YS
created: 2026-08-03T11:48:40.612814Z
updated: 2026-08-05T14:25:18.062479Z
type: task
title: 'Pack interpreter core: auth, pagination, retry menus'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 502
sprint: s1mg25q
assignee: steve
label: null
priority: medium
task_status: backlog
---
The generic HTTP engine a pack drives: auth schemes (header token / basic / client-credentials OAuth), pagination styles (nextLink follow / page counter / Link header / offset), the standard bounded Retry-After 429 retry, page caps and runaway guards, per-System containment on failure. Headless core with contract tests against fakes; no pack-authored code ever executes — the interpreter is the only executable.