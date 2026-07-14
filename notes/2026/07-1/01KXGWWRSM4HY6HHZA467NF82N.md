---
id: 01KXGWWRSM4HY6HHZA467NF82N
created: 2026-07-14T18:05:43.604526556Z
updated: 2026-07-14T18:05:53.252333435Z
type: task
title: Upload duplicate templates
label:
- improvement
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 139
sprint: ssdk92z
comments:
- id: 01KXGWX274TB9ZB8TFQBEVPYWE
  author: Steve Vine
  at: 2026-07-14T18:05:53.252217006Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 17:07 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/139 (based on main — independent of the UI stack). Uploads now de-duplicate the display name: a clash becomes Policy-2, Policy-3, …; deleted templates free their name. Integration-tested.
---
It seems to be possible to upload the same template more that once, that is, a template with the same name.  This is presumably possible because the slug is generated on upload, however it means that when selecting the template from the Template dropdown in mappings, there are two option with the same name.

When uploading a template, if one already exists with the same 'display' name, it should append -2, -3, -4 etc to the end of the file.

---
*Migrated from Linear [DEV-785](https://linear.app/stevevine/issue/DEV-785/upload-duplicate-templates) · created 2026-07-03 · completed 2026-07-03*