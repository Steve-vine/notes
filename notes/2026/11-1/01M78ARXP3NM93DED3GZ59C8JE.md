---
id: 01M78ARXP3NM93DED3GZ59C8JE
created: 2026-11-12T16:52:05.955985Z
updated: 2026-11-12T17:25:25.143708Z
type: task
title: A Viewer opens a domain page without a refused request in the background
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1770
sprint: spsp226
comments:
- id: 01M78CNY0QPE8G5CYSE7QB9H37
  author: Steve Vine
  at: 2026-11-12T17:25:25.143576Z
  text: 'More detail from the COM-1767 builder (2026-11-12): document (content) pages do it too, not just domain pages. Cause: `useUsers` in app/frontend/src/content/hooks.ts asks for the people list (administrators only), called from DomainDetailPage and ContentDetailPage regardless of the viewer''s rights.'
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12). Not caused by round 3.

**What happens:** as E2E Viewer, opening a domain page (/domains/access-control) logs `GET /api/v1/users` → 403 in the browser console. Reproduced on its own. The page otherwise works.

**What it should do:** the page doesn't ask for something the Viewer can't read (e.g. the people list behind an owner picker only loads for someone who can edit), so nothing shows in the console.

**Done when:** the Viewer opens a domain page with a clean console; someone who can edit still gets the picker; a test covers the Viewer case. Frontend only, independent.