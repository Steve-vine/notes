---
id: 01M7YNHE0T8ZVZHJQ1CT0VBBAJ
created: 2026-11-21T09:03:32.378317Z
updated: 2026-11-21T10:11:22.491267Z
type: task
title: 'Evidence rows tidy-up: EVD IDs on timeline and notification files, evidence added before a first assessment shows on the panel, and rows that don''t overlap'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2055
sprint: s9hexqn
comments:
- id: 01M7YSDMQV2AV3Q2H48R3Y2PZE
  author: Steve Vine
  at: 2026-11-21T10:11:22.49114Z
  text: |-
    Done and merged to main (PR #2049). No migration.

    What changes:
    - Each file on an incident timeline entry, and each notification's copy, shows its EVD ID before its name, as the incident's Evidence card does.
    - Evidence added on a control's panel before its first assessment now appears on the assessment panel once the assessment is saved, in the existing order. That includes the Assessments screen, which used to say "No files attached". Nothing is moved: the panel reads it from the register.
    - On the panel, such a piece can be described or taken off this control. It isn't replaced or archived from there, because it may support other controls; its own page does those.
    - Long names on the panel's evidence rows wrap without running under the size or the icons. The same applies to "Linked from elsewhere" rows. Checked at the panel's 360px width and at 375px phone width. An untitled web address stays on one line, with the full address on hover.
    - In the Add evidence window's Link existing tab, the Controls cell shows the first three controls and "+N more", with the full list on hover.

    Calls for you to overturn:
    1. The panel's own list now includes everything in the register that's linked by hand to the control, not only what was added before the first assessment; Compass can't tell the two apart. So evidence added in Audit ▸ Evidence for this control moves from "Linked from elsewhere" to the panel's main list. "Linked from elsewhere" now means evidence sitting on another record, such as a plan activity or a certificate. Collected captures stay where they were.
    2. Long names wrap rather than being cut short.

    Note: two date-and-time-sensitive data subject request tests failed once each in CI, unrelated to this change. Logged separately.
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass of the Evidence Improvements sprint (staging 7e04d3f5e, 2026-11-21), on COM-2045 and COM-2043.

**1. No EVD IDs on a timeline entry's files or a notification's copy (COM-2045)**
- **Steps:** on INC-125, add a timeline entry with files, and record a notification as sent with a copy.
- **Expected:** each file shows its EVD ID, as on the incident's Evidence card.
- **Seen:** only the name and size, though the pieces have IDs in the register (EVD-75, EVD-76).
- **Screenshots:** ~/compass-uat/s9hexqn/COM-2045/timeline-entry-files-no-evd.png and notification-recorded.png

**2. Evidence added before a control's first assessment never appears on the assessment panel (COM-2043)**
- **Steps:** add evidence on an unassessed control's panel, then save the assessment and reload.
- **Expected:** it's listed on the panel once the assessment is saved, as COM-2043 said.
- **Seen:** the panel still says "No files attached." (EVD-68). It does show on the control's Evidence tab.
- **Screenshot:** ~/compass-uat/s9hexqn/COM-2043/rim9-assessed-after-reload.png

**3. Overlapping text on the assessment panel's evidence rows (COM-2043)**
- A long name runs under the size ("470 B") and the action icons.
- **Screenshot:** ~/compass-uat/s9hexqn/COM-2043/assessment-panel-evidence-rows.png

**4. One policy row fills the Link existing tab (COM-2042)**
- A policy's Controls cell lists END.1 to END.23 one per line, so a single row fills the window. Show the first few and "+N more".

**Done when**
- Timeline-entry files and notification copies show their EVD IDs.
- Evidence added on an unassessed control's panel is listed on the panel once the assessment exists.
- Assessment panel rows truncate or wrap long names without overlapping the size or icons, at desktop and phone width.
- A long controls list in the Link tab collapses to a few plus "+N more".
- Tests cover 1, 2 and 4.

On the chain: frontend (and the assessment panel's read if that's where it's missing).