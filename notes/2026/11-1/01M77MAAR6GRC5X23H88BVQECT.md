---
id: 01M77MAAR6GRC5X23H88BVQECT
created: 2026-11-12T10:19:39.142946Z
updated: 2026-11-12T10:19:40.934779Z
type: task
title: The floating menu keeps one height as you move between groups, and its bottom row loses the key hints
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1749
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: todo
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