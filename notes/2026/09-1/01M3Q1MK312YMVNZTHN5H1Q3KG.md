---
id: 01M3Q1MK312YMVNZTHN5H1Q3KG
created: 2026-09-29T16:58:16.033847Z
updated: 2026-09-30T18:40:59.033523Z
type: task
title: The trail in the user portal — and its back links go
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 791
sprint: svq5edz
blocked_by:
- 01M3Q1K82GNMBWV667KHS4THGT
comments:
- id: 01M3Q56KFBHZGDHEADGS4G2DDR
  author: Steve Vine
  at: 2026-09-29T18:00:31.978801Z
  text: |-
    Done: PR #801, stacked on #800.

    - **The trail.** The user portal now shows the same trail as the main app. Its menu starts a trail, links add steps, and a page you return to opens where you left it.
    - **Back links gone.** Vendor, asset and recertification review pages no longer have their "← Vendors" / "← My assets" / Recertifications links, and each names its own step.
    - **Pasted vendor links.** These now show Vendors › …, the register. Before, the back link went to the portal's landing page.
    - **Vendors tabs.** Vendors, My Vendors and My requests count as one step, named for the tab you were on.
    - **Leaving the portal.** Going back to Compass with the Compass logo starts a new trail.

    With this, no staff screen has a hand-written back link any more. Only the vendor portal, for outside users, keeps its own.

    The full frontend suite passes locally.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Carries the trail from COM-787 into the user portal, the staff self-service area with its own menu. The vendor portal for outside users is out of scope (COM-786).

## What people see

- **Portal pages lose their fixed back links.** Today a vendor shows "← Vendors", an asset "← My assets", and a recertification review "← Recertifications".
- **The portal's menu starts a trail**, just as the main app's does, and links within the portal add steps.
  - Example: My assets → an asset → its vendor reads `My assets › CRM platform › Acme Ltd`.
- **Requests and approvals tabs** behave like any other tabs: the step returns to the tab you were on.

## Notes (technical)

- **Shell.** `components/PortalLayout.tsx` is a separate shell. Render the same `Trail` there, and pass the trail start from its menu (`:126`, same `navigate()` pattern as `AppLayout`).
- **Back links removed.** Clear these from the ratchet allowlist:
  - `pages/PortalVendorDetailPage.tsx` 78/87
  - `PortalContainerPage.tsx` 50/59
  - `PortalDataAssetPage.tsx` 48/57
  - `PortalSoftwareAssetPage.tsx` 40/48
  - `PortalRecertReviewPage.tsx:98`
- **Redirect.** `/portal/approvals` redirects to `/portal/requests?tab=approve`. It must be a REPLACE, so it leaves no step.
- **Natural homes.** `/portal/vendors/:id` → today's link goes to `/portal`. Check whether `/portal/vendors` is the better home now that `PortalVendorsSection` exists.
- **Vendor portal.** It stays exempt in the ratchet test. After this task, the vendor portal is the only exemption.

**Done when:** on staging, a portal user's asset → vendor chain returns step by step. The ratchet allowlist holds only the vendor portal.