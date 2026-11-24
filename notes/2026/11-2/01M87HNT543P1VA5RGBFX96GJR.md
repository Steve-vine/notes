---
id: 01M87HNT543P1VA5RGBFX96GJR
created: 2026-11-24T19:49:11.460515Z
updated: 2026-11-24T19:49:17.494466Z
type: task
title: 'Requests carry several departments: new vendor, new engagement, edits and amendments'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2148
sprint: sectbn9
blocked_by:
- 01M87HNCQ8RWA88ZTR0B1TTZ03
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint "Vendor Departments". Steve's amendment while testing on staging (24 Nov 2026): an engagement can have several departments. Part 2 of 2; follows COM-2147.

## What people see
- **Request a new vendor** and **Request an engagement** (portal and the Requests tab) use a multi-select Department, of the company's active departments. At least one is required. The "No departments set up yet" message is unchanged.
- **The approver's review** shows all the requested departments.
- **Edit request** (after "more information needed") shows them and can add or remove some, keeping at least one.
- **Amend engagement** can propose a new set of departments. The approver sees what's added and what's removed (e.g. "Departments: Finance → Finance, IT"). Approved, the engagement takes the new set. Rejected, nothing changes.
- **Request summaries** list all the departments.
- **Polaris's request tools** take one or several departments by name.
- Another company's department, or a retired one being newly added, is refused on every request route.

## Done when
- In E2E Test Company, as a portal requester: a new-engagement request with Finance and IT reaches the approver showing both. Once approved, the card shows "Finance, IT".
- An amendment from Finance to Finance + Operations shows the change, and applies on approval and not on rejection.
- Edit request can change the set, and can't leave it empty.
- Requests and amendments raised before this change still read correctly.

## For the build
- The request's proposed department column (`proposed_department_id`, COM-2134) becomes a proposed set: a link table or an array. Migrate any existing value into it. Test the migration against a populated database.
- `VendorOnboardingEngagementIn` / `VendorEngagementAmendmentIn` / `VendorRequestEditIn` take `department_ids`. The request detail outputs `departments` / `proposed_departments`. `core/vendor_approval` `_PROPOSABLE` / `ProjectedEngagement` / `apply_amendment` and the activity line handle the set. `vendor_request_summaries` lists every name.
- UI: `EngagementFields`, `AmendEngagementModal`, `ReviewModal` `EngagementBox`, `AmendmentDiff`. Polaris `vendors_requests`.
- The "proposed by an open request" delete guard (COM-2134) counts the set.
- **On the chain**: migration + API, after COM-2147. COM-2143 (summary follows edits) touches the same summaries, so build it after this one.