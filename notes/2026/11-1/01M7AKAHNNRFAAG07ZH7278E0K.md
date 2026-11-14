---
id: 01M7AKAHNNRFAAG07ZH7278E0K
created: 2026-11-13T14:00:00.949151Z
updated: 2026-11-14T10:26:49.6338Z
type: task
title: Checks ▸ Review lists what's waiting in a group, so you can see all the new checks at once and open any one, instead of only stepping through them one by one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1795
sprint: spsp226
comments:
- id: 01M7B4YA157VM4Y9WW45EEMRKW
  author: Steve Vine
  at: 2026-11-13T19:07:54.277346Z
  text: |-
    Built — PR #1791 (feature/com-1795-review-lists), auto-merge set. No migration; the review API returns a few more facts per item (control title and domain, check name, what it reads, sample size and flags, batch title).

    What you'll see on Checks ▸ Review:
    - Every group opens as a list, one row per item: the control (ref and short title), the check's name, the service and account it reads ("FreshService · Moneypenny"), the sample size for a new check or change ("1,654 items", or "Couldn't be taken"), flags ("n sensitive fields", "Part of the sample failed", "The system may have changed" when waiting over 30 days), how long it has waited, and in the other groups Polaris's reason under Why.
    - Sort by control, check, reads, sample and waited. Filter by Reads (the service), Domain, Control and Batch — all kept in the address. The ?batch= link works as before, with its summary.
    - Clicking a row opens the full card as a pop-up over the list. Previous/Next and the arrow keys step through the list in its current order and filter; A approves, D discards. After a decision the item leaves the list and the card moves to the next; Escape (or deciding the last one) closes back onto the list where you were.
    - Group counts and the tab badge are unchanged. "Accept all N" on Still fine and Can't be automated accepts the rows the list shows, filters included.

    Choices: the card is a pop-up with its own address (?item=) so closing keeps your place and a row stays a real link. Held captures aren't part of a batch, so they drop out while a batch is chosen, as today. "Couldn't" rows aren't clickable — nothing to decide.

    Checks: ruff/mypy clean, unit passed, review integration tests (4) passed, checks vitest 25 + screen-conventions pass. Not yet seen in a real browser — the pre-UAT pass will look at a long New checks list, dark mode and the pop-up.
- id: 01M7BJAS2RYWD7AD6BD0PZMDKF
  author: Steve Vine
  at: 2026-11-13T23:01:54.392144Z
  text: |-
    Pre-UAT: Passed, except a long list couldn't be checked (staging build 2f72416b, E2E Test Company, as E2E Admin A; light and dark).

    E2E Test Company has only 4 things waiting (Changes 1, New checks 2, Audit flags 1), so the 43-item New checks list can't be seen here — look at Moneypenny's Review tab for that.

    Steps and what I saw on Checks ▸ Review:
    - Each group opens as a list. New checks / Changes: Control (ACC.13 and its short title), Check, Reads ("Active Directory", "Microsoft 365"), Sample ("16 items", "89 items", "357 items"), Flags ("1 sensitive field", "9 sensitive fields"), Waited ("7 days"). Audit flags: Control, Why (Polaris's reason, cut at two lines), Flags, Waited.
    - Sorting: Control, Check, Reads, Sample and Waited headers sort and are kept in the address; Check up/down reversed the two new checks.
    - Filters: Reads lists All / Active Directory / Microsoft 365; picking Microsoft 365 left 1 row and survived a reload. Domain (Access Control), Control (ACC.13 …) and Batch ("Look over 1 controls for an audit") offer the right choices.
    - Clicking a row opens the full card as a pop-up ("1 of 2"), with its own address (?item=). The right/left arrow keys and Next/Previous step through the list in its sorted order; Escape closes back onto the list with the sort kept.
    - Acting: I discarded "Active Directory privileged groups and their members" (an old E2E proposal; E2E has no Active Directory) from the card. The card moved straight on to the other new check ("1 of 1"), the group became New checks (1) and the tab badge went from 4 to 3.
    - Changes and Audit flags open the same way (Approve/Discard; Accept: note it in the pack/Discard). Dark mode reads fine. No errors in the browser.

    Small thing, not this task: the batch is called "Look over 1 controls for an audit" (should be "1 control").

    Screenshots: ~/compass-uat/spsp226/COM-1795/
assignee: steve
label:
- feature
priority: medium
task_status: done
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