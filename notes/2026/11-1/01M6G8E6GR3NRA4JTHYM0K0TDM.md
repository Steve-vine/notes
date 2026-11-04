---
id: 01M6G8E6GR3NRA4JTHYM0K0TDM
created: 2026-11-03T08:29:31.032653Z
updated: 2026-11-04T07:46:09.196975Z
type: task
title: After marking an item not relevant, Raise is still offered until the page is reloaded (and missing after Reopen)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1535
sprint: s6xh9g1
comments:
- id: 01M6GA9WV2YTM1YZVGY7KM8YBP
  author: Steve Vine
  at: 2026-11-03T09:02:07.201864Z
  text: |-
    Done: PR #1549 merged (4782b7a2), deployed to staging at 08:44.

    Saving a decision (confirm, not relevant, reopen) now refreshes what the item page offers to raise.

    Pre-UAT (staging, E2E Test Company): **Passed**. On CVE-2025-14180 as E2E Admin A, with no reloads:
    - open: "Confirm: affects us | Not relevant | Raise vulnerability | Raise risk";
    - after Not relevant: "Confirm: affects us | Reopen";
    - after Reopen: Raise vulnerability and Raise risk were back.

    Screenshots: ~/compass-uat/sprint-102/COM-1535/
assignee: steve
label: null
priority: medium
task_status: done
---
Found in the sprint 102 pre-UAT (2026-11-03), checking COM-1531.

## What people see

On an item page, a manager marks the item **Not relevant**. The status changes, but **Raise vulnerability** and **Raise risk** stay on the page. Clicking one is refused ("It's marked not relevant. Reopen it to raise from it."). After a reload they're gone, as COM-1531 intends. The reverse also happens: after **Reopen**, Raise doesn't come back until a reload.

## Fix

Saving a decision (confirm, not relevant, reopen) refreshes what the page offers to raise.

**Cause (technical):** `useMatchChanged` in `securityFeed/item/hooks.ts` updated the match and the feed queries but not `security-feed-raise-options`.

**Chain:** independent (frontend only).

**Done when:** on staging, marking an item not relevant takes Raise away at once and Reopen brings it back, without a reload.