---
id: 01M84N8WSCCVHWQEVAN7H27SVM
created: 2026-11-23T16:54:19.180415Z
updated: 2026-11-23T17:46:37.932402Z
type: task
title: A provided register's "as at" date in an audit's trail follows the reader's date format
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2112
sprint: ssj8zkq
comments:
- id: 01M84R8M9H9K3S5RDXJJWNZP31
  author: Steve Vine
  at: 2026-11-23T17:46:36.209063Z
  text: |-
    Fixed and merged to main: PR #2106 (332117731). No migration or API change. Not on staging yet.

    What people see:
    - The "as at" day in a provided register's trail lines appears in the reader's own date format (US, UK or ISO), on a request's History and the audit's Activity, for providing, taking off and withdrawing.
    - The day doesn't shift for a reader in a far-off time zone.
    - Older lines are read the same way when they match Compass's exact wording. Anything else stays as written, and a date typed in a withdrawal reason is left alone.
    - Who sees the register's name is unchanged, and the auditor portal gains nothing.

    For Steve to check:
    1. The request list's export still writes the "as at" day in UK format. It was outside this task, so it could be a follow-up.
    2. An older line stays as written if the register's own name contains the words "from request".
    3. Noticed from the COM-2108 code, not tested: if a withdrawal reason contains a Restricted register's full name, someone who can open that register may see "a Restricted register" at the start of the line instead of its name. It hides more than it should and reveals nothing.

    Tested against real Postgres: US, UK and ISO readers on both views, for all three kinds of line; readers either side of the date line; someone who can't open the register. Auditor Viewed and Downloaded lines are covered by unit tests only. CI green.

    Not yet checked in a browser on staging: that comes with the re-test.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Sprint "Registers - Phase 2". Found re-testing COM-2108 on staging f6abe2fd5 (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2108/06-assessor-owner-request-history.png`.

## The problem
Read as E2E Assessor, whose account uses US dates, a line in a request's History has its time as "Nov 23, 2026, 4:46 pm" but its text says "as at 23 Nov 2026".

## What people see
- The "as at" date in a provided register's trail lines appears in the format of the person reading, on a request's History and the audit's Activity, for providing, taking off and withdrawing.
- The day itself never shifts with the reader's time zone: it's the day the register was provided as at.
- Lines written before this fix read the same way if the day can be read from them; otherwise they stay as written.
- Who sees the register's name is unchanged (COM-2108).

## Done when
- A reader with US dates and a reader with UK dates each see the "as at" day in their own format, on both views.
- The day is the same for a reader in a far-off time zone.
- Someone who can't open the register still reads only "a Restricted register".

No migration expected.