---
id: 01KXGWWRSM4HY6HHZA467NF82N
created: 2026-07-14T18:05:43.604526556Z
updated: 2026-07-14T18:05:43.604526556Z
type: task
title: Upload duplicate templates
label: improvement
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 139
---
It seems to be possible to upload the same template more that once, that is, a template with the same name.  This is presumably possible because the slug is generated on upload, however it means that when selecting the template from the Template dropdown in mappings, there are two option with the same name.

When uploading a template, if one already exists with the same 'display' name, it should append -2, -3, -4 etc to the end of the file.

---
*Migrated from Linear [DEV-785](https://linear.app/stevevine/issue/DEV-785/upload-duplicate-templates) · created 2026-07-03 · completed 2026-07-03*