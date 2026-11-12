---
id: 01M782EJQQJRV1KFRGAHWT6TWN
created: 2026-11-12T14:26:38.455181Z
updated: 2026-11-12T15:26:32.283396Z
type: task
title: On a phone, the top bar's right-hand buttons (notifications, Polaris, your menu and Sign out) can be reached
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1759
sprint: spsp226
comments:
- id: 01M785W63K02K334D1DP7JEN1W
  author: Steve Vine
  at: 2026-11-12T15:26:29.999472Z
  text: |-
    Built — PR #1755 (auto-merge set), commit 528b6145. Frontend only.

    What you'll see on a phone (narrower than 576px):
    - Always on screen: the Compass button, search, notifications, Polaris and your initials.
    - The trail gives way first: "…" and the page you're on (the "…" holds every earlier step).
    - The company name gives way next, ending in an ellipsis; you can still switch company.
    - The colour scheme and the light bulb move into your menu: Preferences, (Connect Polaris), Light / Dark / System, Issues and improvements, Log out.
    - Page buttons and filter-bar toggles wrap instead of running off the edge — on every page using the shared page header, detail header or filter bar, not just SAP. SAP no longer scrolls sideways at 390px (was 562px wide in a 376px pane); its wide table scrolls inside itself.
    - Desktop unchanged (every control in the same place at 1440px).

    Why: nothing in the bar could shrink (the company switcher was a fixed ~186px and all eight controls stayed in the bar), and page header buttons and filter toggles were set never to wrap.

    Checked in a real browser (headless Chromium against staging's API, local build), E2E Admin A and E2E Viewer, light and dark, Dashboard, SAP and a four-step-deep page, at 390px (also 360 and 600): every control on screen and working, Log out included. At 390px, before → after: Notifications 390–424 → 268–302, Polaris 430–464 → 308–342, user menu 470–500 → 348–378, "Add entry" 321–437 → 260–376, "Owned by me" 513–576 → 279–376. Screenshots ~/compass-uat/spsp226/COM-1759/.

    Also: new Browser smoke test (phone.spec.ts) — at 390px every top-bar control is on screen for Admin A and the Viewer, Log out reachable, SAP's buttons on screen and no sideways scroll. It fails on today's staging and passes on this build. eslint, tsc, prettier clean; full vitest suite passes.

    Note: the menu still says "Log out", not "Sign out".

    Found, not done: at 390px the Dashboard still scrolls sideways by 175px — its "Compliance by domain" table widens the page instead of scrolling inside itself. Logged separately.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the sprint 116 round-2 pre-UAT pass on staging (2026-11-12). It dates from COM-1744's new top bar: COM-1744's own narrow screenshot (`~/compass-uat/spsp226/COM-1744/10-narrow-light-closed.png`) already shows the bar clipped.

**What happens:** at phone width (390 px), the top bar is 499 px wide and the page doesn't scroll sideways, so its right-hand end is cut off and can't be reached:
- Admin A: Notifications (x 389), Polaris (x 429) and the user menu (x 469) are all off-screen.
- Viewer: Notifications (x 395) and the user menu (x 435) are off-screen.
- So on a phone you can't open notifications or Polaris, or **sign out**.
- On SAP, the "Add entry" button and the "Owned by me" switch are also cut off at the right edge.

**What it should do:** every top-bar control is reachable at phone width. The trail gives way first (it shortens or truncates); the Compass button, notifications, Polaris and the user menu always stay on screen. A page's own header actions wrap rather than run off the edge.

**Done when:**
- at 390 px, as Admin A and as the Viewer, on the Dashboard, SAP and a deep page with a long trail, every top-bar control is on screen and works, Sign out included;
- SAP's header actions ("Add entry", "Owned by me") are reachable at 390 px;
- desktop is unchanged;
- light and dark checked, and there are no errors in the browser console.

Screenshots: `~/compass-uat/spsp226/extra/extra-topbar-390-dashboard.png`, `extra-topbar-390-viewer.png`. Frontend only, independent.