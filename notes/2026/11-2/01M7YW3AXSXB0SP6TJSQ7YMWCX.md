---
id: 01M7YW3AXSXB0SP6TJSQ7YMWCX
created: 2026-11-21T10:58:10.489352Z
updated: 2026-11-21T12:43:11.844415Z
type: task
title: A piece linked onto a control from elsewhere offers Take off, not New version and Archive
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2066
sprint: s9hexqn
comments:
- id: 01M7Z23JESVZY66TQN8DNMSRNV
  author: Steve Vine
  at: 2026-11-21T12:43:09.657147Z
  text: |-
    Done — merged to main as PR #2058 (not yet on staging; goes out with the round-5 deploy).

    What changes for people
    - A file linked onto a control from elsewhere (picked with Link existing, or first added on another control or a plan entry) now offers Edit details and Take off this control. It no longer offers New version or Archive, which would have reached every other record using it.
    - A file first added on this control's assessment keeps New version and Archive.
    - The same applies wherever the evidence actions show: the Assessment screen's Evidence section and an initiative's Assess drawer.

    Note: a small API change (each file on an assessment now says whether it was added there), so it went on the chain; no migration.
    Could be tightened later: the replace and archive actions still accept a linked file if called directly through the API — the screen no longer offers them.
    Checked: a backend test (a file linked through the window vs one added on the assessment) and a Vitest case (each gets the right buttons; Take off targets this assessment). Backend lint, types, the unit suite (2900 passed) and the attachments integration tests pass.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Claude's pre-UAT recheck (staging d4a5f0b5a, 2026-11-21), on COM-2055.

**Steps:** RIM.9 ▸ Assessment screen ▸ Add evidence ▸ Link existing ▸ tick EVD-66 ▸ Link 1. EVD-66 was added in Audit ▸ Evidence, and is also on RIM.8 and the finished SAP-87.
**Expected:** Edit details and Take off this control, like the other pieces that live elsewhere (EVD-60, EVD-62, EVD-63).
**Seen:** Edit, "Upload a new version" and "Archive", still so after a reload. Archive's window says "This is the finished entry's last file…", so archiving from RIM.9 would reach SAP-87. Taking it off works only from the piece's own page. EVD-67 shows the same.
**Cause (technical):** the panel offers Take off only to files held in the register for the control. A file linked onto the assessment through the window counts as "used here", so it gets the actions meant for files first added on the panel.
**Screenshots:** ~/compass-uat/s9hexqn/COM-2055/rim9-linked-piece-archive-not-takeoff.png, rim9-linked-piece-archive-dialog.png

**Done when**
- A piece whose first place is somewhere other than this control's assessment offers Edit details and Take off this control, wherever the control's evidence actions are shown (after COM-2056, that's the Assessment screen's Evidence section). It doesn't offer New version or Archive there; those stay on the piece's own page.
- A piece first added on this control's assessment keeps New version and Archive.
- A test covers a piece linked from the register and one added on the panel.

Frontend (and the panel's read, if the "first place" isn't sent). Build with or straight after COM-2056, which moves these actions.