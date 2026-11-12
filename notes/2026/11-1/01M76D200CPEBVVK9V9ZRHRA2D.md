---
id: 01M76D200CPEBVVK9V9ZRHRA2D
created: 2026-11-11T22:53:31.53263Z
updated: 2026-11-12T12:33:00.502398Z
type: task
title: 'The floating menu replaces the left-hand menu: a Compass button (or M) opens pinned tiles, Find a page, and eight groups with their pages'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1744
sprint: spsp226
blocked_by:
- 01M76D0RXQK1XNMT7E8JQMPYKQ
- 01M76D1CSEX56EJ1HQ27QQ1ATK
comments:
- id: 01M76HJQE5CC0E1FKHVGRX9V31
  author: Steve Vine
  at: 2026-11-12T00:12:34.117658Z
  text: |-
    Done, merged in PR #1740 (frontend only).

    What you'll see:
    - There's no left-hand menu, and every page uses the full width.
    - Top left is the Compass ▾ button, with the trail beside it. The rest of the top bar is unchanged.
    - The button or M opens the menu over a dimmed page. M, Esc, a click outside or choosing a page closes it. M and 1–6 do nothing while you type in a field.
    - Pinned tiles:
      - Each tile shows its icon and name, and Actions shows your open actions (the same figure as the Dashboard).
      - Six to a row, wrapping. Only the first row carries 1–6.
      - Drag to reorder across rows, and the ✕ on each tile unpins.
    - Find a page ranks by name, then description, then group. Enter opens the highlighted match.
    - The eight groups have their icons and page counts. Each page shows its description and a pin (outline, or filled when pinned), and the menu opens on the group of the page you're on.
    - Keyboard: arrows, Enter, P to pin, ← back.
    - On narrow screens the menu fills the width, with the groups above the pages and three tiles to a row.
    - The environment and build line, and the key hints, sit at the foot of the menu.

    Built to your Claude Design. I compared screenshots against the design source and had the group icons, the pin on every page, the always-visible ✕, the 760px width and the borderless Find row matched. I also let a long tile name such as "Vendor Management" wrap instead of being cut off.

    Calls made:
    - The company's public Trust Centre link reads "Public Trust Centre", so it isn't confused with the Trust Centre page. Find a page leaves it out because it leaves Compass.
    - M still closes the menu while Find a page is empty, because your cursor starts there. Once you've typed, it types.
    - The Compass Portal keeps its own sidebar, because ADR 0152 covers the app only.
    - Pin buttons are skipped by Tab; use P.

    Tests: menu tests cover visibility by permission, opening group, search ranking, first-row numbers, M/Esc/outside click, the typing guard, reordering that keeps pins you can't currently see, unpin and P. Older tests that clicked the sidebar now go through the menu. The Browser smoke now walks every group and page; it runs on the staging deploy.

    Screenshots (light and dark, 1440, 900 and 390 wide): ~/compass-uat/spsp226/COM-1744/.
- id: 01M77BNG3XEQNZNH85SQPXRXBW
  author: Steve Vine
  at: 2026-11-12T07:48:27.901336Z
  text: |-
    Pre-UAT on staging (7ff9a75d): Passed, with one defect found and fixed forward (COM-1745).

    As E2E Admin A:
    - There's no left-hand menu, and the page uses the full width. Compass ▾ is top left with the trail beside it ("SAP › SAP-70 · …").
    - M opened the menu. Pinned Dashboard and Actions, with Actions showing 810, the same as the Dashboard's My actions tile. Below them are Find a page, the eight groups with icons and counts, and the env/build line at the foot.
    - Pinning 6 more: the seventh and eighth wrapped onto a second row with no numbers. Dragging Evidence onto tile 1 renumbered everything. Pressing 4 opened Risks.
    - On /risks the menu opened on Posture with Risks highlighted.
    - Find a page: "privacy" listed the People & privacy pages; Enter opens the top one.
    - Browser smoke on the deploy (every screen and tab for each test account, now through this menu) was green.

    As E2E Viewer:
    - Only Overview (3), Playbook, Posture (6), People & privacy (1) and Third parties & trust (2). No Exposure, Assurance or Admin. Pins are Dashboard and Actions.

    Defect: pinned tiles cut off a one-word name ("Assessme…", "Vulnerabili…"). Logged as COM-1745 and fixed in PR #1742: the number is now a plain digit in the corner, as in your design.

    Screenshots: ~/compass-uat/spsp226/COM-1744/ (1744-01..04 are from staging).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Builds the new menu recorded in COM-1742, using the pins saved by COM-1743 (stacks on it). **Spec:** Claude Design project **"Compass app navigation redesign"** (`459b22e2-d5ab-45f6-91de-c5834206ff0e`), `Navigation Concepts.dc.html`: turn **2a** (dark) and **3a** (light). Match the design except where noted.

### The top bar
- The left-hand menu goes; every page uses the full width.
- **Top left:** the **Compass ▾** button (the compass mark and the name), highlighted while the menu is open.
- **Beside it:** today's **trail** (the way you came), not the design's "Group › Page". This is Steve's call.
- **The rest is unchanged:** search (⌘K), company switcher, theme, suggestions, notifications, Polaris and your initials.

### The menu
- **Opening and closing:** opens from the button or **M**, over the page with the page dimmed behind it. It closes on **M**, **Esc**, a click outside it, or choosing a page.
- **Pinned tiles** sit across the top: icon, name, and a count where there is one (Actions shows your open actions).
  - **Six to a row; more wrap onto further rows.** Only the **first row** shows and answers the number keys **1–6** (Steve's call).
  - **Drag to reorder**, across rows as well as along them. Tiles glide to their new place, as in the design.
  - **✕ unpins.** Hidden when nothing is pinned.
- **Find a page…** searches every page the person can see: name first, then description, then group, ten at most. "Nothing matches '…'" if none.
- **Groups and pages:**
  - Groups down the left, each with its page count. Pointing at or clicking a group shows its pages on the right, two columns wide.
  - Each page shows its icon, name, description and a **pin** button (filled when pinned). The page you're on is highlighted.
  - The menu **opens on the group of the page you're on**.
  - Groups and pages, as recorded in COM-1742:
    - **Overview:** Dashboard, Actions, Initiatives, Reports
    - **Playbook:** Frameworks, Domains, Controls, Content, Decisions
    - **Posture:** Assessments, Gaps, Risks, Exceptions, Continuity, Checks, Compliance, Risk Assessments
    - **Exposure:** Inventory, Secrets, Vulnerabilities, Security Feed, Incidents
    - **People & privacy:** Access Control, Attestations, Data Subject Requests, User Portal
    - **Third parties & trust:** Vendor Management, Trust Centre, DDQ, Contracts, plus the public Trust Centre link when the company has a live page (opens in a new tab, as today)
    - **Assurance:** SAP, Audits, Evidence
    - **Admin:** Admin, Integrations, Activity, System status
- **Keyboard:**
  - **↑ ↓** move through the groups; **→** or **Enter** goes into the pages; arrows move round the two columns; **←** goes back.
  - **Enter** opens a page; **P** pins or unpins it.
  - While searching, the arrows move through the matches.
  - **M** and the number keys do nothing while typing in any field on the page.
- **What people see:** groups and pages a person can't see don't appear, and a group with nothing visible is hidden. Pins to pages they can't see are left out.
- **Light and dark** both, from today's colours.
- **Narrow screens:** the menu fills the width, with the groups stacked above the pages.
- **Gone with the sidebar:** the fold-to-icons toggle and its remembered setting, and Assessments' focus mode asking the sidebar to collapse. Focus mode keeps everything else it does.

### Tests
- The Browser smoke (every screen and tab for each test account) reaches pages through the new menu.
- Screen-conventions checks that referred to the sidebar are updated.

**Done when:**
- No left-hand menu on any page; the Compass button and the trail sit top left.
- M and the button open the menu; Esc, M, outside-click and choosing a page close it.
- Pin, unpin and drag-reorder work, and survive a reload and another browser (COM-1743). The first six tiles answer 1–6, and a seventh wraps to a second row with no number.
- Find a page finds pages by name and description and opens them with Enter.
- Every page is reachable from its group. A test account with limited rights sees only its own groups and pages.
- Works in light and dark, and at laptop and narrow widths.