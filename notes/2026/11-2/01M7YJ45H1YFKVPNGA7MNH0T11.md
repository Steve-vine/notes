---
id: 01M7YJ45H1YFKVPNGA7MNH0T11
created: 2026-11-21T08:03:51.969074Z
updated: 2026-11-21T08:03:55.598907Z
type: task
title: 'Browser smoke: the control evidence journey adds its web address through the Add evidence window'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2051
sprint: s9hexqn
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found on the staging deploy of the Evidence Improvements sprint (7e04d3f5e, 2026-11-21). The Browser smoke's journey 8 ("a control's evidence shows its status, and a person sets it") still opens the old Add evidence dialog and clicks "Add a link". COM-2041 and COM-2043 replaced that dialog with the Add evidence window, so the journey times out. The other 36 checks passed. The product isn't broken; the test is out of date.

**Done when**
- Journey 8 adds its web address through the Add evidence window (Add new evidence ▸ Web address ▸ Add, then a title, evidence type and classification, then Upload 1). It still checks that the piece starts Unchecked and that a person can set it to Compliant.
- The Browser smoke is green on staging.

Independent: test only.