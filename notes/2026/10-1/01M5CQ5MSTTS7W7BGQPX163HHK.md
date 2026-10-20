---
id: 01M5CQ5MSTTS7W7BGQPX163HHK
created: 2026-10-20T13:14:19.834322Z
updated: 2026-10-20T19:46:15.042195Z
type: task
title: The Documents tab — link library content (always its current published version) or upload a PDF of evidence with a valid-until date, mark each for everyone invited or restricted, and be warned before evidence expires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1159
sprint: sq3fav7
blocked_by:
- 01M5CQ56XJQ845YBYF1SC25492
comments:
- id: 01M5DDK69K7FEBZGJSSGND5QNN
  author: Steve Vine
  at: 2026-10-20T19:46:12.403416Z
  text: |-
    Done — merged in PR #1164.

    - Trust Centre ▸ Documents is the first tab. Documents are grouped by category in the order the portal will show them: Policies, Certificates, Audit reports, Penetration tests, Other. Each row shows:
      - what it is: library content with the version served, or an uploaded PDF;
      - who sees it: Everyone invited or Restricted;
      - its valid-until date;
      - its status: Shown, Hidden, Expired, or Unavailable with the reason.
    - Add a document, two ways:
      - From the library: pick a published policy or standard. Visitors always get its current published version as a PDF. If it's unpublished or deleted, the row says why and it isn't served.
      - Upload evidence: a PDF with a name, category, issued date and valid-until date. A Certificate also names its scheme (ISO 27001, SOC 2 Type I/II, Cyber Essentials (Plus), PCI DSS, HITRUST, ISO 27701, ISO 42001, Other).
    - Uploads must really be PDFs, checked by their content. Password-protected or damaged PDFs are refused, so a later download can never fail on them.
    - Anyone who can view the trust centre can Preview a document as visitors will get it, without the visitor's watermark.
    - Managers can:
      - edit a document's details;
      - replace the file, which keeps its place, tier and access;
      - remove it, after confirming;
      - drag it within its category, or use the arrow keys on its handle.
    - Expiry: everyone with Manage the trust centre gets a to-do 30 days before the valid-until date, a reminder at 7 days, and an overdue item once it has expired. Replacing, hiding or removing the document clears it.
    - Uploaded files also appear in Admin ▸ Files as "Trust centre document". Every change is in the activity log.

    My calls:
    - A document is valid through its valid-until date and stops being served the day after.
    - Only a Certificate must have a valid-until date. Other evidence may leave both dates blank.
    - Library documents carry no dates and can't be Certificates.
    - Only documents Compass writes itself (templated content) or manages in SharePoint can be shared. Uploaded or linked library items can't.
    - Compass has no per-company house style. The document uses its content type's style, the same as any document export.
    - A removed document is kept in the background, so the visitor history that later tasks add keeps its name.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1158.

## What people see

A **Documents** tab listing what the company shares: name, kind, tier, valid until, status (Shown / Expired / Hidden).

**Add a document**, two ways:

- **From the library**: pick a policy, standard or other published content item. The portal always serves its current published version, as a PDF in the company's house style. If it's unpublished or retired it drops off the portal and the row says why.
- **Upload evidence**: a PDF, with a name, a category (Certificate, Audit report, Penetration test, Other), the date issued and a valid-until date. A **Certificate** also names its scheme (ISO 27001, SOC 2 Type I, SOC 2 Type II, Cyber Essentials, Cyber Essentials Plus, PCI DSS, HITRUST, ISO 27701, ISO 42001, Other) for the badges task.

Each document has:

- **Tier**: **Everyone invited** or **Restricted** (opened up per visitor, behind the NDA);
- **Shown on the portal**: on/off, to stage a document before sharing it;
- a short **description** visitors see.

Documents are grouped on the portal by category, in an order admins can drag.

**Expiry:** on its valid-until date an uploaded document stops being shown, and the row reads Expired. A to-do goes to everyone who can manage the trust centre for that company 30 days and 7 days before. Replacing the file (the renewed certificate) keeps the document's place, tier and grants.

## Notes (technical)

- One `trust_centre_documents` table: `source` (`library | upload`), `content_item_id` or an attachment, category, scheme, issued/valid-until, tier, shown, order. Audited.
- Library PDFs via the ADR 0110 renderer / `content_pdf` with the company's house style; cache by published version.
- Uploads through the attachment store; reject anything that isn't a PDF (check the bytes, not just the name).
- Expiry to-dos as an Actions source (ADR 0055).

**Done when:** an Admin can add a library document and an uploaded certificate, see an expired one drop to Expired on its date, and receives the 30- and 7-day to-dos.