---
id: 01M216QZ3VBPGHAEV6X0YJXDM0
created: 2026-09-08T19:08:30.203395Z
updated: 2026-09-08T19:09:10.798718Z
type: task
title: The assessment panel's boxes squash to fit the screen instead of scrolling
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 623
sprint: sa2t9sq
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found on the sprint 55 smoke test of COM-618. In the panel beside the Assessments queue, the assessment box, the frameworks card, the linked content and the decisions are all squashed so the panel fits the height of the screen, rather than each box taking the height its content needs with the panel scrolling.

Cause: COM-618 made the panel's scrolling body a Mantine `Stack` with `overflowY: auto`. A Stack is a flex column, so the boxes are flex items of the scrollport and shrink to share its height instead of overflowing it.

Fix: the scrollport is a plain `Box` (the way `ScreenFrame.Body` is) and the `Stack` sits inside it, so the boxes keep their natural height and the body scrolls. Test: the body is not itself a flex container and the boxes are laid out in a stack inside it.