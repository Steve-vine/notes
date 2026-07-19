---
id: 01KXGX0T4WGH01BYT98ECMC34C
created: 2026-07-14T18:07:56.060003791Z
updated: 2026-07-14T18:08:04.994121847Z
type: task
title: Preview for uploaded files
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 145
sprint: ssdk92z
comments:
- id: 01KXGX12W2F9DH8M5KA9XV36FQ
  author: Steve Vine
  at: 2026-07-14T18:08:04.99399471Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 17:01 UTC]
    Investigated + implemented: https://github.com/Steve-vine/compass/pull/137 (stacked on #136).

    Findings: only PDFs were served `inline`; everything else forced a download, and browsers can't render Office formats natively regardless. The fix: browser-renderable types (PDF, images, text; CSV/Markdown re-typed as plain text) now preview inline on click; the Download button uses a new `?download=true` to keep forcing the attachment; and Office files route through the existing worker LibreOffice render, opening the PDF in a new tab — so every uploaded type gets the same click-to-preview.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Currently clicking on an uploaded PDF file will display it in another window, whereas clicking on a .xlsx, .md  file etc. will prompt a download.  Investigate if there is a way to preview other files types to give a consistent experience.

---
*Migrated from Linear [DEV-791](https://linear.app/stevevine/issue/DEV-791/preview-for-uploaded-files) · created 2026-07-03 · completed 2026-07-03*  
*Related to (Linear): DEV-790*