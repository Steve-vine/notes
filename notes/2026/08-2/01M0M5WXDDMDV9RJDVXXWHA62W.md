---
id: 01M0M5WXDDMDV9RJDVXXWHA62W
created: 2026-08-22T07:27:54.285216Z
updated: 2026-08-22T08:12:05.119277Z
type: task
title: Move Decisions to the bottom of the Company section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 339
sprint: s7jknet
comments:
- id: 01M0M8DEARNS81GYVM6QMKVR1X
  author: Steve Vine
  at: 2026-08-22T08:11:53.048618Z
  text: |-
    Done — PR #341, merged to main as 7b21718.

    Decisions moves out of Library and to the bottom of Company: Assessments · Gaps · Actions · Risks · Decisions.

    One thing worth your eye: the item keeps `gate: 'Library'`, because that is what the API enforces on /decisions and what RequireSection gates the route on — filing something somewhere new must not quietly widen or narrow who can read it. The visible consequence is that an analyst-only account now sees a Company header holding Decisions and nothing else. If you'd rather Decisions became Company-gated end to end, that's a permission change on both sides of the API and wants its own task.

    Tests: Decisions is last in Company for an admin; an analyst-only account sees Company holding exactly Decisions.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Reorder the **Company** section of the navigation menu so that **Decisions** is the last item.