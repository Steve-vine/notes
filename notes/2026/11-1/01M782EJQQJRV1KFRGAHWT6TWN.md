---
id: 01M782EJQQJRV1KFRGAHWT6TWN
created: 2026-11-12T14:26:38.455181Z
updated: 2026-11-12T14:32:02.803172Z
type: task
title: On a phone, the top bar's right-hand buttons (notifications, Polaris, your menu and Sign out) can be reached
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1759
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
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