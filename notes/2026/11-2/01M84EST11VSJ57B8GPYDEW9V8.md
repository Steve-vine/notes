---
id: 01M84EST11VSJ57B8GPYDEW9V8
created: 2026-11-23T15:01:13.377307Z
updated: 2026-11-23T16:22:57.07619Z
type: task
title: An audit's trail shows a Restricted register by name to people who can open it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2108
sprint: ssj8zkq
comments:
- id: 01M84KFC32ZYFZP0Z1J5TRRZBX
  author: Steve Vine
  at: 2026-11-23T16:22:54.306072Z
  text: |-
    Fixed and merged to main: PR #2101 (3fb60ff0b). No migration or API change. Not on staging yet.

    What people see:
    - The register's owner, its editors and administrators read its name on a request's History and the audit's Activity, for providing, taking off and withdrawing.
    - Someone who can't open it reads only "a Restricted register". This is decided when the line is read, so it follows a person being added or removed as an editor.
    - The auditor portal doesn't read this trail, so an auditor can't get a register's name through it. The auditor's own Viewed and Downloaded lines follow the same rule for Compass users.

    Worth knowing:
    1. Lines written before this fix never recorded which register they meant, so they keep the hidden wording even for the owner, including the UAT-4 line in the screenshot. To check this task, provide a register again. COM-2094 isn't in any release, so production has no such lines.
    2. Typed text isn't caught: a Restricted register's name typed into a withdrawal reason is shown as written.
    3. Possible follow-up, not changed: someone with no right to view registers still sees an unrestricted register's name in the trail, while the request itself tells them "A register you can't open".

    Tested against real Postgres: owner, editor and administrator on both views; someone who can't open it; a person added and removed as editor; a line from before it was restricted. Two existing assertions had the old behaviour built in and were corrected. CI green.

    Not yet checked on staging: that comes with the re-test.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2104 on staging e2248892e (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2104/03-admin-request-history.png`.

## The problem
Admin A owns a Restricted register and provides it to an audit request. The request's History and the audit's Activity tab read "Added a Restricted register, as at 23 Nov 2026 to request UAT-4", while the same request lists the register by name just above. The hiding from COM-2104 is applied to people who can open the register as well as those who can't.

## What people see
- Someone who can open the register (its owner, editors, an administrator) reads the line in full, with the register's name.
- Someone who can't still reads "A Restricted register".
- This holds on a request's History and the audit's Activity, and for providing, removing and withdrawing it.

## Done when
- The owner, an editor and an administrator see the register's name on both.
- Someone who can't open it sees only "A Restricted register" on both.
- A line written before the register was restricted follows the same rule.

No migration or API change expected.