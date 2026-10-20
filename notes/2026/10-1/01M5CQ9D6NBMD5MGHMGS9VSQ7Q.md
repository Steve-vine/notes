---
id: 01M5CQ9D6NBMD5MGHMGS9VSQ7Q
created: 2026-10-20T13:16:23.125391Z
updated: 2026-10-20T13:16:23.125391Z
type: task
title: Subprocessors on the trust centre — admins tick vendors from Vendor Management, with what each does and where it processes data; vendors that receive data in Inventory are suggested first
label: feature
assignee: steve
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1168
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