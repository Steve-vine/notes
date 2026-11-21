---
id: 01M7YQ7FGYM32CNS6DC7HVN6PM
created: 2026-11-21T09:33:03.39069Z
updated: 2026-11-21T13:33:32.085287Z
type: task
title: 'Assessment screen: the History tab''s count leaves out evidence, exception and check entries, so it says 10 where the list (and the Control screen) has 12'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2058
sprint: s9hexqn
comments:
- id: 01M7YYWNXM949QJ22WMPRC657R
  author: Steve Vine
  at: 2026-11-21T11:46:58.100749Z
  text: |-
    Done and merged to main (PR #2051). This changes the screen only.

    What changes:
    - The Assessment screen's History count now counts every entry in the list: saves, evidence added or taken off, exception events and Compass check events. Before, it counted only saves (INS.1 said 10 where the list had 12).
    - The Control screen and the Assessment screen now always show the same number, matching what the tab lists. Both take the count from one place, worked out from the list itself, so a new kind of entry can't make them disagree again.

    Checked: a new test with all four kinds of entry (shows 5, lists 5), and the existing saves-only case.
- id: 01M7Z4ZT1NA6WCR5ZD2J11W92Y
  author: Steve Vine
  at: 2026-11-21T13:33:32.085097Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: Compared the History count with the entries listed on the Assessment screen and the Control screen. INS.1 is "Not assessed yet" in E2E Test Company, so I used RIM.9, INS.10 and INS.6.
    Seen:
    - Assessment screen count, Control screen count and entries listed all agree: RIM.9 24/24/24 (saves plus evidence added, linked, taken off, archived and replaced), INS.10 144/144/144, INS.6 2/2/2.
    Screenshots: ~/compass-uat/s9hexqn/COM-2058/
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Raised by Steve while testing sprint 120 (2026-11-21).

**What Steve saw.** INS.1's History tab says **12** on the Control screen and **10** on the Assessment screen. Both lists actually show 12 entries.

**Why** (checked in the code). Both screens show the same history list, made from four kinds of entry:
- changes to the assessment;
- evidence added or taken off;
- exception events;
- Compass check events.

The Control screen's tab counts all four. The Assessment screen's tab counts only the first, the assessment's own changes. So its number falls short whenever a control has evidence, exception or check entries. For INS.1 that's two entries.

**What people see after this**
- The History tab's number is the same on both screens, and it is exactly the number of entries the list shows (IA brief: *a count equals what choosing it shows*).

**Implementation notes**
- Assessment screen: `pages/AssessmentsQueuePage.tsx`, the tab's `count: revisions.length`. The data is already fetched beside it (`evidenceChanges`, `exceptionEvents`, `checkEvents`).
- Control screen: `pages/ControlDetailPage.tsx`, `historyCount` (the sum of all four).
- Don't fix it by copying the sum. Put the count in one place next to `AssessmentHistory` (for example an exported `historyCount(...)`) and use it on both screens. That way the next kind of history entry can't make them disagree again. If `AssessmentHistory` ever merges or hides entries, the count should follow what it renders.
- Add a test that the Assessment screen's History count equals the number of entries listed when all four kinds are present.
- Frontend only. Independent: no migration or API change.

**Done when**
- INS.1 shows the same History count on the Control screen and the Assessment screen, and that count matches the entries listed on each.
- A control with only assessment changes, and one with evidence, exception and check entries too, both count correctly on the Assessment screen.