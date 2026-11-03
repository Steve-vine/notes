---
id: 01M6G8E6GR3NRA4JTHYM0K0TDM
created: 2026-11-03T08:29:31.032653Z
updated: 2026-11-03T08:29:33.018893Z
type: task
title: After marking an item not relevant, Raise is still offered until the page is reloaded (and missing after Reopen)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1535
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03), checking COM-1531.

## What people see

On an item page, a manager marks the item **Not relevant**. The status changes, but **Raise vulnerability** and **Raise risk** stay on the page. Clicking one is refused ("It's marked not relevant. Reopen it to raise from it."). After a reload they're gone, as COM-1531 intends. The reverse also happens: after **Reopen**, Raise doesn't come back until a reload.

## Fix

Saving a decision (confirm, not relevant, reopen) refreshes what the page offers to raise.

**Cause (technical):** `useMatchChanged` in `securityFeed/item/hooks.ts` updated the match and the feed queries but not `security-feed-raise-options`.

**Chain:** independent (frontend only).

**Done when:** on staging, marking an item not relevant takes Raise away at once and Reopen brings it back, without a reload.