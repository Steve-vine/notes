---
id: 01KZVF44JV6VS654KBRP28Y3A3
created: 2026-08-12T17:08:07.387125Z
updated: 2026-08-12T17:11:09.945093Z
type: task
title: Custom-setting names with `/` don't round-trip through the {name} path param
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 289
sprint: set2ygr
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
From the P2 (DEV-327) session summary. The `/api/v1/custom-settings/{name}` routes take the setting name as a path param, so a name containing `/` (or other path-reserved characters) would not round-trip on GET/PUT/DELETE.

**Currently mitigated:** the company-settings UI never generates such…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-332](https://linear.app/stevevine/issue/DEV-332/custom-setting-names-with-dont-round-trip-through-the-name-path-param)