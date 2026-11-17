---
id: 01M7MJ5FCVP0YDWSZF7EWZM3CE
created: 2026-11-17T10:52:10.523238Z
updated: 2026-11-17T10:52:18.785512Z
type: task
title: Switching a built-in check off on the Built-in Checks tab always asks first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1893
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: active
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1885.

**The problem.** COM-1885 says switching a check off asks first. On Evidence Collection ▸ Built-in Checks it only asks when the check has an open gap (CHB-12 named GAP-139). Switching CHB-5 off, with no open gap, happened at once. The card's Switch off on a control's Evidence tab always asks.

Screenshot: ~/compass-uat/s7nqsy0/COM-1885/switch-off-no-open-gap-no-question.png

**Done when**
- Switching any built-in check off on the tab asks first, in the same words as the card. When the check has an open gap, the question also says which gap closes.
- Switching on doesn't ask.
- Tests cover both cases: with an open gap and without one.