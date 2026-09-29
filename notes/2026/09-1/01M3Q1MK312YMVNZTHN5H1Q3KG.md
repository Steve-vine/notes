---
id: 01M3Q1MK312YMVNZTHN5H1Q3KG
created: 2026-09-29T16:58:16.033847Z
updated: 2026-09-29T16:58:41.240954Z
type: task
title: The trail in the user portal — and its back links go
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 791
sprint: svq5edz
blocked_by:
- 01M3Q1K82GNMBWV667KHS4THGT
assignee: steve
label:
- feature
priority: medium
task_status: todo
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