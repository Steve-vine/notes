---
id: 01M7WZJAXRFAW5P5AHWZ3FX6FV
created: 2026-11-20T17:20:18.872812Z
updated: 2026-11-20T17:57:33.346589Z
type: task
title: Moving between two published documents with different house styles that show the same standalone flowchart no longer sticks on loading
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2033
sprint: s6y6p7g
comments:
- id: 01M7X1PES9SX6E3ZEEAAJN5882
  author: Steve Vine
  at: 2026-11-20T17:57:31.049305Z
  text: |-
    Done — PR #2027, merged fde289e4.
    Moving between two published documents in different house styles that show the same standalone flowchart now opens each one straight away, in its own colours, both ways: by link, from the Content list, the Library or search, and with Back and Forward. Nothing needs a refresh.
    Cause: the flowchart picture inside a document asked for its own house style in a way that, when that style was already loaded for the page, made the browser wait for a copy that could never arrive. The page stayed on its loading placeholders, giving up only after a minute. The flowchart's house style is now simply added to the page. The document's own house style still waits until it has loaded, so a document never flashes in the wrong colours.
    Checked in a real browser against the pre-UAT documents (read only, through a local build): the minimal Procedure and Runbook with the standalone flowchart, 3 rounds each way plus Back and Forward, and the own-and-standalone pair, on the Read and Edit tabs. Every one opened in under 2 s in its own colours. Staging before this fix stays stuck on the same steps.
    A new Browser smoke test makes two published documents in two house styles that share one flowchart (made up in the browser, so nothing is created on staging) and moves between them through the Content list twice each way, then Back and Forward. It fails on the old code and passes now.
    To check on staging: Steve's original steps (Procedure with standalone, then Content, then Runbook with standalone, and back).
assignee: steve
label:
- bug
priority: urgent
task_status: review
---
Found in Claude's pre-UAT of COM-2023/COM-2024 (staging b65d7ed8, tester B). This is exactly Steve's setup.

**Steps**
1. As E2E Admin A, open "E2E pre-UAT COM-2023 minimal Procedure with standalone". It is published, uses house style A4-Policy-External, and shows the standalone flowchart "E2E pre-UAT COM-2024 standalone flowchart (Runbook type)".
2. Click Content in the top trail.
3. Open "E2E pre-UAT COM-2023 minimal Runbook with standalone". It is published, uses the Runbooks house style, and shows the same standalone flowchart.

**Expected:** the Runbook document opens in its red Runbooks colours.

**Seen:** grey loading placeholders that never go away (waited 60 s). There is no error, no outstanding request and nothing in the console. It happens in both directions, from the Library and from search too, and for another admin in a fresh browser. A refresh, or Back then Forward, clears it.

These open normally:
- the same pair while they are drafts;
- a pair where only one document shows the flowchart;
- two same-style documents sharing one flowchart;
- documents with no standalone flowchart.

Screenshots: ~/compass-uat/s6y6p7g/COM-2023/r4-D1-stuck-*.png

**Likely cause (not confirmed):** COM-2024 wraps a shown standalone flowchart in its own house stylesheet (`<HouseStyle typeId>` in FlowchartRefFigure). Together with COM-2023's per-document scoping, this may leave the page waiting on a stylesheet that is already loaded or being swapped. jsdom tests can't see it; reproduce in a real browser.

**Done when**
- The steps above open each document fully, in its own colours, every time, in both directions, by link, Library, search and Back/Forward.
- The other cases in COM-2023/COM-2024 still work.
- A browser test (headless Chromium or the Browser smoke) covers moving between two published documents with different house styles that share one standalone flowchart.