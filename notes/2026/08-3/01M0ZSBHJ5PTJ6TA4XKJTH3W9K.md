---
id: 01M0ZSBHJ5PTJ6TA4XKJTH3W9K
created: 2026-08-26T19:39:35.365088Z
updated: 2026-08-27T20:39:01.75594Z
type: task
title: Tabs lose their subtitles too — the tab label is the explanation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 438
sprint: smnkt3k
comments:
- id: 01M12F53BVM8WZ9BTP1X2QMNYR
  author: Steve Vine
  at: 2026-08-27T20:39:01.755804Z
  text: |-
    Done — PR #457.

    Eleven tab-top paragraphs gone: Vendors' Requests, Assessments, Assessment Rules, Compliance Rules, Approval Rules and Portal tabs, and Admin's Users, Companies, API tokens, Content reviews and Email. Click the tab and the table or form is right there.

    Access Control's were already done — those lines were page-level and went with COM-436 and COM-437. The portals carry none: their tab shells render a tab bar and an outlet, nothing else. Content and the framework detail screen are outside the scope the task named and were left alone. The four rubric sections are left to COM-440, which restructures that same markup into one Rubrics tab with a card and heading each — trimming them now and rebuilding them next would be two passes over the same lines.

    On spacing: ten of the eleven sat opposite the tab's action control — Create user, Add assessment, the request filters — in a space-between row. Removing the paragraph parks that control on the left, so each row is justified right instead, the same fix the role matrix needed in COM-437. Requests had its filters in a nested group that existed only to sit opposite the paragraph, so that collapsed into one row. Email keeps its space-between because its heading and button are still two children.

    One thing worth your call. Five of the removed lines carried an operating rule rather than a restatement, and those rules now appear nowhere in the UI:

    - Submitting a request registers the vendor as "New" pending sign-off
    - A vendor is asked for every assessment named by a rule set it matches
    - Compliance is still earned by recording a review — the rules only inform a reviewer
    - Entra-provisioned accounts derive their roles from the group mappings below
    - Exactly one transport is the active sender; every notice goes through it

    Plus two "leave blank to…" hints on the portal settings and the content review cadence, which would sit naturally as helper text on the field they govern.

    The task names the Requests line explicitly as one to remove, so the sprint's rule is that a paragraph at the top of a tab goes whether or not it teaches something — and applying it selectively would leave exactly the inconsistency the sprint exists to remove. So they all went. But if any of those rules is load-bearing, restating it where it applies is a small follow-up; say the word and I will raise it.

    Tests: nothing broke. Every affected section already has its own test file proving the tab renders by asserting on its content rather than its description, which is the shape the task wanted anyway. 752 tests pass.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: active
---
The same grey explanatory line COM-436 removes from page headers also appears one level down, under a tab's heading — Vendors ▸ Requests says *"Submitting a request registers the vendor as “New” pending sign-off."*, and Access Control's tabs each carry one.

## What changes for the reader

**A tab shows its content, not a paragraph about itself.** You click the tab and the table or form is right there.

## Scope

Remove the dimmed line under the heading inside every tab panel, across the tabbed screens: Vendors, Access Control, Admin, and the portals.

Same exception as COM-436 — a line that is the whole of an empty state ("Select a company to see its requests.") stays, because there is nothing behind it. Only the line shown alongside real content goes.

Where the removal leaves an odd gap between the tab bar and the content, tighten the spacing to match a tab that never had one.

Depends on COM-436 and COM-437 — all three touch the headers on the tabbed screens. Land them in that order.

## Tests

Expect the same kind of breakage: tab tests that assert on the sentence. Where that assertion was the only proof the tab rendered, replace it with something on the content.