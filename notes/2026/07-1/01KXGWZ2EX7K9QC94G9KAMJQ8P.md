---
id: 01KXGWZ2EX7K9QC94G9KAMJQ8P
created: 2026-07-14T18:06:59.037129488Z
updated: 2026-07-14T18:07:06.61088816Z
type: task
title: Multi-document select
task_status: done
label:
- feature
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 142
sprint: ssdk92z
comments:
- id: 01KXGWZ9VJA8X34FJ8S9YGEAB5
  author: Steve Vine
  at: 2026-07-14T18:07:06.61077538Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 16:54 UTC]
    PR up: https://github.com/Steve-vine/compass/pull/134 (stacked on #133). All rows selectable; Generate PDFs (templated), Export PDFs (managed), Download PDFs (uploaded, renderable files), linked increments nothing; Delete (n) confirms with the selected list. The bulk zip pipeline now dispatches per kind on the worker.
---
Allow tickboxes on all content types on the content list page.

Currently when selecting a Templated type content a Generate PDF's button appears, create a similar buttons that triggers off the Managed type called 'Export PDFs ()', and the Uploaded type called 'Download PDFs ()'.  Ticking the appropriate content type applies to each button document count and function.  Ticking the Linked type doesn't increment anything.

Add an addition button called 'Delete' that confirms with a list of all the content currently selected, and delete it.

---
*Migrated from Linear [DEV-788](https://linear.app/stevevine/issue/DEV-788/multi-document-select) · created 2026-07-03 · completed 2026-07-03*  
*Related to (Linear): DEV-786*