---
id: 01M65WPKAWTH1D5WWNBRBM77H8
created: 2026-10-30T07:51:59.068117Z
updated: 2026-10-30T18:45:57.892944Z
type: task
title: A commitment met by a certificate links to that certificate — "Met by" opens the certificate's own page in Audit ▸ Evidence, not the whole register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1466
sprint: s2v7d6y
comments:
- id: 01M66YBPY61B88A9GX15TWFGWD
  author: Steve Vine
  at: 2026-10-30T17:40:13.894803Z
  text: |-
    Done — PR #1483 merged.

    - A commitment's **Met by** link for a certificate now opens that file's own page in Audit ▸ Evidence: its details, expiry and file, marked if archived. It used to open the top of the register.
    - The same applies to a review flag that cites evidence.
    - Someone who can't see Audit ▸ Evidence sees the certificate's name without a link.
    - Not changed here: an archived certificate doesn't by itself turn a commitment At risk. Its expiry date (COM-1444) does.

    To test on staging: click Met by on an ISO 27001 commitment, and it lands on that certificate.
assignee: steve
label:
- follow_up
priority: low
task_status: done
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