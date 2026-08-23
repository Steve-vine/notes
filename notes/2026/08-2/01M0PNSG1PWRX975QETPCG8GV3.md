---
id: 01M0PNSG1PWRX975QETPCG8GV3
created: 2026-08-23T06:44:08.374634Z
updated: 2026-08-23T06:44:08.374634Z
type: task
title: The Portal tab shows the Register — its name is missing from the tab whitelist
assignee: steve
task_status: active
label: bug
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 371
---
Reported by Steve, 2026-08-23, smoke-testing COM-370. Clicking **Portal** on Vendor Management renders the **Register** tab.

`useTabParam` (COM-309) takes the list of tabs available to this reader and falls back to the first when the query string names one it does not recognise — deliberately, so a link to `?tab=approvals` opened by somebody without the permission lands somewhere sensible rather than on an empty page. COM-370 added the Portal tab and its panel but never added `'portal'` to that list, so clicking it sets `?tab=portal`, the hook rejects it as unknown, and the page renders the fallback.

- [ ] Add `'portal'` to the `canEdit` list in `VendorsPage.tsx`. It belongs only there — the tab is vendor-write gated, so a reader following a link to it should still fall back.
- [ ] Swept the other seven `useTabParam` callers: every one's list matches its rendered tabs. This is the only drift.
- [ ] Regression test on the shape of the bug rather than this one tab: click every tab Vendor Management renders and assert each shows its own panel. A test naming `portal` would pass the next time somebody adds a tab and forgets the list — this is the second half of a two-part change that has no compiler tying it together.
