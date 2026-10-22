---
id: 01M5G0YRAWE31YZBN55V9VEZ53
created: 2026-10-21T20:03:03.132556Z
updated: 2026-10-22T18:24:39.964907Z
type: task
title: A vendor's certificates keep their history — renewing keeps the previous certificate, the certificate file itself can be uploaded, deleting asks first and archives instead, every change is in Activity, and certificates appear in the Evidence register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1213
sprint: sno3i7m
blocked_by:
- 01M5G0Y8EETEVC34RKEFHCH612
comments:
- id: 01M5GX8T700GREJEX1RHM6GA4F
  author: Steve Vine
  at: 2026-10-22T04:17:52.864541Z
  text: |-
    Done — merged in PR #1227.

    - **Renew** on a vendor's certificate asks for the new valid-until date, issuer, link and the renewed PDF. The previous certificate is kept, with its dates and file, under "1 earlier".
    - **Upload** adds the certificate itself (a PDF) to one that has no file yet. **Add certification** takes the PDF too. A **Certificate** link downloads it.
    - **The ×** now archives instead of deleting, and always asks why. Archived certificates fold away under "N archived", with the reason.
    - **Activity** records every add, correction, renewal ("renewed vendor certification ISO 27001 of Acme Ltd — version 2") and archive, under the vendor's company. Before, nothing was recorded.
    - **Archived certificates** drop out of the vendor's Certified badge, Needs attention and the expiry to-dos.
    - **In Audit ▸ Evidence** each certificate shows as "Vendor · Acme Ltd", type Certificate or audit report, with its file. Its page lists every version, each downloadable, and says to renew it on the vendor's page. Archived ones are in the Archived tab.
    - **The assistant** can renew a certificate and archive one with a reason. It can't upload or delete.

    My calls (beyond the task):
    - **One file per version.** A different certificate means renewing it.
    - **Renewing** keeps the issuer, link and name unless new ones are given. The new version starts without a file.
    - **Edit** stays for correcting the current version, and is now recorded in Activity. An archived version can't be edited, renewed or archived again.
    - **Due soon** in the register uses its general 30 days for certificates. The vendor's own 42-day window still drives its badge and to-dos.
    - **Archived companies:** certificate changes aren't blocked on an archived company, matching the rest of Vendor Management.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1212 (chain order); uses archiving from COM-1211.

**Chain:** on the chain — migration + API

## What people see

On a vendor's **Certifications** card:
- **Renew** makes a new version with its own valid-until, issuer, link or file. The previous certificate is archived with its dates, and both appear in the card's history. Today a renewal overwrites them.
- **Upload the certificate** (a PDF) as well as, or instead of, a link to it. Links rot; the file stays.
- **Delete** asks for confirmation and archives the certificate with a reason. Today one click deletes it, with no record.
- Every add, renewal and archive appears in Activity. Today certificate changes aren't recorded at all.

**In the register:**
- Vendor certificates appear as "Vendor · Acme Ltd — ISO 27001", with evidence type "Certificate or audit report".
- Expiry warnings stay as they are today (the vendor's own reminder window).
- They can be linked to the controls they support (COM-1209), e.g. the vendor-assurance controls.

**Vendor purge** (admin, after offboarding) still removes them. It's deliberate, and the purge is recorded as today.

## Notes (technical)

- `vendor_certifications` gains version / archive columns (same shape as COM-1211) and an attachment owner type `vendor_certification` for the file.
- Add `vendor_certifications` to the audited tables.
- The confirm dialog follows the shared kit modal.

**Done when:** renewing a certificate leaves the old one archived with its old dates; deleting asks first and leaves it in Archived; Activity shows both; the certificate appears in the register with its file.