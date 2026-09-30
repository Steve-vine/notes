---
id: 01M3ST5QFKGRDVS82PDBCYXFYR
created: 2026-09-30T18:45:32.275977Z
updated: 2026-09-30T18:47:29.539241Z
type: task
title: The user portal in the new look — its own sidebar and top bar, and every portal page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 813
sprint: s0zzctz
blocked_by:
- 01M3SSZK3J4SQR87K0XGRCXHTG
- 01M3ST04QGV1F3BH3F9J4XDZXK
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The staff self-service portal gets the same frame as the main app, with its own menu, and its pages in the prototype's patterns. Nothing it does changes.

## What people see

- **The portal's frame matches the main app's:**
  - a sidebar that folds to icons, with the portal's own menu (Recertifications, Inventory, Vendors, My vendors, Requests, Actions);
  - the top bar with the trail, the light/dark toggle, notifications and your initials.
  - The brand link still starts a new trail.
  - Someone who also uses the main app finds the portal laid out the same way.
- **Recertifications:**
  - the list with chips by state;
  - a review's page in detail layout, with each person to confirm or remove as a row and the decision buttons in their own column.
- **Inventory:** the assets you own, in the kit's list, and each asset's portal page in detail layout.
- **Vendors, My vendors and Requests:** lists, a vendor's portal page in detail layout, and the request form in the new look.
- **Actions and Notifications:** as in the main app.

## Notes (technical)

- **The frame.** `components/PortalLayout.tsx` rebuilt on the shell pieces from the new-shell task: sidebar, top bar and `useShell`. `portalNav.ts` is unchanged.
- **Pages:**
  - `PortalRecertificationsPage`, `PortalRecertReviewPage`;
  - `PortalInventoryPage`, `PortalContainerPage`, `PortalDataAssetPage`, `PortalSoftwareAssetPage`;
  - `PortalVendorsPage`, `PortalMyVendorsPage`, `PortalRequestsPage`, `PortalVendorDetailPage`;
  - `PortalActionsPage`, `NotificationsPage portal`, `PortalLanding`.
- **Keep:**
  - the portal write-routes allowlist ([[portal-write-routes-allowlist]]);
  - the portal trail behaviour from COM-791.
- **Ratchet.** Empty these pages' entries from the page-header ratchet.
- **Flakes.** Mind [[portal-tests-company-refetch-gap]] and [[frontend-vitest-parallel-flake]].

**Done when:** on staging, a portal-only user sees every portal page in the new layout, with the sidebar folding and the trail in the top bar.