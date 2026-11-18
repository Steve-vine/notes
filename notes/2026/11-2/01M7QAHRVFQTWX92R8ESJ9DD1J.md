---
id: 01M7QAHRVFQTWX92R8ESJ9DD1J
created: 2026-11-18T12:36:48.111792Z
updated: 2026-11-18T20:35:36.39118Z
type: task
title: Double-click a flowchart shape to edit its label right on the canvas
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1941
sprint: s6y6p7g
comments:
- id: 01M7QZ21AC737RHATDT9H6190Q
  author: Steve Vine
  at: 2026-11-18T18:35:12.588714Z
  text: |-
    Done — PR #1952, merged f6d5b580.
    To edit a label on the canvas, double-click a shape or a connection, or select it and press Enter or F2. The label turns into an edit box where it is, with its text selected.
    Typing changes the label as you go. The side panel's Label box shows the same text, and the shape grows to fit.
    Enter keeps the change, Shift+Enter starts a new line in a shape's label, Escape puts it back, and clicking away keeps it. The whole edit is one Undo, and the keyboard goes back to the canvas afterwards.
    A shape's label can now run over several lines. The canvas, picture, PDF and Word keep the breaks. The plain text, Compare versions, link lists and Polaris read it as one line.
    Assumptions: connection labels stay on one line. A Group's title is still edited in the side panel. Extra spaces and blank lines are tidied away when an edit is kept.
    To check on staging: double-click a shape, type a long label with a Shift+Enter in it, press Enter, then Undo once; double-click a Yes/No line and rename it.
- id: 01M7R5YFT7457M06X5ZH5TAY7T
  author: Steve Vine
  at: 2026-11-18T20:35:36.390987Z
  text: |-
    Pre-UAT round 2 on staging cbacf0c2 — Passed
    As E2E Admin A on "E2E pre-UAT COM-1945 canvas round 2".
    - Edit in place by double-click, Enter or F2, for every shape and for connection labels: Passed.
      - Double-click opened an in-place edit box with all the text selected on Start/End, Step, Decision, Document, Input/Output, Hand-off and Note. Enter and F2 did the same on a selected shape.
      - Double-clicking the "Yes" connection opened its label in place; renamed to "Approved".
    - Enter, Shift+Enter, Escape and click-away: Passed.
      - Typed "Check the approval with the requester", Shift+Enter, "by phone", Enter. The label kept the line break on the canvas, in the picture and in the PDF.
      - F2, typing, then Escape put the old label back.
      - Double-click, typing, then clicking empty canvas kept the change.
      - Double-clicking empty canvas only zooms, as before.
    - Side panel and in-place edit show the same text: Passed. The panel's Label box followed every keystroke, including the line break.
    - Keyboard returns to the canvas: Passed. After Enter, Escape or click-away, focus is back on the canvas; arrows then nudged the shape.
    - One undoable change: Passed. One Undo emptied the whole multi-line label; Redo brought it back.
    - Tests: Passed. labelEdit.test.tsx on main (COM-1941).
    Observations:
    - On a connection label, Shift+Enter keeps the edit (connection labels are one line, as assumed). A further Enter then reopens the edit box.
    - The shape didn't grow while I typed that 3-line label into a 160×60 step. The text fits, but its last line sits almost on the border.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1941/ (r2-*)
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing on staging, 2026-11-18: for speed, double-clicking a shape should let you edit its label where it is, instead of selecting it and then clicking into the Label box in the side panel.

**What the author sees**
- Double-clicking a shape (or pressing Enter or F2 with it selected) turns its label into an edit box in place, sized to the shape, with the text selected.
- Typing changes the label live, and the side panel's Label box follows. The shape grows to fit as COM-1940 sets out, so the text is never hidden.
- Enter keeps the change, Shift+Enter adds a new line, and Escape cancels. Clicking elsewhere also keeps it.
- After editing, the keyboard goes back to the canvas, so Delete, Tab and the arrows act on the shape again (as COM-1933 set up).
- Double-clicking a connection edits its label (e.g. Yes / No) the same way. Double-clicking empty canvas does nothing new.
- Each edit is one undoable change.

**Done when**
- A label can be edited in place by double-click, Enter or F2, for every shape and for connection labels, with Enter, Shift+Enter, Escape and click-away behaving as above.
- The side panel and the in-place edit always show the same text.
- The keyboard returns to the canvas afterwards.
- Tests cover editing, cancelling and a multi-line label.

Independent: frontend. Builds on COM-1940 for shapes growing to fit.