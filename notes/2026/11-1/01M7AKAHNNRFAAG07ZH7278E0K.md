---
id: 01M7AKAHNNRFAAG07ZH7278E0K
created: 2026-11-13T14:00:00.949151Z
updated: 2026-11-13T14:00:04.236206Z
type: task
title: Checks ▸ Review lists what's waiting in a group, so you can see all the new checks at once and open any one, instead of only stepping through them one by one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1795
sprint: spsp226
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Found by Steve on 2026-11-13 while reviewing 43 new checks proposed for Moneypenny from FreshService and SentinelOne.

## What happens now

Each group on Checks ▸ Review (New checks, Changes, Rules, Still fine, Can't be automated, Audit flags, Held) shows one item at a time, with "N of M", Previous/Next and the arrow keys. With 43 new checks there's no way to see what's there, find the ones for one control or one service, spot duplicates (e.g. the FreshService change list proposed under CHM.1, CHM.2, CHM.4 and CHM.7), or go straight to one.

## What people see

- Each group opens as a **list**, one row per item, showing:
  - the control (ref and short title)
  - the check's name
  - the integration and account it reads
  - for a new check, its sample count (e.g. "1,654 items")
  - flags such as "sensitive fields"
  - a sample that couldn't be taken
  - how long it has waited
- Sortable by control, integration and waited. Filterable by integration, by control or domain, and by the batch it came from (the `?batch=` link filters to that batch, as today).
- Clicking a row opens the item's full card, as it shows today (reads, sample, rule, Approve / Change / Discard), with Previous/Next and the arrow keys still stepping through the list in its current order and filter. Closing the card returns to the list where you were.
- After an item is approved or discarded, the list drops it and the card moves to the next one.
- The group's count in the tab badge is unchanged.

## Done when

- The New checks group with 43 items shows them as a sortable, filterable list, and opening, stepping and acting from the card behave as above.
- The same applies to the other groups.
- There are tests for the list, its filters (integration, control, batch) and returning to the list after acting.
- The screen-conventions tests pass (sortable headers).

**Independent.**