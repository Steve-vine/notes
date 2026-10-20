---
id: 01M5CQ5MSTTS7W7BGQPX163HHK
created: 2026-10-20T13:14:19.834322Z
updated: 2026-10-20T18:46:24.460997Z
type: task
title: The Documents tab — link library content (always its current published version) or upload a PDF of evidence with a valid-until date, mark each for everyone invited or restricted, and be warned before evidence expires
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1159
sprint: sq3fav7
blocked_by:
- 01M5CQ56XJQ845YBYF1SC25492
assignee: steve
label:
- feature
priority: high
task_status: active
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