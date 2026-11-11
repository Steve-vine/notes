---
id: 01M76D200CPEBVVK9V9ZRHRA2D
created: 2026-11-11T22:53:31.53263Z
updated: 2026-11-11T23:22:23.277968Z
type: task
title: 'The floating menu replaces the left-hand menu: a Compass button (or M) opens pinned tiles, Find a page, and eight groups with their pages'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1744
sprint: spsp226
blocked_by:
- 01M76D0RXQK1XNMT7E8JQMPYKQ
- 01M76D1CSEX56EJ1HQ27QQ1ATK
assignee: steve
label:
- improvement
priority: medium
task_status: active
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