---
id: 01M7YNH1KWBFACRKREDH27SQ53
created: 2026-11-21T09:03:19.676202Z
updated: 2026-11-21T09:03:24.23947Z
type: task
title: Evidence that can't be deleted for good says why, and a control's History shows evidence taken off it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2054
sprint: s9hexqn
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT pass of the Evidence Improvements sprint (staging 7e04d3f5e, 2026-11-21), on COM-2040.

**1. Delete-for-good refusal isn't shown**
- **Steps:** archive EVD-70, which is on the finished schedule entry SAP-85, then open its page.
- **Expected:** a message saying it can't be deleted for good while a finished record relies on it, naming SAP-85.
- **Seen:** the "Delete permanently…" button is simply missing, with no reason. The server's refusal text reaches the page but isn't shown.
- **Screenshot:** ~/compass-uat/s9hexqn/COM-2040/evd-70-after-archive.png

**2. A control's History doesn't show a take-off**
- **Steps:** on EVD-66, use Used in ▸ Take off on RIM.9.
- **Expected:** the confirmation says RIM.9's history records it, so RIM.9 ▸ History shows who took EVD-66 off and when.
- **Seen:** RIM.9 ▸ History has no line for it, and the earlier "linked" line for EVD-66 has gone too. The activity log does record it, and an incident's History does show its take-offs.
- **Screenshot:** ~/compass-uat/s9hexqn/COM-2040/rim9-history.png

**Done when**
- An archived piece that a finished record relies on shows why it can't be deleted for good, naming the records (with links), where the Delete button would be.
- A control's History shows evidence linked to it and taken off it, with who and when, and the linked line stays after a take-off. The same holds for the other records that have a History.
- Tests cover both.

On the chain: frontend, plus the History feed if that's where it's dropped.