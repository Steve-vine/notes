---
id: 01M86D6PYBFKFKDPT119X18TKV
created: 2026-11-24T09:11:47.915218Z
updated: 2026-11-24T12:55:28.340533Z
type: task
title: A vendor engagement records its department, chosen when it's added, and shows it on the engagement card
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2133
sprint: sectbn9
blocked_by:
- 01M86D5X2254AHKNKDQSAQBMDB
comments:
- id: 01M86T07WW4NVPMCDV44C7W5DK
  author: Steve Vine
  at: 2026-11-24T12:55:27.388573Z
  text: |-
    Built and merged to main: PR #2127 (f7e56bec3), migration 0910_engagement_department.

    What people see:
    - Adding an engagement (a vendor → Engagements → Add) has a required Department drop-down of the company's active departments in their order. Without one: "Required." and nothing saved. The API refuses it too.
    - Editing shows the same drop-down. An older engagement with none reads "Not recorded" and must be given one before a proposed or active engagement can be saved. An ended one can be saved without.
    - A retired department stays on engagements that have it ("Finance (Retired)" in the form, a Retired mark on the card), but can't be newly picked.
    - A company with no departments: "No departments set up for <company> yet. An administrator adds them in Admin → Companies.", and the engagement can't be added.
    - The engagement card shows Department as its first fact, on the vendor page in Compass and in the portal ("Not recorded" when none). Renames show at once.
    - A department from another company is refused.
    - Deleting a department in use is refused with the count ("Finance is used by 2 engagements — retire it instead"). The Departments panel's "Used by N" now counts engagements.
    - Polaris: adding an engagement needs a department, named in words. A missing or unmatched name is refused with the company's list. Polaris can change it, and lists show it.

    Tested: backend integration for required, other company, change, rename, retire, live vs ended, the delete guard, register rows, a portal read, and migration up → down → up. The 280 vendor integration tests and 51 vendor assistant tests pass. Vitest covers the picker, the no-departments message, Not recorded, the retired value kept, and the portal card. CI green.

    For Steve to decide:
    1. An edit that doesn't touch the department (e.g. Polaris changing only the status) still goes through on an older engagement with none. The screen's edit form always requires it for live engagements.
    2. Another company's department is refused as "Unknown department" rather than "belongs to another company", so one company's list isn't revealed to another.

    Not checked yet: seen in a browser (staging pre-UAT). Restore ▸ Selected records: an engagement whose department has since been deleted is put back with the department left empty and a note, as for any other missing optional link. That was read in the code, not run.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Vendor Departments" (Steve, 24 Nov 2026). Follows COM-2131.

## Why
Steve: every engagement must say which department it is for, picked from the company's list (one only), and show it wherever the engagement is viewed.

## What people see
- **Adding an engagement** in Compass (a vendor → Engagements → Add) has a required **Department** drop-down listing the company's active departments in their order. Exactly one is chosen.
- **Editing an engagement** shows the same drop-down. An engagement that was added before departments existed reads "Not recorded" until someone picks one. Saving the edit form of a live (proposed or active) engagement requires a department, so older engagements get one the next time they're edited. An ended engagement can be saved without one.
- A retired department stays chosen on an engagement that already has it (marked Retired), but can't be newly picked.
- If the company has no departments yet, the drop-down is empty and says so: "No departments set up for <company> yet. An administrator adds them in Admin → Companies." The engagement can't be saved until there is one.
- **The engagement card** shows **Department** among the engagement's facts, both on the vendor's page in Compass and on the vendor's page in the portal. Engagements without one read "Not recorded".
- Polaris can say and set an engagement's department: adding an engagement through Polaris needs one, named in words (Polaris matches the name, and asks if it doesn't match an active department), and listing engagements shows each one's department.

## Done when
- In E2E Test Company, adding an engagement without a department is refused, on screen and through the API. With one, the card shows it in Compass and in the portal.
- A department from another company can't be set on an engagement (refused by the API).
- Changing the department on an existing engagement shows the new one on the card.
- Renaming the department in Admin → Companies changes what the card shows. Retiring it keeps it on the card, marked Retired, and it's no longer offered for new engagements.
- Deleting a department now in use is refused with the count (COM-2131's guard counts engagements).
- Polaris: `vendors_add_engagement` without a department is refused with a message naming the company's departments, and `vendors_list_engagements` returns the department.

## For the build
- `vendor_engagements.department_id`: nullable FK (RESTRICT) to departments. It's nullable because existing rows have none; "required" is enforced by the create/update schemas, not the column. Migration after COM-2131's.
- `VendorEngagementCreate` (schemas L9560) requires `department_id`. `VendorEngagementUpdate` (L9589) accepts it, and `update_engagement` (vendors.py L1089) refuses clearing it on a live engagement. Validate same company and active (allow keeping an existing retired one) in one resolver beside `vendor_reads.resolve_data_entity_ids` (L621).
- Out: `VendorEngagementOut` / `vendor_reads.engagement_out` (L660, built by hand) gains `department {id, name, retired}`. Add it to `VendorEngagementSummaryOut` too (register sub-rows, used in COM-2135).
- UI: admin `EngagementModal` in `vendors/detail/cards.tsx` (~L2679) and the facts grid of `EngagementsCard` (L2452, `EngagementFact`). One card serves `VendorDetailPage` and `PortalVendorDetailPage`. Picker: a `Select` from the company's departments with an "also allow" for the current retired value (compare `vendors/DataEntityPicker.tsx`).
- Polaris: `assistant/tools/vendors_engagements.py` (`_engagement_fields` L172, `_engagement_out` L99) plus a `resolve_department` beside `resolve_data_entities` in `vendors_common.py`. Update the engagement prose in `assistant/instance.py` (~L167).
- The request routes that create engagements (`_new_engagement` in core/vendor_requests.py) are COM-2134. Until it lands, requests still create engagements without a department, which is allowed at the column. Keep the requirement on `VendorEngagementCreate` only, so this task doesn't break portal requests.
- Probably **on the chain**: migration + API.