---
id: 01M84XZQ02JZCV60Z82NZXPE29
created: 2026-11-23T19:26:35.522131Z
updated: 2026-11-24T05:18:08.960646Z
type: task
title: 'Restore option 3, part 2: put chosen records back from an opened copy, with their original reference numbers and anything they depend on'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2122
sprint: szwetpq
blocked_by:
- 01M84XZDDRKWVYD86CQY2SVR8K
assignee: steve
label:
- feature
priority: medium
task_status: active
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