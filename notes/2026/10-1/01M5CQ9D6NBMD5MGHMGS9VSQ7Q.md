---
id: 01M5CQ9D6NBMD5MGHMGS9VSQ7Q
created: 2026-10-20T13:16:23.125391Z
updated: 2026-10-21T09:16:47.458791Z
type: task
title: Subprocessors on the trust centre — admins tick vendors from Vendor Management, with what each does and where it processes data; vendors that receive data in Inventory are suggested first
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1168
sprint: sq3fav7
blocked_by:
- 01M5CQ8Y09SMCBJ5D55MKQ3HSJ
comments:
- id: 01M5E3SVH4G0VDT3TGJ2YK3K3A
  author: Steve Vine
  at: 2026-10-21T02:14:19.426514Z
  text: |-
    Done — merged in two parts: #1173 and #1179.

    - **Content ▸ Subprocessors**: pick from the company's vendors in Vendor Management. **Suggested** come first: vendors that receive one of the company's data assets in Inventory, with the asset named.
    - Purpose and location are written here. Name and website always come from the vendor record, so they never drift apart.
    - Put the list in order with up/down buttons. "List last changed …" moves on whenever the list changes.
    - If a vendor is offboarded or deleted, it's flagged "Offboarded — remove from the list?" and visitors stop seeing it straight away.
    - Visitors see a **Subprocessors** part: name (linked to the vendor's website), what it does, where, in your order, and "List last changed …". An empty list doesn't appear.
    - Visitors never see anything else about a vendor: no risk tier, assessments, contracts, contacts or notes.

    My calls:
    - "List last changed" comes from the audit log, so it covers additions, removals, edits and reordering.
    - A vendor website is linked only if it's a plain http(s) address. Anything else shows as the name alone.
    - An offboarded vendor stays on the admin list, flagged, until someone removes it, but it's off the portal at once.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 81, Trust Centre Portal (ADR in COM-1157). Builds on COM-1167 (the Content tab).

## What people see

**In the module, Content ▸ Subprocessors:**

- **Add subprocessors**: a picker of the company's vendors in Vendor Management. At the top, **Suggested**: vendors that receive one of the company's data assets in Inventory and aren't on the list yet.
- Each subprocessor: the vendor's name and website (from the vendor, kept in step), plus **purpose** ("Cloud hosting") and **location** ("UK, Ireland"), written here. Ordered by drag.
- A vendor that's offboarded in Vendor Management is flagged "Offboarded — remove from the list?" rather than disappearing silently.
- "Last changed" date, set automatically when the list changes.

**On the portal:** a **Subprocessors** table: name (linking to its website), purpose, location, and "List last changed 12 Oct 2026". It doesn't appear with nothing on the list.

## Notes (technical)

- `trust_centre_subprocessors` (company, vendor_id, purpose, location, order). Audited. Name/website read from the vendor at serve time.
- Suggestions from `DataAssetRecipient` joined to the company's data assets.
- Only the fields above leave Compass: never the vendor's risk tier, assessments or contract notes.

**Done when:** an Admin adds a suggested vendor with purpose and location, and a visitor on staging sees it in the table with the last-changed date.