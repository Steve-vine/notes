---
id: 01KXGXCZJ7BTX38F2XZPDQ2MYF
created: 2026-07-14T18:14:34.823445284Z
updated: 2026-07-14T18:17:20.304393532Z
type: task
title: Convert to PDF for uploaded content
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 154
sprint: ssdk92z
comments:
- id: 01KXGXD6XTSK22FMXEQXQAV192
  author: Steve Vine
  at: 2026-07-14T18:14:42.362127339Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-04 09:16 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/145 (stacked on #144). Uploaded content is download-only everywhere: detail header keeps just Download, the file-card link serves the original (previewable types still open in a tab), the list bulk button is now "Download (n)" fetching originals (zip via a new `/content-files` endpoint for multiple), and the PDF pipeline refuses the uploaded kind server-side — the conversion task is deleted.
label: null
---
This just doesn't seem to work well for non Word documents.

Change the behaviour for uploaded content to just download.  This should apply to the button and link on the detail page and the tickbox/button on the list page.

No more convert to PDF for uploaded content.

---
*Migrated from Linear [DEV-817](https://linear.app/stevevine/issue/DEV-817/convert-to-pdf-for-uploaded-content) · created 2026-07-04 · completed 2026-07-04*  
*Related to (Linear): DEV-818*