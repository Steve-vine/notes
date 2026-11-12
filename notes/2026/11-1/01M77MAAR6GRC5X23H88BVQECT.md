---
id: 01M77MAAR6GRC5X23H88BVQECT
created: 2026-11-12T10:19:39.142946Z
updated: 2026-11-12T14:26:18.512865Z
type: task
title: The floating menu keeps one height as you move between groups, and its bottom row loses the key hints
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1749
sprint: spsp226
comments:
- id: 01M77XZ0FJZM676S078JXS5R6K
  author: Steve Vine
  at: 2026-11-12T13:08:13.937821Z
  text: |-
    Built: PR #1745 (auto-merge set, frontend only).

    What you'll see:
    - The menu's foot shows only the environment and build line; the key hints are gone.
    - The menu opens at one height (the taller of the group list and the tallest group that person can see) and keeps it while you point at each group or type in Find a page. Shorter groups leave space below; Find a page's matches scroll inside that height, and arrowing through them keeps the highlighted one in view.
    - The height changes only when the pins gain or lose a row, or the window is too short (then the menu fits the window and the pages scroll). Narrow screens follow the same rule.

    Measured in a headless browser, every group then Find a page ("a", "risk", "zzz", cleared), no console errors:
    - Admin 1440×900, light and dark: 548.6px throughout, bottom edge fixed (before: 253–789.5)
    - Viewer 1440×900: 437.1px (before 253–789.5)
    - Admin narrow 390×1000: 928.8px; Viewer dark narrow: 738.6px
    - Two rows of pins: 634.6px; short window 1440×520: 448px, pages scroll

    Note: for Admin the tallest group is actually Exposure (its descriptions wrap to two lines), not Posture; the height follows whichever is really tallest. So on Overview/Playbook/Assurance the menu is ~39px taller than before, with space at the bottom, as asked.

    Checks: lint, types, format clean; menu tests 27/27 (foot holds only the version line; one hidden list per visible group; only the pointed-at group shows); full frontend suite green apart from a known House Styles undo/redo flake that fails on unchanged main too.
- id: 01M782DZ8GSXF47EN6Q8TY1TA4
  author: Steve Vine
  at: 2026-11-12T14:26:18.51265Z
  text: |-
    Pre-UAT (staging 80ffc250, E2E Test Company): Passed.
    - Foot shows only "staging · 20261112-1345"; no key hints.
    - Menu box measured while pointing at every group and typing in Find a page ("r", "risk", "zzzz", "evidence", cleared); one size per setup, bottom edge never moved:
      - Admin A (8 pins) 1440 light/dark: y 60–713 (653px)
      - Admin A 390 light/dark: y 8–836 (828px)
      - Viewer (2 pins) 1440 light/dark: y 60–497 (437px)
      - Viewer 390 light/dark: y 8–747 (739px)
    - No sideways page scroll; no console errors. At 390px the group name "Third parties & …" is cut short (cosmetic).
    Screenshots: ~/compass-uat/spsp226/COM-1749/
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging (2026-11-12), follows COM-1744 (ADR 0152).

**1. Remove the key hints from the bottom row.** The menu's foot reads "[M] open and close · [1]–[6] pinned · [P] pin · [Esc] close". Take that text out. The environment and build line stays in the foot, on its own.

**2. One height, whatever the group.** At the moment the menu grows and shrinks as you point at each group, because its height follows that group's number of pages, and the movement is distracting. The menu should open at one height and keep it while you move between groups:
- the height is set by whichever is taller, the tallest group's pages (Posture, eight pages, in two columns) or the list of groups;
- a group with fewer pages leaves empty space below them, and the menu doesn't shrink;
- Find a page keeps the same height too; its up to ten matches scroll inside it if they need more room;
- the height only changes when the pinned tiles gain or lose a row, or the window is too short (the menu then fits the window and the pages scroll);
- narrow screens (groups stacked above the pages) follow the same rule.

**Done when:**
- the foot shows only the environment and build line;
- pointing at each of the eight groups in turn, and typing in Find a page, leaves the menu's height and its bottom edge where they are, as Admin A and as the Viewer (who sees fewer pages);
- light and dark, and a narrow window, all checked;
- there are no errors in the browser console.

Frontend only: `components/CompassMenu.tsx` and its menu CSS in `index.css`.