---
id: 01M7A80AP4PRRKA35DZ3WWNB0J
created: 2026-11-13T10:42:11.780397Z
updated: 2026-11-13T10:42:13.829754Z
type: task
title: 'Recertification: an empty review says so, a schedule shows who holds its access now, and an empty run is flagged'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1790
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## Why

Steve, testing on 2026-11-13, in production (Moneypenny):
- The 1 October review of the schedule **"Global Administrators"** was completed, but it "doesn't show any details of what was submitted by the reviewer".
- The cause: the schedule recertifies the Entra role **Domain Name Administrator**, which no people hold. The run started with **0 rows**, and the owner signed off an empty list.
- Nothing on screen said the review was empty, and nothing warned that the schedule pointed at access nobody holds. It looked like lost data.
- The intended target was probably Global Administrator (5 active, 14 eligible) or the on-premises Domain Admins group. The schedule fix itself is Steve's call and isn't part of this task.

## What changes

### 1. An empty review says so
- Where it applies:
  - the review's page in Access Control (the Instances tab detail);
  - the asset recertification equivalent in Inventory;
  - the reviewer's page in the User Portal.
- With no rows, these pages say plainly: **"Nobody held Domain Name Administrator when this review started, so there was nothing to keep or flag."**
  - This replaces an empty table.
- The owner can still sign off, which is valid evidence that nobody holds the access. The button reads **"Confirm nobody holds it"**.
- The sign-off is recorded as that, and appears that way in:
  - the review;
  - the evidence export;
  - SAP evidence of operation;
  - Polaris (`access_get_recert_review` says "nobody held it" rather than returning an empty `rows`).

### 2. A schedule shows who holds its access now
- In the schedule window, when you choose what it recertifies, show how many hold it now, for example **"5 people now (14 more eligible)"**.
- When the count is none: **"Nobody holds this now; a review would have nothing in it. Check you've picked the right one."**
  - It's a warning only, and saving is still allowed.
- The Schedules list shows the same count.
- Polaris's schedule create/update reply includes the count and the warning.

### 3. An empty run is flagged
When a scheduled review starts with nobody in it:
- it's still created and sent;
- it raises an **Action** for whoever can run recertification for that kind (Access or Inventory):
  - the Action reads: "Global Administrators review started with nobody in it: check the schedule recertifies the right thing";
  - it links to the schedule;
  - it clears when the schedule's target is changed or the review is completed.
- It follows the actions-queue rules (ADR 0055) and doesn't send extra mail beyond what the Action already does.

## On the chain
Probably on the chain: a field for "nobody held it" on the review and its sign-off, a current-holders count on schedules, and a new Action source. Decide when building. If it needs no API change, it's independent.

## Done when
- On staging, E2E Test Company:
  - a schedule on a role or group with nobody in it shows the warning when it's chosen;
  - starting it by hand produces a review that says "Nobody held … " instead of an empty table, on both the Access page and the owner's portal page;
  - the owner's "Confirm nobody holds it" is recorded and shows in the evidence export.
- The empty run raises the Action for an Access recertification runner. It clears when the schedule is pointed at a role with holders.
- The schedule window and list show the current holder count for a role with holders.
- An asset recertification behaves the same.
- Polaris says "nobody held it" for an empty review.