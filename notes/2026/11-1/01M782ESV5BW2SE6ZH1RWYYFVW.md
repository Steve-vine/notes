---
id: 01M782ESV5BW2SE6ZH1RWYYFVW
created: 2026-11-12T14:26:45.73399Z
updated: 2026-11-12T14:32:03.669424Z
type: task
title: Archiving a piece of evidence from its own page logs no error in the browser
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1760
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in the sprint 116 round-2 pre-UAT pass on staging (2026-11-12), area of COM-1738. Seen twice.

**What happens:** as Admin A in E2E Test Company, open a current piece of evidence (e.g. from Audit ▸ Evidence ▸ Register), click Archive, choose a reason, confirm. It archives correctly, but the browser console logs a 409 on `GET /api/v1/audit/<company>/evidence/file/<id>/archive-options`: after the archive, the page asks again for the archive options of a piece that is now archived. The Browser smoke never archives, so it doesn't catch this.

**What it should do:** archiving from the piece's page shows the piece as archived with no request failing and nothing in the console. The archive options are only asked for while the piece is current (or dropped from the cache once it's archived).

**Done when:** archiving a piece from its own page logs no errors in the browser console, and the page then shows it archived with Delete permanently… available. Frontend only, independent.