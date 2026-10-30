---
id: 01M65WPKAWTH1D5WWNBRBM77H8
created: 2026-10-30T07:51:59.068117Z
updated: 2026-10-30T17:23:09.064579Z
type: task
title: A commitment met by a certificate links to that certificate — "Met by" opens the certificate's own page in Audit ▸ Evidence, not the whole register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1466
sprint: s2v7d6y
assignee: steve
label:
- follow_up
priority: low
task_status: active
---
Sprint 98, Contract Review (ADR 0134). Gap found while building COM-1443.

## What people see

- A commitment such as "maintain ISO 27001" is met by a certificate in the Evidence register. Its **Met by** shows the certificate's name, but clicking it opens **Audit ▸ Evidence** at the top of the register, and the person has to find the certificate themselves.
- After this, Met by opens that certificate's own entry (its details, expiry and file), the same as any other link to an evidence item.
- If the certificate has since been archived, the link still opens it, marked archived, and the commitment shows At risk.

## Who can do what

Unchanged: the link opens only for people who can see that evidence item; otherwise the name shows without a link.

## Notes (technical)

- Met-by link building on `pages/ContractCommitmentPage.tsx` (and the commitments table) sends `certificate` to the register route. Point it at the evidence item route used elsewhere (the register's item drawer or page, via its URL-backed selection).
- Check the archived case.

**Chain:** independent (frontend only).

**Done when:** on staging, Steve clicks Met by on an ISO 27001 commitment and lands on that certificate.