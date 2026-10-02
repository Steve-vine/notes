---
id: 01M3WEZ65B3GTCJ5311JJ52QXW
created: 2026-10-01T19:27:26.891241Z
updated: 2026-10-02T08:49:43.323525Z
type: task
title: Remove the up and down buttons
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 828
sprint: s0zzctz
comments:
- id: 01M3WN67DEAHQD9Q471XJBZK4B
  author: Steve Vine
  at: 2026-10-01T21:16:09.004594Z
  text: |-
    Merged: PR #837 (bedd207).

    With a control open on Assessments, pressing J or K no longer moves down or up the queue, and the "J K to move" hint is gone from the control's bar.

    What I left in place — say if you meant these to go too: the up and down arrow buttons beside the "1 / 2" position still step through the run (their tooltips no longer mention a key). Esc still closes the control, and Save & next still saves and moves on.

    I read the task as the J and K keys specifically, since that is what the description names. If "the up and down buttons" in the title meant the two arrow buttons as well, that is a small follow-up.

    To check on staging: Posture ▸ Assessments, open a control, press J and K — nothing should move; the arrows should.
assignee: steve
label: null
priority: medium
task_status: done
---
Remove the J K button functionality to move up and down through the assessment controls.