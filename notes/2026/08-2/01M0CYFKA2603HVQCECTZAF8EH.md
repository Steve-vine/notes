---
id: 01M0CYFKA2603HVQCECTZAF8EH
created: 2026-08-19T12:03:36.898322Z
updated: 2026-08-25T18:43:00.22928Z
type: task
title: Two-pane picker — Map/remove actions pushed off-screen by the ScrollArea table wrapper
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 278
order: 2.3125
sprint: s5gwx0s
comments:
- id: 01M0CZ7F65F3PE4EYAF9YVKT34
  author: Steve Vine
  at: 2026-08-19T12:16:39.109155Z
  text: 'Design direction from Steve during smoke (2026-08-19): the action must be always visible and right-aligned in the pane; long descriptions should wrap, not truncate and not force row width. Fix amended accordingly — plain scrolling Box for both panes (kills the ScrollArea table-wrapper width bug), description Text wraps naturally (truncate + tooltip dropped), rows align flex-start so the pinned action sits at the top of a wrapped row. PR #270 updated.'
- id: 01M0D0BJ9S6KWYZV6TSR41V14H
  author: Steve Vine
  at: 2026-08-19T12:36:21.945824Z
  text: |-
    Fixed, merged to main (PR #270) and deployed to staging (2026-08-19, deploy green, /readyz 200).

    Root cause: Mantine/Radix ScrollArea renders its viewport content in a display:table wrapper that sizes to content rather than the pane, so one long real-tenant group description stretched every row to the widest one and pushed the trailing action past the pane's right edge — reachable only by horizontal scroll. Short fixtures + jsdom's lack of layout meant dev and CI couldn't see it.

    Landed per the smoke-time design direction: both panes scroll in a plain Box (mah + overflow-y), long descriptions wrap within the pane (truncate + tooltip dropped), and the Map button / remove icon is pinned top-right and always visible — the row can never exceed the pane width again, so the horizontal scrollbar is gone too. Layout isn't assertable in jsdom, so this one is verified by eye: hard-refresh the role page.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
---
Smoke finding, Sprint 34 (2026-08-19). On the role detail two-pane picker (COM-258), group rows render but the Map button (and the mapped pane's remove icon) is nowhere to be seen — "the map button has disappeared".

Cause: Mantine's `ScrollArea` (Radix underneath) renders its viewport content in a `display: table; min-width: 100%` wrapper that sizes to **content**, not to the pane. Inside it, `truncate` has no width constraint to truncate against, so a row with a long real-tenant group description stretches to its natural width and the whole list adopts the widest row — the trailing action lands beyond the pane's clipped right edge. Everything looked fine in development and CI because the fixtures had short names and jsdom performs no layout: the COM-258 "the button never shrinks" work solved flex-shrink, then the ScrollArea wrapper reintroduced the same disease one layer up.

Fix: replace both `ScrollArea.Autosize` wrappers in `RoleDetailPage` (candidates pane + mapped pane) with a plain scrolling `Box` (`mah` + `overflow-y: auto`) — a normal block context constrains row width to the pane, truncation works, actions stay visible. No other Access screens use ScrollArea (checked); the sidebar's ScrollArea (COM-268) scrolls a narrow nav and is unaffected.

Verified server-side before diagnosis: the mappable feed is healthy (814 assigned security groups, 200 OK responses, only 6 legitimately role-assignable in the first page) and permissions intact — this is purely a rendering defect.

Refs: COM-258 (the pane), COM-268 (unrelated nav ScrollArea), `access/RoleDetailPage.tsx`.