---
id: 01M0PNSG1PWRX975QETPCG8GV3
created: 2026-08-23T06:44:08.374634Z
updated: 2026-09-01T13:55:50.259211Z
type: task
title: The Portal tab shows the Register — its name is missing from the tab whitelist
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 371
sprint: sbph5q5
comments:
- id: 01M0PP85WGW74VE6R3E6EGPMXP
  author: Steve Vine
  at: 2026-08-23T06:52:09.488555Z
  text: |-
    Done — PR #373, merged to main.

    - `'portal'` added to the `canEdit` list in `VendorsPage.tsx`. Only there: the tab is vendor-write gated, so a reader following a link to it should still fall back.
    - Swept the other seven `useTabParam` callers (Admin, Content, Content detail, Risks, Framework detail, Vendor detail, Portal requests) — every list matches its rendered tabs, so this was the only drift.
    - The test walks whatever tabs the page renders and asserts each one selects, rather than naming `portal`: the tab list and the whitelist are two halves of a change with no compiler tying them together, so a test naming the tab would pass the next time somebody adds one and forgets.
    - **Verified it actually catches the bug** — reverted the one-line fix and watched the test fail (`expected … ariaSelected 'true'`), then restored it. A regression test that has only ever passed proves nothing.

    Also left a note on the whitelist itself saying every rendered tab must appear there, since that is the thing the next person will miss.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Reported by Steve, 2026-08-23, smoke-testing COM-370. Clicking **Portal** on Vendor Management renders the **Register** tab.

`useTabParam` (COM-309) takes the list of tabs available to this reader and falls back to the first when the query string names one it does not recognise — deliberately, so a link to `?tab=approvals` opened by somebody without the permission lands somewhere sensible rather than on an empty page. COM-370 added the Portal tab and its panel but never added `'portal'` to that list, so clicking it sets `?tab=portal`, the hook rejects it as unknown, and the page renders the fallback.

- [ ] Add `'portal'` to the `canEdit` list in `VendorsPage.tsx`. It belongs only there — the tab is vendor-write gated, so a reader following a link to it should still fall back.
- [ ] Swept the other seven `useTabParam` callers: every one's list matches its rendered tabs. This is the only drift.
- [ ] Regression test on the shape of the bug rather than this one tab: click every tab Vendor Management renders and assert each shows its own panel. A test naming `portal` would pass the next time somebody adds a tab and forgets the list — this is the second half of a two-part change that has no compiler tying it together.
