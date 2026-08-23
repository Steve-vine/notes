---
id: 01M0PYMFCKXJ0ACFD38TN87FRE
created: 2026-08-23T09:18:41.043373Z
updated: 2026-08-23T09:18:44.545077Z
type: task
title: 'Assessments tab: "Outstanding" section becomes "Current"'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 383
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
On the vendor detail Assessments tab, rename the top section heading **Outstanding** → **Current**.

- [ ] `AssessmentsCard.tsx:83`: the `<Text fw={600}>Outstanding</Text>` heading; update the component's doc comment (line 39) to match so the code doesn't describe a heading that no longer exists.
- [ ] Any test asserting the section label gets the new string.