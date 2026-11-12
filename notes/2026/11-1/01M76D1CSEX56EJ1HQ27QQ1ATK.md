---
id: 01M76D1CSEX56EJ1HQ27QQ1ATK
created: 2026-11-11T22:53:11.854513Z
updated: 2026-11-12T12:33:00.494878Z
type: task
title: A person's pinned pages are saved to them, so they follow them to any browser; someone new starts with Dashboard and Actions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1743
sprint: spsp226
blocked_by:
- 01M76D0RXQK1XNMT7E8JQMPYKQ
comments:
- id: 01M76FCP2S3RDZZ9W9P0PNHKZS
  author: Steve Vine
  at: 2026-11-11T23:34:18.969692Z
  text: |-
    Done, merged in PR #1738 (migration 0820_user_pinned_pages adds one column to each person).

    - Pins are an ordered list saved on the person's own account, so they're the same in any browser.
    - Someone who has never pinned anything gets Dashboard and Actions. Nothing is stored for them, so existing staff get this on day one.
    - Unpinning everything is kept as no pins. It doesn't fall back to Dashboard and Actions.
    - Only the person can read or change their pins. They're not on the user record, so administrators can't see them either.
    - A pin to a page they can't currently see stays saved. The menu leaves it out and shows it again when access returns.
    - At most 40 pins. A page pinned twice is kept once.

    There's nothing on screen until the menu (COM-1744), which is being built on this now.

    Tests: 24 integration tests (saving and reading back, default vs none, per person only, limits), the migration up/down test, and frontend tests for the helper that picks the visible pins.
- id: 01M77BNAD07876EJCYVW03K964
  author: Steve Vine
  at: 2026-11-12T07:48:22.048655Z
  text: |-
    Pre-UAT on staging (7ff9a75d), as E2E Admin A: Passed.

    1. On first sign-in the menu showed Dashboard and Actions pinned (the default).
    2. I pinned six more: Risks, Gaps, Assessments, Vulnerabilities, Inventory and Evidence.
    3. I reloaded, then closed the browser and signed in again in a fresh, empty browser. All 8 pins came back in order, so they follow the person, not the browser.
    4. I dragged Evidence onto the first tile. The new order (Evidence, Dashboard, Actions…) is what the next page load showed.
    5. The Viewer, who has never pinned anything, sees Dashboard and Actions.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Part of the new menu (ADR task COM-1742; design: Claude Design project "Compass app navigation redesign", `Navigation Concepts.dc.html`, turn 2a). **On the chain:** it adds a migration and changes the API.

**What it does:**
- A person's pinned pages are an **ordered list saved with their own preferences**, like their time zone and mail settings. They see the same pins in any browser or on any computer they sign in on.
- **Someone who has never pinned anything** gets **Dashboard and Actions**. This covers existing staff on the day it ships, as well as new joiners.
- **Unpinning everything** is kept as an empty list. It doesn't fall back to Dashboard and Actions.
- Only the person can read or change their own pins. Nobody else's pins are visible or changeable, administrators included.
- **A pin to a page the person can no longer see** (their role changed) is kept but not shown. It comes back if they regain access. Pins name pages, not records.
- The pin list has a sensible upper limit (around 40, more than the number of pages) so it can't grow without bound.

**Not in this task:** the menu that shows and reorders the pins (the menu task, which builds on this one).

**Done when:**
- A person's pins, in order, are saved and read back as theirs, and survive signing out and in on another browser.
- Someone with nothing saved reads Dashboard and Actions.
- One person can't read or change another's pins.
- A pin to a page they can't see isn't returned to the menu, and returns when access does.