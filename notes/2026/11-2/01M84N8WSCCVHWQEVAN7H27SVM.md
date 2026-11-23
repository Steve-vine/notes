---
id: 01M84N8WSCCVHWQEVAN7H27SVM
created: 2026-11-23T16:54:19.180415Z
updated: 2026-11-23T16:54:21.655984Z
type: task
title: A provided register's "as at" date in an audit's trail follows the reader's date format
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2112
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: low
task_status: active
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