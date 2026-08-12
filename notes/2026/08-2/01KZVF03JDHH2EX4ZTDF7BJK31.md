---
id: 01KZVF03JDHH2EX4ZTDF7BJK31
created: 2026-08-12T17:05:55.277387Z
updated: 2026-08-12T17:06:54.561932Z
type: task
title: Surface engine display_name in /engines API + frontend picker
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 276
sprint: s0ht2jk
assignee: steve
imported_from: linear
label:
- feature
priority: high
task_status: done
---
**Per ADR 036.** The engine `displayName` is currently inert on the user-facing path: `EngineSummary` (the `/engines` response) omits it and the frontend picker renders `engine.name` (the slug). This surfaces it so the purpose-oriented names (the five renamed in DEV-356 + the fo…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-364](https://linear.app/stevevine/issue/DEV-364/surface-engine-display-name-in-engines-api-frontend-picker)