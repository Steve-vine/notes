---
id: 01M87NQ09XED3JVCD11CASC93A
created: 2026-11-24T20:59:44.829852Z
updated: 2026-11-25T02:41:52.920375Z
type: task
title: 'A vendor''s blast radius: services link to vendor engagements, and a vendor''s page shows every service it supports and how'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2152
sprint: ss3ttbb
blocked_by:
- 01M87NPND8AN476F9PXXD35AMQ
- 01M87HNCQ8RWA88ZTR0B1TTZ03
comments:
- id: 01M8899ECWWT52EXT13X0RJH92
  author: Steve Vine
  at: 2026-11-25T02:41:52.028493Z
  text: |-
    Built and merged to main: PR #2153 (b8208908e), migration 0920_engagement_services.

    What people see:
    - Adding or editing a vendor engagement in Compass has an optional Business services multi-select (the company's active services; a retired one already linked stays, marked). The engagement card lists them, and each link and unlink shows in the service's History.
    - A vendor's page has a Blast radius card: every service the vendor supports, with its type and criticality, and every route:
      - through a live (proposed or active) engagement;
      - worked out through Inventory: supplies a system the service depends on, publishes software linked to it or installed on one of its systems, or receives data linked to it or held on one, followed through system dependencies, e.g. "TAS → AST-4 · Call platform → AST-7 · SIP trunks → supplied by Twilio".
      - Several routes to one service are all listed.
    - Ending an engagement removes its route and keeps the Inventory ones. Decommissioned systems and data are left out. A retired service still shows, marked.
    - No criticality changes anywhere: the card shows the vendor's own criticality beside each service's, for comparison only.
    - A service's page has a Vendors card: every vendor supporting it, with its criticality and the routes.
    - Polaris answers "what's the blast radius of Twilio?" and "which vendors does LiveChat rely on?".
    - Compass only: the portal vendor page doesn't show Continuity, so it doesn't show the blast radius. The portal's engagement card names its services as text.

    Tested: backend integration for an engagement route, supplier, publisher and recipient routes (direct and through dependencies), ending an engagement, criticality unchanged, decommissioned assets left out, other-company and retired rules, the delete guard, History, migration up → down → up, and Polaris. Vitest covers both cards and the engagement form. CI green. An earlier CI failure (a sprint 125 migration test reaching the new table) was fixed by loading an engagement's services only when they're read.

    For Steve to decide:
    1. The engagement's Business services field only shows to people who can view the inventory. For others it's hidden and saving leaves the links alone.
    2. The Blast radius card needs only vendor viewing (like Assets). The service's Vendors card needs inventory viewing.
    3. The card always shows, with "No business service depends on this vendor" when empty.
    4. Vendor requests and amendments don't carry services; only adding or editing an engagement directly does.

    Not checked yet: seen in a browser (staging pre-UAT). Polaris setting services on an engagement is COM-2159.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Business Services". Follows the Inventory links. The heart of Steve's ask.

## What people see
- **Adding or editing a vendor engagement** in Compass has an optional **Business services** multi-select (the company's active services): what this engagement helps deliver.
- **A vendor's page** has a **Blast radius** card: every service the vendor supports, its type and criticality, and **how**. Routes:
  - directly through an engagement ("Call routing engagement");
  - worked out through Inventory: supplies a system the service depends on; publishes software installed on one; or receives data held on one, followed through system dependencies, e.g. "TAS → Call platform (AST-4) → supplied by Twilio".
  - Several routes to one service are all listed.
- **Only live engagements count.** Ended engagements don't. A vendor that's being offboarded still shows its blast radius until its engagements end.
- **A service's page** has a **Vendors** card: every vendor that supports it, with the same routes.
- **No criticality changes anywhere** (Steve): neither the vendor's nor the engagement's criticality is raised by the services it supports. The card shows the service's criticality beside the vendor's own, for comparison only.
- **Polaris** answers "what's the blast radius of Twilio?" and "which vendors does LiveChat rely on?".

## Done when
- In E2E Test Company: link an engagement of E2E Test Vendor to TAS. The vendor's Blast radius shows TAS "through engagement …".
- Make the vendor the supplier of a system TAS depends on, and the card also shows TAS "through AST-n".
- Ending the engagement removes the direct route but keeps the Inventory one.
- The vendor's and the engagement's criticality are unchanged throughout.
- TAS's page lists the vendor with both routes.

## For the build
- Engagement ↔ service link table (engagement FK CASCADE, service FK RESTRICT), like `vendor_engagement_data_entities`. Add it to engagement create/update (`department_ids`'s neighbour) and to outputs.
- The worked-out routes reuse `core/inventory_links.assets_for_vendor` / `software_for_vendor` (supplier, publisher, recipients) plus the service ↔ asset links and the dependency walk. Compute them in one place (e.g. `core/business_services.vendor_blast_radius(db, vendor_id)`) used by the vendor card, the service card and Polaris.
- The card goes on `VendorDetailPage` beside `VendorAssetsCard` / `VendorContinuityCard`.
- Portal: show it read-only on the portal vendor page too, if the portal shows Continuity there. Otherwise Compass only, with the reason noted.
- **On the chain**: migration + API.