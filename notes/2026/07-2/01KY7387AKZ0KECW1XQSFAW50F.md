---
id: 01KY7387AKZ0KECW1XQSFAW50F
created: 2026-07-23T09:00:07.891095Z
updated: 2026-07-23T15:04:47.32876Z
type: task
title: Comments not rendering markdown
project: 01KY6W9951TW0904DT0GGJVGE7
number: 366
sprint: segj1dz
comments:
- id: 01KY7R3XZ0ZVXH92K7Y3CV2PDR
  author: Steve Vine
  at: 2026-07-23T15:04:47.328356Z
  text: 'PR #355 (branch not-366-comment-markdown): comments now render through the shared renderMarkdown pipeline (DOMPurify-sanitised) with compact comment styling; fenced code blocks reuse the global .code-block styles. svelte-check + 195 frontend tests green.'
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Comments on notes aren't rendering markdown at all.

---

Linear DEV-1019 · Enhancements · created 2026-07-23 · backlog