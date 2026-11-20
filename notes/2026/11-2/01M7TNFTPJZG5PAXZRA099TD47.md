---
id: 01M7TNFTPJZG5PAXZRA099TD47
created: 2026-11-19T19:45:42.098911Z
updated: 2026-11-20T14:05:05.094206Z
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
- id: 01M7V3SDTN544MAH5EHDF1VTJF
  author: Steve Vine
  at: 2026-11-19T23:55:36.661124Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Couldn't check (everything passed except one point, which needs Polaris's AI provider)
    - An icon at each panel's top edge hides it; hidden, a thin strip with the icon shows it again: Passed. As E2E Admin A: "Hide shapes" on the left bar and "Hide panel" on the right. Each folds to a thin strip with a "Show shapes" / "Show panel" button.
    - The canvas widens at once and the flowchart doesn't move: Passed. The canvas went from 1073px wide to 1085 (shapes hidden) to 1370 (both hidden). A shape I measured stayed at exactly the same place on screen throughout.
    - Hiding the right panel loses nothing: Passed for the selection and a half-typed label. I selected "Signed contracts", typed " half-typ" into its Label, hid the panel, then showed it again: still selected, label still "Signed contracts half-typ". Lanes and Style aren't folding sections on this build, so there's nothing open to lose there. A waiting Polaris proposal: Couldn't check. It needs Polaris's AI provider. Steve: ask Polaris on a canvas, hide the panel while the proposal waits, then show it again.
    - With the panel hidden, Ask Polaris or double-clicking a Group brings it back; selecting a shape doesn't: Passed. Selecting "Log the request" left it hidden. Ask Polaris brought it back with the Ask Polaris box. Double-clicking the Group's title brought it back too.
    - Remembered for the person across flowcharts and browsers: Passed. The choice is saved with the person: after hiding both, their saved preferences show shapes hidden and panel hidden. I then opened a different flowchart (COM-1907's, opened and cancelled, nothing changed) in a fresh browser context with empty local storage, and both panels opened hidden.
    - In a document's flowchart, a standalone flowchart and full screen, light and dark; named buttons with tooltips; keyboard: Passed on a standalone flowchart (light canvas) and a document's flowchart (the panels open as last chosen there). Tooltips read "Hide shapes" / "Show panel"; Enter and Space toggle the focused button. There's only one editor; full screen in the reading view has no editor.
    - Tests: Passed. sidePanels.test.tsx and a backend preference test were added.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1994/
assignee: steve
label:
- improvement
priority: medium
task_status: done
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