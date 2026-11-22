---
id: 01M7Z515SXH8TH9AYGT15K1D6M
created: 2026-11-21T13:34:16.89371Z
updated: 2026-11-22T08:13:22.449229Z
type: task
title: 'Assessment screen: someone who can''t record assessments sees a read-only box, not an editable one that fails on Save'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2072
sprint: s9hexqn
comments:
- id: 01M7Z6HES9S4CD86M1RD8RZXPX
  author: Steve Vine
  at: 2026-11-21T14:00:38.953673Z
  text: |-
    Done. Merged to main as PR #2065; it isn't on staging yet and goes out with the next deploy.

    What changes for people
    - A Viewer, or anyone else who can't record assessments, now sees the assessment as text:
      - In scope or Out of scope, with the reason;
      - the status, in its colour;
      - the maturity level and its definition;
      - the owner;
      - the notes, or "None" when there are none.
    - They get no status or maturity buttons, no In scope switch, no Notes box, and no Save or Save & next. The footer still says "Saved · date" or "Not yet assessed".
    - Previous/Next and the arrow keys still step through the controls.
    - An initiative's Assess drawer uses the same box, so it reads the same way.
    - Admins and Assessors see the box exactly as before.

    Calls Steve might overturn: the owner shows as text, not the greyed-out picker Viewers used to see. The drawer change is only a safeguard, because an initiative doesn't offer a Viewer Assess anyway.
    Checked:
    - Headless Chromium at 1440 and 390: as a Viewer the box has no buttons and no fields, and the Down arrow still moves to the next control. As an Admin it is unchanged.
    - Vitest cases for a Viewer (in scope, out of scope, never assessed) and for an Assessor.
- id: 01M7Z8TWTYHXKAK2XHQKFJBANT
  author: Steve Vine
  at: 2026-11-21T14:40:45.405875Z
  text: |-
    Pre-UAT recheck (staging 095141ab4, E2E Test Company): Passed.
    Steps: As E2E Viewer, opened the Assessment screen ▸ RIM.9 at 1440 and listed every button and field in the box. Used Next / Previous and the Down / Up arrows. Repeated as E2E Assessor and Admin A.
    Seen:
    - Viewer: the box is plain text, with no buttons and no fields. It shows In scope, Status (Implemented, green dot), Maturity "Not set", Owner "Unassigned", the notes, Last reviewed / Next review and "Saved · 21 Nov 2026".
    - Next/Previous and the arrows moved RIM.9 → INA.1 → RIM.9.
    - Assessor and Admin A: editable as before, with Save and Save & next.
    Screenshots: ~/compass-uat/s9hexqn/COM-2072/r6-*.png
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found in Claude's pre-UAT pass (staging 12bd442a5, 2026-11-21). It probably predates this sprint, but it sits on the screen this sprint reworked.

**Steps:** Sign in as E2E Viewer ▸ Assessment screen ▸ RIM.9.
**Expected:** Someone who can't record assessments sees the assessment read-only: its status, maturity and notes as text, with no Save. That matches the rest of the screen, where a Viewer gets no buttons.
**Seen:** The Viewer gets clickable status and maturity buttons, an editable Notes box, and enabled Save / Save & next. Pressing Save is refused with "You don't have permission to do that." Nothing is saved.
**Screenshot:** ~/compass-uat/s9hexqn/other/viewer-save-on-box.png

**Done when**
- As E2E Viewer, the Assessment screen box shows the current status, maturity and notes, and none of them can be changed. There is no Save or Save & next, and nothing invites an edit.
- Previous/Next and the keyboard still step through the controls.
- An Admin and an Assessor see the box as now.
- The initiative's Assess drawer behaves the same way for a Viewer.
- A test covers a Viewer.

Frontend only, most likely: the box already knows whether the person can record assessments. Independent.