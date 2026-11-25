---
id: 01M87HNT543P1VA5RGBFX96GJR
created: 2026-11-24T19:49:11.460515Z
updated: 2026-11-25T09:17:39.624266Z
type: task
title: 'Requests carry several departments: new vendor, new engagement, edits and amendments'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2148
sprint: sectbn9
blocked_by:
- 01M87HNCQ8RWA88ZTR0B1TTZ03
comments:
- id: 01M87XFCDCAD4YCQ204YNGW7KV
  author: Steve Vine
  at: 2026-11-24T23:15:23.691932Z
  text: |-
    Built and merged to main: PR #2146 (21ef53664), migration 0914_request_departments.

    What people see:
    - Request a new vendor and Request an engagement (portal and the Requests tab) pick one or more of the company's active departments, at least one. The "No departments set up yet" message is unchanged.
    - The approver's review shows every requested department.
    - Summaries read "Departments: Finance, IT" (or "Department: Finance" for one). An amendment reads "Changed departments from Finance to Finance, Operations".
    - Edit request shows the departments and can add or remove some, but not save with none.
    - Amend engagement starts from the engagement's own departments and proposes a new set. The approver sees "departments: Finance → Finance, IT (adds IT)", and what's removed too. Approved, the engagement takes exactly that set; rejected, nothing changes.
    - Another company's department, or a retired one being newly added, is refused on every route. A retired one already there can be kept.
    - A department in any open request's proposed set can't be deleted.
    - Polaris's request tools take one or several departments by name.
    - Older requests still read correctly: one proposed department becomes a set of one.

    Tested: backend integration for two departments on new vendor and new engagement, an amendment approved and rejected, edits can't empty the set, retired and other-company refusals, the delete guard, and the migration against seeded rows (up, read back, down, up). 212 tests in the touched files. Vitest covers the forms, Edit request, Amend engagement and the approver's diff. CI green after one fixed Polaris test.

    For Steve to decide:
    1. The approver's diff adds a dimmed note, "(adds IT; removes Operations)".
    2. A missing department says "Pick at least one department." (same wording as the engagement form) rather than "Required.".
    3. An engagement recorded before departments existed can still be amended without choosing any, so old engagements aren't blocked.
    4. The engagement's activity line now reads "departments Finance → Finance, IT".

    Not checked yet: seen in a browser (staging pre-UAT after both sprints).
- id: 01M88E3NB7AFZNESKJ89JFBTEY
  author: Steve Vine
  at: 2026-11-25T04:06:05.415714Z
  text: |-
    Pre-UAT on staging a63d542b2 (requester E2E Asset Owner, approver E2E Vendor Admin): **Passed**.
    - A new-engagement request with Finance and IT: My requests and the approver's review read "Departments: Finance, IT". Once approved, the portal card shows both.
    - Amendment on A4, Finance → Finance + Operations: the diff reads "departments: Finance → Finance, Operations (adds Operations)". Rejected, A4 unchanged. Re-sent and approved, A4 shows "Finance, Operations".
    - Edit request can't empty the set ("Pick at least one department."). A new-vendor request refuses none.
    - Older requests still read correctly.
    Screenshots: ~/compass-uat/sectbn9/COM-2148/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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