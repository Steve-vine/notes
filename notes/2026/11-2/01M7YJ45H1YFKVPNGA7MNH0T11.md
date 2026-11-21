---
id: 01M7YJ45H1YFKVPNGA7MNH0T11
created: 2026-11-21T08:03:51.969074Z
updated: 2026-11-21T08:35:03.549478Z
type: task
title: 'Browser smoke: the control evidence journey adds its web address through the Add evidence window'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2051
sprint: s9hexqn
comments:
- id: 01M7YKWXP2PE8KR6MKDF7T2DBS
  author: Steve Vine
  at: 2026-11-21T08:34:51.714751Z
  text: |-
    Done and merged to main (PR #2045). This changes the test only, not the app.

    The staging Browser smoke on the sprint's deploy (7e04d3f5e) failed on journey 8 alone: it still opened the old Add evidence dialog and clicked "Add a link", which this sprint replaced with the Add evidence window. Journey 8 now adds the web address on the window's Add new evidence tab, gives it a title, an evidence type and a classification, and uploads it. It then checks, as before, that the piece starts Unchecked and that a person can set it to Compliant.

    Checked: the Browser smoke run from this branch against staging passed all 37 checks (run 44883191868).

    Separately, the PR's frontend tests needed three runs, failing twice on tests this change doesn't touch:
    - Run 1: every test passed, but a pop-up's closing animation finished after RequestsTab's tests had ended.
    - Run 2: CollectionCard's field list and the DDQ library list each failed once.
    - Run 3: green.
    These are timing flakes under load, not caused by this change.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found on the staging deploy of the Evidence Improvements sprint (7e04d3f5e, 2026-11-21). The Browser smoke's journey 8 ("a control's evidence shows its status, and a person sets it") still opens the old Add evidence dialog and clicks "Add a link". COM-2041 and COM-2043 replaced that dialog with the Add evidence window, so the journey times out. The other 36 checks passed. The product isn't broken; the test is out of date.

**Done when**
- Journey 8 adds its web address through the Add evidence window (Add new evidence ▸ Web address ▸ Add, then a title, evidence type and classification, then Upload 1). It still checks that the piece starts Unchecked and that a person can set it to Compliant.
- The Browser smoke is green on staging.

Independent: test only.