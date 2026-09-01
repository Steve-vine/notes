---
id: 01M0MDW7JAM56AKW4ABB33W83F
created: 2026-08-22T09:47:20.522066Z
updated: 2026-09-01T13:55:50.268063Z
type: task
title: 'Portal side menu: a Modules section with Vendors and Access Control pages'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 351
sprint: sbph5q5
comments:
- id: 01M0MQ1D6C565N9S8N6FPA3958
  author: Steve Vine
  at: 2026-08-22T12:27:27.308727Z
  text: |-
    Done — PR #355, merged to main.

    The portal has a sidebar of the same shape as the internal app: a **Modules** section holding **Vendors** and **Access Control**, each a page carrying its own tabs.

    The nav model is **mirrored, not shared** (`components/portalNav.ts`). The two lists answer different questions — "what can this operator reach in Compass" vs "what modules does this employee have a page for" — and importing `nav.ts` to filter it would make every section added there one more thing to remember to exclude here. That is the exact failure mode `PortalLayout`'s own docstring warns about for the shell.

    **Every URL survives.** The module pages are layout routes, so `/portal/my-vendors`, `/portal/requests`, `/portal/approvals`, `/portal/recertifications` and the detail pages are untouched. `/portal/vendors` becomes the Register, above the detail page that already lived under it. `/portal/access` is new — Access Control's stable index, so a second tab is an addition rather than a restructure.

    `/portal` had to change: it *was* the register, and a recertifier-only account sent there would be bounced by `RequireSection`. It is now the module chooser. An account with **no** portal grant is still sent to Vendors on purpose, so the refusal it always got is the refusal it still gets — landing it on the one page outside that gate would have turned a clear refusal into a page it was never offered.

    **"Register", not "All Vendors"** — COM-220's qualifier existed to stop an unqualified "Vendors" reading as the default rather than the whole list, an argument about a top-level tab. Inside a page already called Vendors it is noise.

    ## The two things this task flagged, resolved

    **1. The task predates COM-349.** It asks the Vendors page to host "My requests" and "My Approvals" as separate tabs; COM-349 has since merged them into one **Requests** section with two slices. Splitting them back apart to satisfy a task written before that decision would undo it — so Requests moves as one tab. This is the reconciliation the task asked for.

    **2. Access Control is ungated, and the task's two requirements conflicted.** "Mirror the current per-tab visibility" and "a vendor-only account sees no Access Control entry" cannot both hold: the Recertifications tab carries **no gate today**, and ADR 0047 §6 is why — recertification is *assignment-scoped, not role-gated*. Gating the entry on a recertification role would lock out exactly the case the ADR was written for: a vendor user made an owner of a review. Current behaviour kept; a test pins the reasoning.

    Tests: Modules section and entries; per-role visibility; tab lists per role mix; the Register rename; recertifier lands on Access Control with no Vendors entry; vendor user still sees Access Control; the one-tab bar kept. `expectNoInternalNav()` replaces the old "there is no navigation" assertion — the portal has one of its own now, so the claim becomes "the navigation is not *that* one".
assignee: steve
label:
- improvement
priority: medium
task_status: done
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