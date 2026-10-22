---
id: 01M5G0YRAWE31YZBN55V9VEZ53
created: 2026-10-21T20:03:03.132556Z
updated: 2026-10-22T03:26:04.249531Z
type: task
title: A vendor's certificates keep their history — renewing keeps the previous certificate, the certificate file itself can be uploaded, deleting asks first and archives instead, every change is in Activity, and certificates appear in the Evidence register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1213
sprint: sno3i7m
blocked_by:
- 01M5G0Y8EETEVC34RKEFHCH612
assignee: steve
label:
- feature
priority: high
task_status: active
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