---
id: 01M8FA2Z667XVARXCTZM1GTB95
created: 2026-11-27T20:10:29.446385Z
updated: 2026-11-27T20:10:41.008537Z
type: task
title: A request for a directory role on its own can be submitted — and its end date reads "27 May 2027"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2200
sprint: smq8t5s
assignee: steve
label:
- bug
priority: high
task_status: active
---
**Independent** (screen only — no migration, no API change). Fix-forward for COM-2183, found in Claude's pre-UAT pass on staging 30786db4f (27 Nov 2026).

## What's wrong
- In **New request ▸ Membership change**, choosing only a Directory roles change (make someone eligible, or take a role away) leaves **Submit for approval** greyed. The summary says "Nothing is changed yet — choose a group or a shared mailbox to add or remove." A role change had to be raised alongside a group change (ACR-207, rejected).
- The summary doesn't list the directory roles at all.
- The end date shows as "2027-05-27" in the form row and on the request page, not in the person's date format ("27 May 2027").
- The window's subtitle still says "Add or remove groups and shared mailboxes".

## Done when
On staging, as the Access Manager, a membership change for Compass Test with **only** "make eligible for Message Center Reader" can be submitted. The summary names the role and its end date in the person's date format. The request page shows the date the same way. Reject it as Admin B afterwards.

Screenshot: ~/compass-uat/sprint-128/COM-2183/01-change-access-directory-role.png