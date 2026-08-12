---
id: 01KZVB1DBZXG2ZPNRSBQC69TBX
created: 2026-08-12T15:56:43.775104Z
updated: 2026-08-12T15:58:03.914915Z
type: task
title: OpenAPI types regen requires running backend
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 85
sprint: s1hm0kb
assignee: steve
imported_from: linear
label:
- follow_up
- chore
priority: low
task_status: backlog
---
`npm run gen:api` requires backend running locally. Document in `chart/README.md` (or frontend `README.md`) OR pin to a committed `openapi.json` snapshot in the repo. The latter would let `npm run gen:api` work offline / in CI.

Source: Obsidian To Do § From Brief 008b.

---

Imported from Linear [DEV-49](https://linear.app/stevevine/issue/DEV-49/openapi-types-regen-requires-running-backend) · parent DEV-14