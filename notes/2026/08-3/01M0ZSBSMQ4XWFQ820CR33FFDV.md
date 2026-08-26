---
id: 01M0ZSBSMQ4XWFQ820CR33FFDV
created: 2026-08-26T19:39:43.639875Z
updated: 2026-08-26T19:39:43.639875Z
type: task
title: Admin is dressed like every other screen — no box around the tabs
company: moneypenny
assignee: steve
label: improvement
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 439
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