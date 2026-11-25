---
id: 01M87NPND8AN476F9PXXD35AMQ
created: 2026-11-24T20:59:33.672164Z
updated: 2026-11-25T04:06:14.119128Z
type: task
title: 'Business services link to Inventory: the systems, software and data a service depends on'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2151
sprint: ss3ttbb
blocked_by:
- 01M87NPDZVSSZPHJ5EJ6KND9G9
comments:
- id: 01M8821TTDXYK73Y0VQFEZ4CHK
  author: Steve Vine
  at: 2026-11-25T00:35:22.573191Z
  text: |-
    Built and merged to main: PR #2149 (b10f9e8f8), migration 0916_business_service_assets.

    What people see:
    - A service's page has a Depends on card. It lists the systems, software and data assets it uses, each with an optional note ("call recording"), picked from one list covering all three kinds by whoever manages the inventory.
    - Also shown, not stored: the systems those systems depend on, and the systems holding linked data, each with its route ("through AST-4 · Call platform").
    - Each system, software and data asset page has a Supports services card: the services that depend on it, directly (with the note) or through another record (with the route), plus the service's type and criticality.
    - A retired service keeps its links but takes no new ones (marked Retired on asset cards). A decommissioned asset can't be newly linked; one already linked stays, marked, and isn't walked through.
    - An asset a service depends on can't be deleted while linked ("In use: supports SVC-3 TAS"). The link can be removed from the asset's delete dialog, and moves to the kept record when a duplicate is deleted.
    - A service with links can't be deleted; it suggests Retire.
    - Linking and unlinking are in the service's History.
    - Polaris can link, unlink, and answer "what does TAS depend on?" and "which services does AST-4 support?".

    Tested: backend integration for all three kinds and routes both sides, unlinking, retired, decommissioned and other-company rules, the delete guard, the duplicate move, History, migration up → down → up, and the Polaris tools. Continuity, inventory deletion and backup suites still pass. Vitest covers both cards. CI green after one rerun: the first run crossed midnight UTC and 7 date-based tests elsewhere in Compass failed (registers, collection, control checks). They passed on rerun. That's an existing weakness, not this change.

    For Steve to decide:
    1. A linked data asset brings in the systems that hold it, as Continuity does.
    2. Software supports a service when it's installed on any system the service depends on.
    3. A note can't be edited after linking (unlink and relink to change it).
    4. Links are made only from the service's page; the asset's card is read-only.

    Not checked yet: seen in a browser (staging pre-UAT).
- id: 01M88E3XV7K1KVD7EWA2R8ZNE8
  author: Steve Vine
  at: 2026-11-25T04:06:14.118932Z
  text: |-
    Pre-UAT on staging a63d542b2: **Passed**.
    - TAS linked to AST-54 (note "call platform"), SFT-19 and DAT-11 (note "call recording"). The card adds "AST-42 … through AST-54".
    - AST-42's Supports services shows "TAS Through AST-54"; the others show "Directly".
    - Unlinking clears both sides and writes History.
    - AST-54's Delete is disabled: "In use: … supports SVC-1 TAS".
    Screenshots: ~/compass-uat/ss3ttbb/COM-2151/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Business Services". Follows the Business services page.

## What people see
- **A service's page** has a **Depends on** card listing the systems, software and data assets it uses. Each can be added or removed, with an optional note ("call recording").
- **Also shown, not stored:** the systems those systems depend on, via Inventory's existing dependencies. They're listed separately as "through AST-4 · Call platform", so the whole chain is visible.
- **A system's, software's and data asset's page** shows **Supports services**: the services that depend on it, directly or through another system, with the route.
- **A retired asset** still shows (marked) on services already linked to it.
- Linking and unlinking are in the activity log.
- Polaris can link and unlink, and answer "what does TAS depend on?" and "which services does AST-4 support?".

## Done when
- In E2E Test Company: link TAS to a system, a software asset and a data asset.
- The system's page shows TAS. A system that the linked system depends on shows TAS "through" it.
- Unlinking removes it from both sides.
- Deleting a system that a service depends on follows the existing delete rules for linked assets.

## For the build
- One link table, business service ↔ asset. Use a polymorphic asset kind like `inventory_risk_links` (kind + asset id) or three FKs with a one-target check like `bia_function_dependencies`. Prefer real FKs.
- Walk dependencies with the breadth-first walk `core/continuity.py` `_walk` already uses.
- Update the inventory delete guard (`core/inventory_deletion.py`).
- Audited. Add the link table to the backups catalogue.
- **On the chain**: migration + API.