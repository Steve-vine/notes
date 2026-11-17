---
id: 01M7MJ5FCVP0YDWSZF7EWZM3CE
created: 2026-11-17T10:52:10.523238Z
updated: 2026-11-17T11:08:01.489406Z
type: task
title: Switching a built-in check off on the Built-in Checks tab always asks first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1893
sprint: s7nqsy0
comments:
- id: 01M7MK2F3EXRKW7RBPQ2VC49BC
  author: Steve Vine
  at: 2026-11-17T11:08:00.493786Z
  text: |-
    Done — PR #1887, merged 67f07af7.
    On Evidence Collection ▸ Built-in Checks, switching any check off now always asks first, not only when it has an open gap. Switching on still happens at once.
    The question reads the same everywhere a built-in check is switched off: the tab, its card on a control's Evidence tab, and its Edit on its own page. It says: "Switch CHB-5 off? Compass stops running it for this company until it's switched on again."
    When the check has an open gap it adds which one closes: "Its open gap GAP-139 will be closed." If it has two, it names both.
    Assumption: the card used to say "The gap it raised is closed." without naming the gap. It now names it too, so all three places read the same.
    To check on staging: switch CHB-5 off on the Built-in Checks tab and press Keep it on, so nothing changes. Then switch CHB-12 off and check the question names GAP-139, and again press Keep it on.
assignee: steve
priority: medium
task_status: review
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1885.

**The problem.** COM-1885 says switching a check off asks first. On Evidence Collection ▸ Built-in Checks it only asks when the check has an open gap (CHB-12 named GAP-139). Switching CHB-5 off, with no open gap, happened at once. The card's Switch off on a control's Evidence tab always asks.

Screenshot: ~/compass-uat/s7nqsy0/COM-1885/switch-off-no-open-gap-no-question.png

**Done when**
- Switching any built-in check off on the tab asks first, in the same words as the card. When the check has an open gap, the question also says which gap closes.
- Switching on doesn't ask.
- Tests cover both cases: with an open gap and without one.