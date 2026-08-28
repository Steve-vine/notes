---
id: 01M1537P2M7EKCKG5VRKCVQ3XR
created: 2026-08-28T21:08:26.836101Z
updated: 2026-08-28T21:08:26.836101Z
type: task
title: 'Who has MFA: mirror authentication method registration'
priority: high
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 497
company: null
---
Discovery finding, 2026-08-28. *Which accounts have no second factor* is the most-asked question in any access review, and Compass cannot answer it at all — not partly, not approximately. It is the biggest single gap in the mirror.

Graph reports it whole: `/reports/authenticationMethods/userRegistrationDetails`, one paged call, one row per user. Mirror per user:

- **is MFA registered**, and **is MFA capable** — registered but not enforced is a different finding from not registered, and the two must not be merged;
- **is passwordless capable**, **is SSPR registered / enabled / capable**;
- **the methods registered**, as a list;
- **the default method**;
- **is admin** as Graph reports it — useful as a cross-check against our own privileged-role view, never as a substitute for it.

Held on its own table keyed by the directory user, not as columns on `DirectoryUser`: it comes from a different endpoint on a different cadence, and folding it in would make a failure of the reporting endpoint look like a change to the user.

**Confirm the permission and the licence before starting.** `AuditLog.Read.All` is already requested and is expected to cover this; if the tenant needs `Reports.Read.All` instead, that is a new grant, and a new grant needs a worker restart before the token carries it. Check the Entra licence tier at the same time.

**A user with no row is *unknown*, never *no MFA*.** Reporting an unread account as unprotected produces a false finding in the one report people act on immediately, and one of those costs more trust than the report earns.

Seeded reports once the subject exists: *Users without MFA*, *Privileged users without MFA* (the one that matters), *Users with SSPR not registered*.