---
id: 01KZXG0N8HZF3BQQR1X00P49Y1
created: 2026-08-13T12:02:10.833315Z
updated: 2026-08-13T14:13:43.592567Z
type: task
title: Collapsable Estate warning
project: 01KX671DATY39VW6GWK3M2T3DN
number: 683
sprint: sevhjex
comments:
- id: 01KZXQHFZDAWNZF7Q1G87EB1QM
  author: Steve Vine
  at: 2026-08-13T14:13:42.509259Z
  text: |-
    2026-08-13 — DONE, PR #635 merged to main.

    The count stays on the screen; the per-root list is now behind a click and collapsed on arrival. Clicking the heading toggles it, chevron included.

    Three decisions worth recording:

    1. **The count was NOT collapsed with the list.** "22 platform roots state no infrastructure environment" is the signal — the thing that should keep nagging. Hiding it too would have turned the fix into a mute button. Only the remediation detail (ISE-529's per-root "which half is missing") is opt-in.

    2. **The collapsed state is deliberately NOT persisted.** Everything else on this screen remembers itself (filters, sort, page size, panel open/closed), so persisting would have been the consistent-looking choice — and wrong. A warning that can be put away once and never seen again is a warning that stops working; the roots stay unfixed and the screen stops saying so. It re-collapses each visit, which also means the count is re-read each visit.

    3. **Conditionally rendered, not height-animated.** A closed `<Collapse>` inside a Mantine `Alert` still counts as children, so the Alert renders its message slot and its top margin — a strip of empty orange under the title. Rendering the body only when open avoids it. No animation, which for a box that opens on arrival at zero-height is no loss.

    Tests assert the shape asked for, not just that a toggle exists: the list is absent on arrival, present after a click, absent again after a second. The existing ISE-529 test now opens the box first. 18/18 in EstatePage.test.tsx; prettier, eslint, build, api-types all green on the PR.

    Note for the sprint: the PR's CI run did not register for ~3 minutes after the PR was opened — `gh run list --branch` showed nothing at all while the runners sat idle. A close/reopen fired it. Worth not diagnosing as a broken workflow next time; the run list simply lags.
assignee: steve
label: null
priority: medium
task_status: review
---
On the estate tab a warning box is displayed '22 platform roots state no infrastructure environment’ can this section be made collapsable, and collapses by default.