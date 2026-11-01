---
id: 01M6AHX8D55WMH57XA6ARBXVCT
created: 2026-11-01T03:19:35.077746Z
updated: 2026-11-01T03:37:41.139706Z
type: task
title: 'Bug: a risk assessment''s History in the portal asks for the people list it can''t read — a failed request on every visit, and a person shown by their ID'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1498
sprint: snvd637
comments:
- id: 01M6AJYD0K1XRR7KFGGRS9CDB0
  author: Steve Vine
  at: 2026-11-01T03:37:41.139548Z
  text: |-
    Done, merged to main in PR #1515.

    - A portal-only reader's History no longer asks for the list of people. So the failed request on a submitted risk assessment is gone, and so is the same failure on other portal pages that show History.
    - A person History can't name reads "someone", never their ID. That holds inside Compass too, e.g. for someone whose account has been disabled.
    - An ID that isn't a person, such as an incident's "Duplicate of", is shown as before.
    - Inside Compass, people are still named.

    A new test covers it, and all 76 test files that show History pass. It goes to staging with COM-1497, and I'll check RA-3 there.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint 80, Update user portal. Found in Claude's pre-UAT pass on 2026-11-01 (COM-1495).

## What people see

- Opening a risk assessment in the portal once it has been submitted makes a request for the list of people, which the portal account isn't allowed (403). Nothing shows on screen, but it's a failed request on every visit. The Browser smoke fails any screen where a request fails, so it would go red if it ever walks this page.
- The History card then shows a person by their ID, e.g. "Dpo user: — → dc4c2a39-…". The History list is meant never to show an identifier.
- After the fix, a portal-only account never asks for the people list from History. A person History can't name reads "someone" instead of an ID. Inside Compass, a person is still named as before.

## Notes (technical)

- `ActivityChanges` calls `useUserNames()`, which always fetches `GET /users/directory`. That route answers internal users, and portal assessors only while their assessment is a draft or in progress (COM-1495).
- Give `useUserNames` an `enabled` argument. `ActivityChanges` passes false for a portal-only account. A `_id` value it can't resolve reads "someone".

**Chain:** independent (frontend only).

**Done when:** on staging, signed in as E2E Asset Owner, RA-3 (submitted) opens with no failed request, and its History shows no raw IDs.