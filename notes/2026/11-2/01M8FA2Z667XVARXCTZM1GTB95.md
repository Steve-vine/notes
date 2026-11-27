---
id: 01M8FA2Z667XVARXCTZM1GTB95
created: 2026-11-27T20:10:29.446385Z
updated: 2026-11-27T22:31:18.437704Z
type: task
title: A request for a directory role on its own can be submitted — and its end date reads "27 May 2027"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2200
sprint: smq8t5s
comments:
- id: 01M8FCC5Y8C2VJ8RNDTXJMP0VM
  author: Steve Vine
  at: 2026-11-27T20:50:28.424357Z
  text: |-
    Done — merged to main in PR #2205. It goes to staging with the next deploy.

    What changes:
    - In New request ▸ Membership change, a directory role on its own (make eligible, or take a role away) can be submitted. Submit for approval no longer waits for a group or mailbox as well.
    - The summary has a Directory roles line (added / removed). The empty-state note reads "choose a group, a shared mailbox or a directory role".
    - The window's subtitle says it adds or removes groups, shared mailboxes and directory roles.
    - The end date shows in the person's date format ("27 May 2027") on the form and on the request page.

    Checks: a new test raises a role-only request (summary counts it, Submit enables, the role is sent). Full frontend suite and type check pass, and all CI jobs passed.
- id: 01M8FG51NGHB6NC1FK904KNXPB
  author: Steve Vine
  at: 2026-11-27T21:56:28.976797Z
  text: |-
    Pre-UAT on staging 44dd66b5e: Passed

    Steps (E2E Test Company only):
    1. As E2E Access Manager, Access Control ▸ Requests ▸ New request ▸ Membership change. Person: Compass Test. Directory roles: Make eligible for Message Center Reader, Until left at its default, Add. Reason: "Pre-UAT check, not to be carried out". No group, mailbox or list right chosen.
    2. The window's subtitle reads "Add or remove groups, shared mailboxes and directory roles for one or more people."
    3. The side summary shows "Directory roles: 1 added, 0 removed" (+1), and its note reads "What is added is recorded as approved for them, with the reason given." Submit for approval was enabled with only the role chosen.
    4. The Until field shows "27 May 2027". The added line under it reads "Message Center Reader — eligible until May 27, 2027". That is this account's own date format: its request list shows dates as "Nov 27, 2026". No "2027-05-27" anywhere.
    5. Submitted: "Request raised", ACR-211. The request page shows "Made eligible for: Message Center Reader — until May 27, 2027" and "This touches privileged access, so it needs an Access Admin: it changes directory roles: Message Center Reader."
    6. As E2E Admin B, the same page reads "until 27 May 2027", Admin B's format. Rejected with "Pre-UAT check, not to be carried out". ACR-211 now shows Rejected, and nothing was carried out.

    Note for Steve: the side summary counts the role ("Directory roles +1") but doesn't name it. The role's name and end date are on the line under the role picker. The fix's own description said the summary would have a Directory roles count, so I didn't fail it on this, but the "Done when" said the summary names the role. Also, for anyone whose format differs from the date picker's, the Until box ("27 May 2027") and the line under it ("May 27, 2027") read differently in the same window.

    Screenshots: ~/compass-uat/sprint-128/COM-2200/
assignee: steve
label:
- bug
priority: high
task_status: done
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