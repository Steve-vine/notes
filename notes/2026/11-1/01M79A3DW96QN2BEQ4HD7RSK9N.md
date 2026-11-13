---
id: 01M79A3DW96QN2BEQ4HD7RSK9N
created: 2026-11-13T01:59:36.073992Z
updated: 2026-11-13T10:04:26.811797Z
type: task
title: On a phone, a screen with tabs doesn't scroll sideways
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1781
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13). Not caused by round 4.

**What happens:** at 390px, any screen with a row of tabs can be pushed sideways and its left edge disappears: Vulnerabilities 63px, Audit ▸ Evidence 120px, Inventory 274px, Vendors 396px. Screens without tabs (Dashboard, Risks, SAP, privacy requests) are fine. Likely cause: the hidden copy of the tab row used to work out which tabs fit (before the rest go under "More") is laid out at full width and widens the page.

**What it should do:** a page with tabs fits a phone's width like any other.

**Done when:** at 390px, as Admin A and the Viewer, Vulnerabilities, Inventory, Audit ▸ Evidence and Vendors don't scroll sideways and "More" still holds the tabs that don't fit; desktop unchanged; the phone Browser smoke (phone.spec.ts) checks one tabbed screen. Screenshot ~/compass-uat/spsp226/COM-1778/com1778-11-390-pane-scrolled-sideways.png. Frontend only, independent.