---
id: 01M0ZSBSMQ4XWFQ820CR33FFDV
created: 2026-08-26T19:39:43.639875Z
updated: 2026-08-27T21:46:48.958071Z
type: task
title: Admin is dressed like every other screen — no box around the tabs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 439
sprint: smnkt3k
comments:
- id: 01M12FZCAGTC9PBV217AGF031W
  author: Steve Vine
  at: 2026-08-27T20:53:22.896503Z
  text: |-
    Done — PR #458.

    The outer card is gone and the tab bar runs on the page, with the same panel spacing Vendors uses. Admin was the only screen in the app wearing a frame.

    Removing a frame is only half of it: what was inside it was drawn assuming it. Every section was checked without it, and they split cleanly two ways.

    Sections that are one table and its action — Users, Companies, API tokens — sit bare on the page, exactly as the Vendors register does. They need no border and never did.

    Sections that stack several titled blocks were leaning on the outer card to hold them together and float without it, so each block gets its own card: the risk rubric's three (scales, severity bands, appetite), the data rubric's three (sensitivity, data types, data entities), and one each for the maturity rubric, business criticality and review cadence. Integrations was three unrelated setups separated by horizontal rules — now three cards, and the rules are noise once each has an edge of its own.

    Email keeps no outer card. It already draws one per transport, and wrapping those in another nests cards two deep for no gain; the Vendors portal tab is the same shape.

    This also sets COM-440 up: the four rubrics arrive already carded and headed, so stacking them into one tab is about the tab list rather than the boxes.

    Tabs, their order and the ?tab= URLs are untouched — appearance only.

    Tests: the layout assertions the task expected to move did not exist, so two were added, both written to fail before the change rather than merely pass after it. One asserts the tab list has no card ancestor. The other asserts the Review cadence heading's nearest card does not contain the tab list — so it is the section's own card, not the page frame under a new name. A test that only asked "is it in a card" would have passed before the change too, which is why it asks this instead. 754 tests pass.

    Worth your eye on the visual: Admin next to Vendors, in both themes.
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: done
---
Admin puts its whole tab bar and every tab's content inside one bordered card, so the screen sits in a frame nothing else in the app has. Vendors and Access Control run their tabs on the page itself and let each section bring its own card. Admin looks like a different product.

## What changes for the reader

**Admin looks like Vendors.** Title, then a tab bar on the page, then the tab's content — with cards around the things that deserve a card, not around the whole screen.

## Scope

Drop the outer frame on `pages/AdminPage.tsx` and adopt the pattern the other tabbed screens use: heading at the top, tab bar under it, panel content below, matching spacing and tab styling.

Then check each admin section renders sensibly without the frame it was drawn inside — Users, Companies, API tokens, the four rubrics, Content reviews, Integrations and Email. A section that was leaning on the outer card for its border or padding needs its own.

The tabs, their order and the `?tab=` URLs stay exactly as they are — this is appearance only.

COM-440 rebuilds the rubric tabs on this same screen, and COM-436 removes the Admin subtitle. Sequence them rather than running them in parallel.

## Tests

`AdminPage.test.tsx` plus the per-section tests — expect layout assertions to move, not disappear. The real check is visual: Admin next to Vendors, in both themes.