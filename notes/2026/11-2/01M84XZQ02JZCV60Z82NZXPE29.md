---
id: 01M84XZQ02JZCV60Z82NZXPE29
created: 2026-11-23T19:26:35.522131Z
updated: 2026-11-24T07:47:26.603659Z
type: task
title: 'Restore option 3, part 2: put chosen records back from an opened copy, with their original reference numbers and anything they depend on'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2122
sprint: szwetpq
blocked_by:
- 01M84XZDDRKWVYD86CQY2SVR8K
comments:
- id: 01M868C86D27BP0AJX02CFK3H1
  author: Steve Vine
  at: 2026-11-24T07:47:26.541206Z
  text: |-
    Merged: #2121, e034eaeed, 24 Nov 07:46 GMT. No migration, two new API routes. Not on staging yet: the sprint deploys together. ADR 0174 (putting records back) is Proposed, for Steve to read.

    Built: from the compare view, an Admin ticks records and chooses Put back. A preview shows exactly what returns, what is overwritten (with differences), what else must come with it, and who is left out. A reason is required. Each record keeps its original number and is recorded as "Put back from BKP-n". It's all one step, so a failure leaves nothing changed.

    What it never does:
    - Put back people, roles, access requests, tokens, credentials, settings or logs, including through a crafted API call.
    - Loosen a restriction or classification.
    - Send an email or "assigned to you" message, write to an integration or change access.
    - Run during a hold or maintenance (it's refused).

    The Admin also needs the area's own edit right.

    Decisions made in the build, for Steve:
    - On a record that still exists today, the people named on it stay as they are today, owners included. On a record that's gone entirely, a register's owner and editors and a pending acceptance's approver are left empty, and anyone else comes back only if still active. This narrows ADR 0172's "ownership goes back with the data" for put-back.
    - Gap comments, vendor certificates, contacts and engagements, and document versions and reviews are only ever added, never removed.
    - Evidence deleted for good isn't put back.
    - A vendor put back reappears on the Trust Centre subprocessor list; the preview says so.
    - What deleting a document tidied up (Library folders, reading groups, runbook systems) isn't redone; the result says so.

    Reviews: four rounds of independent review. The first found 2 high and 5 medium issues, including restrictions loosening, approvers coming back, and reminder mail not being silenced. Every issue was fixed, each with a failing test first except the very last small guard.

    Tested: 41 put-back tests through the API, plus the opened-copy, restore, Keep audit logs, hold, maintenance, backup and recovery suites (313), and the full CI suite.

    Couldn't check yet: the Put back window in a browser (pre-UAT), and how fast a very large install would be.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
ADR 0169 §7.

**Chain:** on the chain — API.

**What people see**

- From the compare view, the Admin ticks records and chooses **Put back**.
- Before anything happens, Compass shows exactly what will change: records returning, records being overwritten (with their differences), and anything else that has to come too because a chosen record depends on it.
- A record changed since the copy is overwritten only if the Admin ticks that it should be.
- A reason is required. The result reports what came back, and anything that couldn't and why.

**Done when**

- A deleted risk, control or document comes back with its **original reference number** and its links to records that still exist.
- A record depending on another that has gone either brings it too, with the Admin's agreement, or isn't put back. No broken links.
- If a reference number has since been used by a different record, the put-back is refused for that record and says so.
- An evidence record whose file has gone comes back marked as having no file.
- Each record put back appears in the activity log as "Put back from BKP-n" by that Admin, and the rest of Compass (search, posture, compliance figures) reflects it.
- Nothing put back causes an email, integration write or access change.
- People, roles, access requests, tokens, credentials, settings and logs cannot be put back, including by calling the API directly.

**Technical notes**

- One transaction per put-back, so a failure leaves nothing half done.
- Write through the ORM with an actor set, so the normal activity logging applies. Bulk SQL would skip the `before_flush` listener.
- Dependencies come from the foreign keys of the catalogue's tables, walked only within the allowed areas. A dependency outside them (a person, say) is reported, and the link is left empty only if the column allows it.
- Check soft-deleted rows: many "missing" records still exist with `deleted_at` set, and those are an update rather than an insert.