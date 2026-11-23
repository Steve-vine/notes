---
id: 01M84N8WSCCVHWQEVAN7H27SVM
created: 2026-11-23T16:54:19.180415Z
updated: 2026-11-23T18:54:33.456972Z
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
- id: 01M84W51ZGNZHPYVT878GBMQDG
  author: Steve Vine
  at: 2026-11-23T18:54:33.456784Z
  text: |-
    Pre-UAT on staging d8a915977: PARTLY CHECKED. Everything I could check passed, no defects. Two parts need a reader the test accounts don't include.

    Done when:
    1. US and UK readers each see the "as at" day in their own format, on both views.
       - Request History, UK: Passed. E2E Admin A, AUD-7 AQ-1 to AQ-4: "Added E2E UAT 122 Auditor Shared (UAS), as at 23 Nov 2026 to request AQ-1".
       - Request History, US: Passed, on AUD-6 rather than AUD-7. E2E Assessor gets "Audit not found" on AUD-7 because they have no part in it, and I left AUD-7 as it is. On AUD-6 (where they are a named auditor), RT-1 to RT-3 read "as at Nov 23, 2026", for both adding and taking off.
       - Audit Activity, UK: Passed. E2E Admin A on AUD-5, AUD-6 and AUD-7: "as at 23 Nov 2026".
       - Audit Activity, US: Couldn't check. No test account with US dates can open an audit's Activity (Assessor, Access Manager and Vendor Admin are all refused; Asset Owner is portal-only and wasn't tried). Steve: look at this with an account that has US dates and can see Activity.
    2. The day is the same for a reader in a far-off time zone: Couldn't check. Every test account is on UTC, and I didn't change an account's settings. Setting the browser itself to UTC+14 and UTC-11 left the line unchanged, but Compass uses the account's zone, so that doesn't prove this line.
    3. Someone who can't open the register reads only "a Restricted register": Passed. E2E Viewer on AUD-7 AQ-4 sees "A Restricted register, as at 23 Nov 2026" and "Added a Restricted register, as at 23 Nov 2026 to request AQ-4". E2E Assessor on AUD-6 RT-1 sees the same wording, where E2E Admin A sees the name (URS).

    Not seen: a withdrawal line. None exists yet on AUD-5, AUD-6 or AUD-7, and AUD-7 was read only.

    Also noticed, not a defect of this task: on AUD-5, UAT-4's line from 14:45 (before COM-2108) still says "a Restricted register" to E2E Admin A, although the same request's evidence names URS. It hides more than it needs to and reveals nothing.

    AUD-7 unchanged: 5 requests, all open, 6 Activity lines, latest still 17:42.

    Screenshots: ~/compass-uat/sprint-122/COM-2112/
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