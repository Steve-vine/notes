---
id: 01M1539KGPJF8NAHB0AJENE5DG
created: 2026-08-28T21:09:29.750043Z
updated: 2026-09-01T13:55:52.37308Z
type: task
title: 'Application credentials: what expires, and when'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 499
sprint: s5cyp1z
blocked_by:
- 01M1539868BE8QNCSYNQJYXNGF
- 01M14W3AV7PF8DFJEKKB4CSEQN
comments:
- id: 01M16Y7DCJS6NMDY8TW2S9ZZHK
  author: Steve Vine
  at: 2026-08-29T14:19:23.922468Z
  text: |-
    Done — PR #509, merged to main (ce0b401).

    Two subjects, Applications and Service principals, because COM-498 mirrored two objects and the questions read differently on each. Both carry the same credential and ownership fields, built once from one shared piece of code so "days until a credential expires" cannot come to mean two things.

    Expiry is a date the catalogue counts from, never a status column — a reviewer sitting down in January wants ninety days where a renewal cycle wants seven, and both are the same report with one number changed.

    Two things it deliberately gets right. "Days until a credential expires" is the soonest expiry *still ahead*, not the soonest of all: an application carrying a secret that died in 2020 would otherwise report a big negative number and answer "expiring within 30 days" with a yes, which is the report below it, not this one. And it reads as unknown when there is nothing left to expire — so an application with no credentials never appears in an expiry report at all. No credential and no expiry stay different answers.

    Secrets and certificates are never counted together: a certificate with years on it is normal, a client secret with years on it is a standing finding, and merging them would bury the second in the first. "Has an owner" counts any owner including one Compass cannot recognise, while the Owner column names only the people — an owner that is itself an application is somebody you cannot email.

    Service principals also carry "holds a directory role" (an application with a role has the privilege a person would, with nobody signing in for it) and ours / a third party's / not said, which stays three states.

    Five new reports in the library: credentials expiring in the next 30 days, expired credentials still in place, applications with no owner, long-lived secrets, and applications signing in from any Microsoft account.

    Smoke test: Access Control → Reports. The five appear in the library and run; the wizard offers Applications and Service principals as subjects. All of it stays empty until the Application.Read.All consent from COM-498 is in place.
assignee: steve
label:
- feature
priority: medium
task_status: done
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