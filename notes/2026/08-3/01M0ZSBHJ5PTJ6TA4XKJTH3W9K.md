---
id: 01M0ZSBHJ5PTJ6TA4XKJTH3W9K
created: 2026-08-26T19:39:35.365088Z
updated: 2026-08-27T20:27:24.690285Z
type: task
title: Tabs lose their subtitles too — the tab label is the explanation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 438
sprint: smnkt3k
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