---
id: 01M7878TZDD2HAAXC6ZRK1BAE6
created: 2026-11-12T15:50:53.165831Z
updated: 2026-11-12T15:50:55.706259Z
type: task
title: A row of fields with no hints has no extra gap between each label and its box
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1764
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: todo
---
Found by the COM-1757 builder (sprint 116 round 3, 2026-11-12).

**What happens:** a row of fields laid out to stack on a phone (FieldRow with `cols`, COM-1623) shows an extra gap between each field's label and its input when no field in the row has a description (hint). Visible on the technology asset form's Hosting row (Hosting | Form | Hosting detail) and the Make / Model / Serial number row.

**What it should do:** a row where no field has a hint looks like any plain row: label directly above its box. A row where some field has a hint still lines up, as today.

**Done when:** the Hosting and Make rows on the technology asset form show no extra gap; rows with hints still line up; light and dark, desktop and phone width checked; the screen-conventions test still passes. Frontend only, independent (shared FieldRow CSS).