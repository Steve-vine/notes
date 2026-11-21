---
id: 01M7YW4YNNJQSF34NE0MJ3TY6X
created: 2026-11-21T10:59:03.477805Z
updated: 2026-11-21T11:47:16.643093Z
type: task
title: 'The Assessment screen works at phone width: the list, then the control and its assessment box, one at a time'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2070
sprint: s9hexqn
comments:
- id: 01M7YYX047X69C9FZ09A6SJ9ZX
  author: Steve Vine
  at: 2026-11-21T11:47:08.551537Z
  text: |-
    Done and merged to main (PR #2060). This changes the screen only.

    What changes:
    - On a phone (768px wide or less), choosing a control shows it on its own, with its box at full width. The list no longer sits beside it and pushes it off the screen.
    - The control's bar starts with "Back to the list", which returns to the list with its filters kept. On a phone the Playbook link is just its icon, so the bar fits on one line. The arrows and the Up and Down keys step through the controls as before.
    - The list drops its Maturity column on a phone, so nothing scrolls sideways at 375px. The box still shows the maturity.
    - Wide screens are unchanged, including COM-2063's fixed box.

    Checked in headless Chromium at 375×812: the list fits; picking a control opens it alone; Save can be reached after choosing a status; Add evidence opens full width; stepping and Back work; and nothing scrolls sideways at any step. Wide layouts are unchanged.

    Calls for you to overturn:
    - On a phone the box sits above the guidance, not underneath as the task said. The screen already puts the box first when it gets narrow, because the guidance and evidence can be very long. Swapping them is a one-line change.
    - The phone layout starts at 768px, the same point as the Add evidence window and the flowchart editor.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Claude's pre-UAT recheck (staging d4a5f0b5a, 2026-11-21). Not caused by this sprint (the page's layout predates it), but the sprint moves more work onto this screen (COM-2056/2057/2060/2061), so it matters more now.

**Seen:** at 375px wide, the Assessment screen's list of controls keeps its full width, and the chosen control and its assessment box are pushed off the screen. There's no way to assess a control on a phone.
**Screenshot:** ~/compass-uat/s9hexqn/COM-2055/ins6-panel-375.png

**What people see after this**
- On a phone, the list of controls fills the screen. Choosing a control shows the control (Overview, History) with its assessment box stacked underneath, full width, and a clear way back to the list.
- Arrow-key stepping and the run through the queue behave as now on a wide screen.
- Nothing scrolls sideways at 375px.
- The wide layout is unchanged (including COM-2063's fixed box).

**Done when**
- At 375px, someone can pick a control, record its assessment, add evidence and go back to the list, without sideways scrolling.
- The wide layout behaves as before.
- Checked in headless Chromium at 375px and at desktop width.

Frontend only. Independent. Build after COM-2063, which changes the same layout.