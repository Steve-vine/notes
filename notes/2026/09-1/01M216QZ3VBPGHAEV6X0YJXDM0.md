---
id: 01M216QZ3VBPGHAEV6X0YJXDM0
created: 2026-09-08T19:08:30.203395Z
updated: 2026-09-08T19:19:27.008317Z
type: task
title: The assessment panel's boxes squash to fit the screen instead of scrolling
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 623
sprint: sa2t9sq
comments:
- id: 01M217C0ET4KEWHHPFJE6XF70Z
  author: Steve Vine
  at: 2026-09-08T19:19:26.938721Z
  text: |-
    Done — PR #630 merged to main.

    The panel's scrolling body was a Mantine Stack (a flex column), so the assessment box and the three context cards were flex items of the scrollport and shrank to share the screen's height. The scrollport is now a plain Box, the way ScreenFrame.Body wraps its rows, with the Stack inside it; the boxes take the height their content needs and the body scrolls. Head, padding and everything else from COM-618 unchanged.

    Test: AssessmentsQueuePage.test.tsx pins the body as the scrollport, not itself a Stack or flex container, with the boxes in a Stack inside it. The COM-618 assertions still pass.

    Staging deploy follows once main's build is green.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found on the sprint 55 smoke test of COM-618. In the panel beside the Assessments queue, the assessment box, the frameworks card, the linked content and the decisions are all squashed so the panel fits the height of the screen, rather than each box taking the height its content needs with the panel scrolling.

Cause: COM-618 made the panel's scrolling body a Mantine `Stack` with `overflowY: auto`. A Stack is a flex column, so the boxes are flex items of the scrollport and shrink to share its height instead of overflowing it.

Fix: the scrollport is a plain `Box` (the way `ScreenFrame.Body` is) and the `Stack` sits inside it, so the boxes keep their natural height and the body scrolls. Test: the body is not itself a flex container and the boxes are laid out in a stack inside it.