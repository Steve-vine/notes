---
id: 01M1539KGPJF8NAHB0AJENE5DG
created: 2026-08-28T21:09:29.750043Z
updated: 2026-08-28T21:10:23.290724Z
type: task
title: 'Application credentials: what expires, and when'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 499
sprint: s5cyp1z
assignee: steve
company: null
label:
- feature
priority: medium
task_status: todo
---
Applications and service principals as report subjects in the ADR 0062 catalogue, and the seeded reports that make them worth mirroring.

Catalogue fields on top of COM-498: display name, owner, whether it is ours, enabled, and the derived ones that carry the governance — **days until the soonest credential expires**, **credential count**, **has a secret**, **has a certificate**, **has no owner**.

Seeded definitions:

- **Credentials expiring in the next 30 days** — the outage nobody sees coming.
- **Expired credentials still in place** — dead configuration, and a signal an app is unused.
- **Applications with no owner** — nobody to ask, nobody to recertify against.
- **Long-lived secrets** — a secret with years left on it is a standing finding in every review.
- **Applications signing in from any Microsoft account** — the multi-tenant audience setting, usually set by accident.

Expiry is a **date field in the catalogue, not a status column**. A report saying *expiring soon* must be able to say soon-by-how-much, and *soon* means something different at renewal time than at review time — a wizard author changing 30 days to 7 is the design working.

An application with no credentials at all is not a finding and must not appear in an expiry report; the catalogue has to distinguish *no expiry* from *no credential*.