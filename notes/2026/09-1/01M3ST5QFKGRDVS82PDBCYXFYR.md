---
id: 01M3ST5QFKGRDVS82PDBCYXFYR
created: 2026-09-30T18:45:32.275977Z
updated: 2026-10-01T01:51:57.500301Z
type: task
title: The user portal in the new look — its own sidebar and top bar, and every portal page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 813
sprint: s0zzctz
blocked_by:
- 01M3SSZK3J4SQR87K0XGRCXHTG
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3TJJD8CWWG04QFCEV70D3PY
  author: Steve Vine
  at: 2026-10-01T01:51:53.61192Z
  text: |-
    Done: PR #824, merged to main (4f6c1bc).

    What you'll see in the user portal:
    - **The same frame as the main app:**
      - a sidebar with the portal's own menu, which folds to icons and remembers;
      - the top bar with the trail, company, light/dark, notifications and your initials.
      - The "Compass Portal" name sits at the top of the sidebar and still leads back in. As before, there's no search box or light bulb.
    - **Access Control:**
      - Recertifications has chips (All, To review, Submitted, Completed).
      - A review shows how many still need a decision, with Submit at the top. Each person is a row with their decision and the Certify / Flag for removal buttons lined up on the right.
    - **My assets:** the new list. Each asset's page has the new header, with the details on the left and reviews and notes on the right.
    - **Vendors:**
      - one "Vendors" header over Register / My Vendors / My requests, with **Request a new vendor** in the header;
      - the register gains a search box.
    - **A vendor's page** has the same header and fact cards as inside Compass. The Compliance card shows when the vendor was last reviewed.
    - **Actions and Notifications** are as in the main app.

    Things decided while building:
    - **The portal's lists now keep their filters, search and sort in the address,** as the main app's do.
    - **Submit recertification moved to the top** of a review, so it isn't lost at the bottom of a long list.
    - **Your sidebar choice is shared** between the portal and the main app.

    All checks passed.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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