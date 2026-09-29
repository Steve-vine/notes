---
id: 01M3Q1KY6JGTF6H3A7D6JGZYJW
created: 2026-09-29T16:57:54.642748Z
updated: 2026-09-29T16:58:39.341462Z
type: task
title: The trail across Vendors and Inventory — and their back links go
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 789
sprint: svq5edz
blocked_by:
- 01M3Q1K82GNMBWV667KHS4THGT
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Carries the trail from COM-787 into Vendors and the information asset register.

## What people see

- **Vendor and asset pages lose their fixed back links.** Today a vendor page says "← Vendors", and a technology, data or software asset page says "← Inventory" or its tab.
- **Chains of links read as you followed them.** For example, a data asset → the technology it lives in → the vendor behind it → one of the vendor's risks: `Inventory › Customer records › CRM platform › Acme Ltd › R-12 …`. Each step returns to where you were, including the Inventory tab you started on (Technology / Data / Software).
- **Vendor pages are named by the vendor's name, assets by the asset's name.** Vendor tabs, such as questionnaires, behave like any other tabs: the step returns to the one you were on.

## Notes (technical)

- **Back links removed.** Clear these from the ratchet allowlist added by COM-787:
  - `pages/VendorDetailPage.tsx` 38/47
  - `ContainerDetailPage.tsx` 63/72
  - `DataAssetDetailPage.tsx` 66/75
  - `SoftwareAssetDetailPage.tsx` 58/67
- **Natural homes.** `/inventory/data/:id` → `/inventory?tab=data` and `/inventory/software/:id` → `/inventory?tab=software`, matching today's links. `/inventory/containers/:id` is a legacy redirect: make sure it's a REPLACE, so it doesn't leave a step behind.
- **Tabs.** `VendorDetailPage.tsx:30` and `InventoryPage.tsx:69` use `useTabParam` in the URL, so tabs already restore.
- **Filters.** `VendorsPage.tsx:95-99` and `InventoryPage` seed their filters from the URL once and never write them back. That's for COM-list-memory, not this task.
- **Cross-links to check:**
  - `ContainerDetailPage.tsx:229` (→ vendor) and `:471` (→ data asset)
  - `SoftwareAssetDetailPage.tsx:153`
  - `inventory/LinkCards.tsx:56` (→ risk)
  - `inventory/RecertReviewsList.tsx:232` (→ recert instance)
- `inventory/AccessCard.tsx:254` → `/access/groups?group=…` is handled in the Access task.

**Done when:** on staging, a data asset → technology → vendor → risk chain returns step by step, and the Inventory step reopens the tab you left. No Vendors or Inventory page has a fixed back link.