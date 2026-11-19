---
id: 01M7TNFTPJZG5PAXZRA099TD47
created: 2026-11-19T19:45:42.098911Z
updated: 2026-11-19T21:37:27.825925Z
type: task
title: Each side panel of the flowchart editor has a small icon to hide and show it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1994
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Steve's smoke test of round 2: add a small icon on each side panel to hide and show it, to give the canvas more room.

The side panels are:
- the panel on the right of the canvas: the selected shape, line or Group, Lanes, Style and Ask Polaris;
- the new shapes bar on the left (COM-1993).

**Done when**
- Each side panel has a small icon at its top edge (a chevron or panel icon) that hides it. When hidden, the panel folds to a thin strip with the same icon, which shows it again.
- The canvas widens into the freed space straight away. The flowchart stays where it was on screen and doesn't jump.
- Hiding the right panel doesn't lose what was in it: the selection, a half-typed label, an open Lanes or Style section and a waiting Polaris proposal are all still there when it's shown again.
- With the right panel hidden, something that needs it brings it back: pressing Ask Polaris, or double-clicking a Group to edit its title. Selecting a shape doesn't.
- Each panel's hidden or shown choice is remembered for the person across flowcharts and browsers, like the light/dark canvas choice (COM-1947).
- It works in a document's flowchart, a standalone flowchart and full screen, on light and dark canvases. Each icon is a named button with a tooltip ("Hide shapes" / "Show shapes", "Hide panel" / "Show panel") and works from the keyboard.
- Tests cover hiding and showing each panel, the canvas getting the room, and the choice being remembered.

Relates to COM-1993 (left shapes bar): whichever is built second adds the icon to the other's panel.

Independent unless "remembered across browsers" needs a new saved preference. If so it joins the chain.