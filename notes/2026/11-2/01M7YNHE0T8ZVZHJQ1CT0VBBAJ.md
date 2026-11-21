---
id: 01M7YNHE0T8ZVZHJQ1CT0VBBAJ
created: 2026-11-21T09:03:32.378317Z
updated: 2026-11-21T10:56:43.856827Z
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
- id: 01M7YW0PAG0S21E2F3HX74B91G
  author: Steve Vine
  at: 2026-11-21T10:56:43.856636Z
  text: |-
    Failed (pre-UAT recheck, staging d4a5f0b5a, 21 Nov, E2E Test Company, as E2E Admin A). The four fixes work; one related defect on the assessment panel.

    What passed:
    1. INC-125: the timeline entry "E2E 20261121 timeline entry with files" lists "EVD-60 … access review (Word).docx 956 B" and "EVD-75 … timeline PDF.pdf 593 B"; the law-enforcement notification's copy shows "EVD-76 … notification copy.txt 565 B".
    2. INS.6 (fresh, never assessed): Assessment screen ▸ Add evidence ▸ uploaded a .txt with a very long name (became EVD-80). The panel said "Not assessed yet: evidence added now supports INS.6, and is listed here once the assessment is saved." Set Partial and Save: EVD-80 appeared on the panel straight away, and is still there after a reload, with Edit and Take off.
    3. Long names wrap without running under the size or icons: EVD-80's name wraps over five lines beside "69 B" and the icons, and none of RIM.9's seven rows overlap (checked by position on screen). Desktop only, see the note below.
    4. Link existing tab, Controls cell: "NES.1, NES.2, NES.3 +29 more", with the full list (NES.1–NES.32) on hover.

    Defect: a piece linked through Link existing gets New version and Archive on the panel, not Take off
    - Steps: RIM.9 ▸ Assessment screen ▸ Add evidence ▸ Link existing evidence ▸ tick EVD-66 "E2E 20261121 register Word file.docx" (it was added in Audit ▸ Evidence and is also on RIM.8 and the finished SAP-87) ▸ Link 1. Look at its row on the assessment panel, then reload.
    - Expected: like the other pieces that live elsewhere (EVD-60, EVD-62, EVD-63…), Edit and Take off. It shouldn't be replaced or archived from this panel, because it supports other records.
    - Seen: Edit, "Upload a new version" and "Archive", and no Take off, even after a reload. Archive's window even says "This is the finished entry's last file. The entry keeps your reason instead", meaning archiving from RIM.9 would reach SAP-87. The only way to take it off RIM.9 is from the piece's own page (Used in ▸ Take off), which worked. I cancelled the archive and took EVD-66 off again that way.
    - Cause (technical, from reading the code): the panel offers Take off only when the server marks a file "held in the register for its control" (by_hand). A piece linked onto the assessment itself through the window counts as "used here", so it gets the actions meant for files uploaded on the panel. EVD-67 "damaged Word file" shows the same.
    - Screenshots: rim9-linked-piece-archive-not-takeoff.png, rim9-linked-piece-archive-dialog.png

    Note on 375px: couldn't check the panel at phone width. On the Assessments screen at 375px the control list keeps the whole width, and the control and its assessment panel are pushed off the right-hand edge, so a row is only ~16px wide (ins6-panel-375.png). The page that lays this out hasn't changed this sprint, so this looks older than COM-2055. There is no other phone view of the panel to check.

    Screenshots: ~/compass-uat/s9hexqn/COM-2055/
assignee: steve
label:
- bug
priority: medium
task_status: review
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