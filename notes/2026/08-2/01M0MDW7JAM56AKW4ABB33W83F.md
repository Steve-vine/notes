---
id: 01M0MDW7JAM56AKW4ABB33W83F
created: 2026-08-22T09:47:20.522066Z
updated: 2026-08-22T11:49:23.244501Z
type: task
title: 'Portal side menu: a Modules section with Vendors and Access Control pages'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 351
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The user portal is currently one flat top tab bar (`PortalLayout.tsx`): All Vendors / My Vendors / My requests / My Approvals / Recertifications. Restructure it to match the admin portal's shape — a side menu — so the portal grows the same way the internal app does.

## Layout

- [ ] `PortalLayout` gets a sidebar like the admin `AppLayout`/`nav.ts` pattern (sections → gated items), with a single section **Modules** containing two entries: **Vendors** and **Access Control**. Reuse/mirror the nav model rather than inventing a second one — same icons family, same "header appears once at least one item is visible" rule.
- [ ] The top tab bar goes; each page carries its own tabs instead.

## Vendors page

- [ ] Hosts the vendor tabs: **Register** (renamed from "All Vendors" — aligns with the admin page; the COM-220 naming argument is retired now the tab lives inside a page already called Vendors), **My Vendors**, **My requests**, and **My Approvals** (approvers only, COM-226).
- [ ] Note: the ask said "the 3 vendor tabs" — there are four with My Approvals; it moves too, else approvers lose their surface. Flagged in case a different home was intended (e.g. COM-349's Requests section, which this restructure should be reconciled with when that task is picked up).
- [ ] Visibility: the Vendors entry shows for anyone with portal vendor read, as the tabs do today; tab-level gating (`canReadVendors` / `canAssess`) is unchanged, just relocated.

## Access Control page

- [ ] Hosts the single **Recertifications** tab (ADR 0047 §6) — the page exists so the module has room to grow, so keep the tab bar even with one tab.
- [ ] A recertifier-only account lands here and sees no Vendors entry; a vendor-only account sees no Access Control entry (mirror the current per-tab visibility, promoted to page level).

## Routes & tests

- [ ] Keep existing deep-link paths working (`/portal/vendors`, `/portal/my-vendors`, `/portal/requests`, `/portal/approvals`, `/portal/recertifications` and their detail pages) — the pages move under a layout, the URLs shouldn't break; redirect any that must change.
- [ ] `PortalRouting.test`, `PortalLayout` tests: nav entries gate correctly per role mix; the Register rename appears; default landing per role (vendor roles → Vendors, recertifier-only → Access Control).