---
id: 01M862F5FPACCAXYP92H1YVE5N
created: 2026-11-24T06:04:10.614156Z
updated: 2026-11-24T22:40:42.501162Z
type: task
title: Two decision records created at the same moment no longer fail with an error over the same DEC number
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2130
sprint: szwetpq
comments:
- id: 01M87VFV2G74W4SDC6YCZ0QDX9
  author: Steve Vine
  at: 2026-11-24T22:40:41.552424Z
  text: |-
    Merged: #2144, 7b653315a, 24 Nov 22:39 GMT. No migration, no API change. Goes to staging with the next deploy, and into v0.27.0.

    Cause: decisions, and findings within one audit, take "one above the highest there is", with nothing counting them. Two created at the same moment read the same highest number, and one failed with a server error. Audit findings had the same race.

    Fix: taking a number now holds a short lock for that kind of number until the record is saved, so a second create waits and gets the next number. This is the locking pattern Compass already uses. The restore floor (ADR 0170) is still honoured and existing numbers are unchanged. A decision created with a number chosen by hand that's already taken now gets a clear "already in use" answer, not a server error. The findings spreadsheet import and Polaris go through the same path.

    Tested: four new tests on real Postgres all failed before the fix and pass after. 5 decisions at once get DEC-1 to DEC-5. With a restore floor of 40, they get DEC-41 to DEC-45. A chosen number racing an automatic one gets created or "in use", never an error. 5 findings on one audit get F1 to F5. The decision, finding and restore suites pass, and so does the full CI suite. An independent review found nothing significant.

    Two older gaps, not fixed here, for Steve:
    - A decision number chosen by hand (only the ADR import does this) isn't checked against the restore floor.
    - Deleting an audit's highest finding lets the next finding reuse its number.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found by the COM-2124 rehearsal while seeding data. Outside the Backup and Restore sprint.

**What happened**

Creating two decision records at the same moment (two requests in parallel) made one of them fail with a server error: both tried to take the same DEC number. Decisions take "one above the highest", with no counter (ADR 0170 notes this), so concurrent creates race.

**Done when**

- Two or more decisions created at the same moment each get a distinct DEC number, and none fail.
- Numbers are still never reused, including after a restore (`restored_number_floors`, ADR 0170).
- Check whether audit findings (the other kind numbered "one above the highest") have the same race, and fix both the same way.
- A test creates decisions concurrently against real Postgres.