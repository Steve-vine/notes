---
id: 01M7YNHE0T8ZVZHJQ1CT0VBBAJ
created: 2026-11-21T09:03:32.378317Z
updated: 2026-11-21T09:03:35.383547Z
type: task
title: 'Evidence rows tidy-up: EVD IDs on timeline and notification files, evidence added before a first assessment shows on the panel, and rows that don''t overlap'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2055
sprint: s9hexqn
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