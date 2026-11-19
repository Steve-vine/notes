---
id: 01M7TNFTPJZG5PAXZRA099TD47
created: 2026-11-19T19:45:42.098911Z
updated: 2026-11-19T22:08:49.044443Z
type: task
title: Each side panel of the flowchart editor has a small icon to hide and show it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1994
sprint: s6y6p7g
comments:
- id: 01M7TXNR23903153ZG221G3V07
  author: Steve Vine
  at: 2026-11-19T22:08:44.611648Z
  text: |-
    Done — PR #1995, merged 1c092b29.
    Each side panel of the flowchart editor has a small arrow button at its top edge: "Hide shapes" on the shapes bar, "Hide panel" on the right-hand panel. Hidden, a panel folds to a thin strip with a "Show" button, and the canvas takes the room at once without the flowchart moving on screen.
    The right panel keeps everything while hidden: the selection, a half-typed label, open Lanes or Style sections and a waiting Polaris proposal are all still there when it's shown again.
    With the right panel hidden, pressing Ask Polaris or double-clicking a Group to edit its title brings it back. Selecting a shape doesn't.
    Each choice is remembered for the person on every flowchart and in any browser, like the canvas's light/dark choice. It applies to a document's flowchart, a standalone flowchart and full screen.
    Assumption: when Ask Polaris or a Group's title brings the panel back, it stays shown next time too.
    To check on staging: hide each panel, reopen a different flowchart (or another browser) and see it still hidden; hide the right panel while typing a label, then show it again.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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