---
id: 01M7MJ5FCVP0YDWSZF7EWZM3CE
created: 2026-11-17T10:52:10.523238Z
updated: 2026-11-17T19:50:15.481657Z
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
- id: 01M7MPYJBZX1JWASAA8TNJ7FQA
  author: Steve Vine
  at: 2026-11-17T12:15:47.071315Z
  text: |-
    Pre-UAT on staging 00a2eb16 — Passed
    - Switching off asks first, in the card's words: as E2E Admin A in E2E Test Company, Evidence Collection ▸ Built-in Checks. Switching CHB-5 off (no open gap) opened "Switch CHB-5 off? Compass stops running it for this company until it's switched on again." with Keep it on / Switch off. I pressed Keep it on and it stayed on. CHB-12 (no open gap at the time) asked the same way. Passed.
    - With an open gap, it names the gap: CHB-6 has GAP-147 open on ACC.3. Switching it off asked "…until it's switched on again. Its open gap GAP-147 will be closed." I pressed Keep it on. The card's Switch off on ACC.3 ▸ Evidence asked in exactly the same words, and I cancelled. CHB-5's Edit on its own page asked in the same words too, and I cancelled. Passed.
    - Switching on doesn't ask: I switched CHB-5 off (confirmed), then on again. It came back on at once, with no question. Passed. All 12 built-in checks are on, as they were.
    - Phone width (390px): switching CHB-5 off asks in the same dialog. Passed.
    - Tests: the PR adds tests for no open gap, with an open gap, the same words as the card, and switching back on without asking. The staging deploy run is green.
    Observation: the tab asks in Compass's own dialog. The card on a control's Evidence tab and Edit on the check's page ask in the browser's plain confirm box. The words are the same in all three.
    Screenshots: ~/compass-uat/s7nqsy0/COM-1893/
assignee: steve
priority: medium
task_status: done
---
From the pre-UAT pass of round 3 (staging 44d15b9a), COM-1885.

**The problem.** COM-1885 says switching a check off asks first. On Evidence Collection ▸ Built-in Checks it only asks when the check has an open gap (CHB-12 named GAP-139). Switching CHB-5 off, with no open gap, happened at once. The card's Switch off on a control's Evidence tab always asks.

Screenshot: ~/compass-uat/s7nqsy0/COM-1885/switch-off-no-open-gap-no-question.png

**Done when**
- Switching any built-in check off on the tab asks first, in the same words as the card. When the check has an open gap, the question also says which gap closes.
- Switching on doesn't ask.
- Tests cover both cases: with an open gap and without one.