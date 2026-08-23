---
id: 01M0PYMFCKXJ0ACFD38TN87FRE
created: 2026-08-23T09:18:41.043373Z
updated: 2026-08-23T09:58:53.140075Z
type: task
title: 'Assessments tab: "Outstanding" section becomes "Current"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 383
sprint: sbph5q5
comments:
- id: 01M0Q0XTTRMP1HBSS0ERT6SC3E
  author: Steve Vine
  at: 2026-08-23T09:58:44.823907Z
  text: |-
    Done — PR #378, merged to main as dc80507.

    `AssessmentsCard.tsx`: the section heading now reads **Current**, and the component doc comment moved with it so the code no longer describes a heading that is not on screen. The two `VendorDetailPage.test.tsx` assertions that waited on "Outstanding" wait on "Current".

    Left alone deliberately: the backend's `outstanding` flag and the component's local `outstanding` variable. That name refers to the required-but-not-assigned comparison the server makes, not to the heading — renaming it would have spread a presentation change into the API.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
On the vendor detail Assessments tab, rename the top section heading **Outstanding** → **Current**.

- [ ] `AssessmentsCard.tsx:83`: the `<Text fw={600}>Outstanding</Text>` heading; update the component's doc comment (line 39) to match so the code doesn't describe a heading that no longer exists.
- [ ] Any test asserting the section label gets the new string.