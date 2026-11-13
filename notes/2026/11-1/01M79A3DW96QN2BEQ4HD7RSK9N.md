---
id: 01M79A3DW96QN2BEQ4HD7RSK9N
created: 2026-11-13T01:59:36.073992Z
updated: 2026-11-13T14:32:45.432224Z
type: task
title: On a phone, a screen with tabs doesn't scroll sideways
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1781
sprint: spsp226
comments:
- id: 01M7A7E2RAW5X25J6YD5WXJ4KF
  author: Steve Vine
  at: 2026-11-13T10:32:13.830268Z
  text: |-
    Built — PR #1777 (feature/com-1781-tabs-phone-width, b51b79b9), auto-merge set. Frontend only.

    What changed: the tab row keeps a hidden copy of every tab to work out which ones fit before the rest go under "More". That copy was laid out at full width off the right-hand edge, which widened the page. It now sits in a zero-size box that clips anything spilling out. It measures the same as before, so the same tabs fold under "More".

    Measured in real Chromium at 390px as Admin A against staging data (sideways scroll, before → after):
    - Vulnerabilities 63 → 0
    - Inventory 275 → 0
    - Audit ▸ Evidence 124 → 0
    - Vendors 403 → 0

    The number of tabs under "More" is unchanged. At 800px, Access Control was 570px too wide and is now 0. 1440px is identical before and after. Screenshots are in ~/compass-uat/spsp226/COM-1781/.

    Browser smoke: phone.spec.ts now checks Vendors for Admin A and the Viewer. It checks the page doesn't scroll sideways, and where there is a "More", that it holds as many tabs as its label says.

    Note: the Viewer can't open Vulnerabilities, Inventory or Audit ▸ Evidence, so for the Viewer only Vendors can be checked. It already fitted.

    Checks: eslint, tsc, prettier and the full vitest suite (4016 tests) pass. The new phone check fails against today's staging and passes with this build.
- id: 01M7AN6G3RRXRB34JYGZ62XDAR
  author: Steve Vine
  at: 2026-11-13T14:32:45.432079Z
  text: |-
    Pre-UAT on staging ee0d160c, E2E Test Company: **Passed**.

    At 390x844, as Admin A, I opened Vulnerabilities, Inventory, Audit ▸ Evidence and Vendors. On each I measured the sideways overflow and tried scrolling it 500px right. None scrolls sideways (0px), with "More" closed or open. "More" holds the tabs that don't fit:
    - Vulnerabilities: Unmatched, Settings
    - Inventory: Data assets, Software assets, Discovered, Settings
    - Audit ▸ Evidence: By framework, Archived, Audit packs
    - Vendors: Assessments, Assessment rules, Compliance rules, Approval rules, Portal

    Viewer at 390px:
    - Vulnerabilities, Inventory and Audit ▸ Evidence show "You need permission to view …". None of them scrolls sideways.
    - Vendors shows Register and Requests with no "More" (nothing to fold), and no sideways scroll.

    Desktop at 1440px: every tab shows in one row with no "More", for both accounts. The Browser smoke, including phone.spec, passed (32 tests).

    Screenshots: ~/compass-uat/spsp226/COM-1781/uat5-*.png
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the sprint 116 round-4 pre-UAT pass on staging (6e988b9d, 2026-11-13). Not caused by round 4.

**What happens:** at 390px, any screen with a row of tabs can be pushed sideways and its left edge disappears: Vulnerabilities 63px, Audit ▸ Evidence 120px, Inventory 274px, Vendors 396px. Screens without tabs (Dashboard, Risks, SAP, privacy requests) are fine. Likely cause: the hidden copy of the tab row used to work out which tabs fit (before the rest go under "More") is laid out at full width and widens the page.

**What it should do:** a page with tabs fits a phone's width like any other.

**Done when:** at 390px, as Admin A and the Viewer, Vulnerabilities, Inventory, Audit ▸ Evidence and Vendors don't scroll sideways and "More" still holds the tabs that don't fit; desktop unchanged; the phone Browser smoke (phone.spec.ts) checks one tabbed screen. Screenshot ~/compass-uat/spsp226/COM-1778/com1778-11-390-pane-scrolled-sideways.png. Frontend only, independent.