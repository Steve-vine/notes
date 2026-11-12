---
id: 01M78ARXP3NM93DED3GZ59C8JE
created: 2026-11-12T16:52:05.955985Z
updated: 2026-11-12T16:52:08.721282Z
type: task
title: A Viewer opens a domain page without a refused request in the background
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1770
sprint: spsp226
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